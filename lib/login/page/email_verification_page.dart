import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/login/page/set_password_page.dart';
import 'package:nexus/net/api_service.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:nexus/utils/loading_state_mixin.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with LoadingStateMixin<EmailVerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isButtonEnabled = false;
  bool _hasError = false;
  int _countdown = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_updateButtonState);
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel(); // 如果已有定时器，先取消
    setState(() => _countdown = 59);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _pinController.text.length == 6;
    });
  }

  /// “下一步”按钮的点击事件
  void _onNext() {
    runWithLoading(() async {
      FocusManager.instance.primaryFocus?.unfocus();

      // 验证码输入完成后，直接跳转到设置密码页面
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPasswordPage(
              email: widget.email,
              verificationCode: _pinController.text,
            ),
          ),
        );
      }
    });
  }

  /// “重新发送”的点击事件
  void _resendCode() {
    runWithLoading(() async {
      // 调用发送验证码的接口
      final success = await ApiService().post(
        '/v1/sign_up_email',
        data: {'email': widget.email},
      );

      // 如果发送成功，则重新开始倒计时
      if (success == true) {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 48.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: ColorUtils.mainColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '输入邮箱验证码',
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text.rich(
                        TextSpan(
                          text: '验证码已发送至 ',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                          children: [
                            TextSpan(
                              text: widget.email,
                              style: TextStyle(color: ColorUtils.mainColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildPinPut(defaultPinTheme, submittedPinTheme),
                      SizedBox(height: 12.h),
                      _buildStatusRow(),
                      SizedBox(height: 16.h),
                      _buildNextButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPinPut(PinTheme defaultPinTheme, PinTheme submittedPinTheme) {
    return Pinput(
      length: 6,
      controller: _pinController,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        setState(() {
          _hasError = false; // 用户输入时清除错误状态
        });
      },
      onCompleted: (pin) {
        _focusNode.unfocus();
      },
      defaultPinTheme: defaultPinTheme,
      submittedPinTheme: submittedPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: ColorUtils.mainColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: Colors.red),
        ),
      ),
      forceErrorState: _hasError,
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_hasError)
          Text(
            '验证码有误',
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          ),
        const Spacer(),
        // 如果倒计时大于0，显示倒计时
        _countdown > 0
            ? Text(
                '${_countdown}s 重新发送',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              )
            // 否则，显示“重新发送”按钮
            : InkWell(
                onTap: isLoading ? null : _resendCode, // 加载中不可点击
                child: Text(
                  '重新发送',
                  style: TextStyle(color: ColorUtils.mainColor, fontSize: 14.sp),
                ),
              ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isButtonEnabled && !isLoading
            ? ColorUtils.mainColor
            : ColorUtils.unUseMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: _isButtonEnabled && !isLoading ? _onNext : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ))
                : Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

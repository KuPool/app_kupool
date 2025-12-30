import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isButtonEnabled = false;
  bool _hasError = false;
  int _countdown = 59;
  Timer? _timer;

  String _verificationCode = '';

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
    _timer?.cancel(); // Cancel any existing timer
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
          _verificationCode = value;
          _hasError = false; // Clear error on new input
        });

      },
      onCompleted: (pin) {
        _verificationCode = pin;
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
        _countdown > 0
            ? Text(
                '${_countdown}s 重新发送',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              )
            : InkWell(
                onTap: () {
                  // Resend code logic
                  _startTimer();
                },
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
      decoration: BoxDecoration(
        color: _isButtonEnabled
            ? ColorUtils.mainColor
            : ColorUtils.unUseMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: _isButtonEnabled
              ? () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  // For demonstration, let's assume '111111' is wrong
                  if (_verificationCode == '111111') {
                    setState(() {
                      _hasError = true;
                    });
                  } else {
                    // Next step logic here
                  }
                }
              : null,
          child: Center(
            child: Text(
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

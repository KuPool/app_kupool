import 'package:Kupool/login/page/agreement_page.dart';
import 'package:Kupool/login/page/email_verification_page.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/net/env_config.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/loading_state_mixin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/toast_utils.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with
        AutomaticKeepAliveClientMixin<RegisterPage>,
        LoadingStateMixin<RegisterPage> { // 混入加载状态管理
  final _emailController = TextEditingController();
  // late final TapGestureRecognizer _agreementRecognizer;
  // late final TapGestureRecognizer _loginRecognizer;

  bool _isAgreed = false;
  bool _isButtonEnabled = false;
  String? _errorText;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    // _agreementRecognizer = GestureDetector()..onTap = _handleAgreementTap;
    // _loginRecognizer = TapGestureRecognizer()..onTap = _handleLoginTap;
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    // _agreementRecognizer.dispose(); // 必须释放资源
    // _loginRecognizer.dispose();
    super.dispose();
  }

  void _handleAgreementTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  AgreementPage(
          title: '用户协议',
          url: 'https://www.notion.so/traderjerry/KuPool-2947c49af15a8074a843ff780e1ffca7', // 保持占位，不拼接具体路径
        ),
      ),
    );
  }
  
  void _handleLoginTap() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _isAgreed;
      // 当用户开始编辑时，实时清除错误提示
      if (_errorText != null) {
        _errorText = null;
      }
    });
  }

  /// “下一步”按钮的点击事件处理
  void _onNextStep() {
    // 使用 runWithLoading 来自动管理加载状态和防止重复点击
    runWithLoading(() async {
      FocusManager.instance.primaryFocus?.unfocus();

      // 第一步：校验邮箱格式
      final email = _emailController.text.trim();
      // final isEmailValid = RegExp(
      //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      //     .hasMatch(email);

      if (isUnValidString(email)) {
        ToastUtils.show('请输入有效的邮箱地址');
        return; // 中断操作
      }

      // 第二步：调用接口判断邮箱是否存在
      final existsResponse = await ApiService().post(
        '/v1/user/email/exists',
        data: {'email': email},
      );

      if (existsResponse == null) return;

      final bool emailExists = existsResponse['exists'] ?? true;

      if (emailExists) {
        setState(() {
          _errorText = '该邮箱已被注册';
        });
      } else {
        // 第三步：邮箱可用，发送注册邮件
        final signUpResponse = await ApiService().post(
          '/v1/sign_up_email',
          data: {'email': email},
        );

        // 如果发送邮件请求成功(signUpResponse为true), 则导航到下一个页面
        if (signUpResponse == true && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerificationPage(email: email),
            ),
          );
        }
      }
    });
  }

  final _asciiFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[!-~]'));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '注册',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildEmailField(),
                    SizedBox(height: 36.h),
                    _buildNextButton(),
                    _buildAgreementRow(),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 226,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, -0.00),
                  end: const Alignment(0.50, 1.00),
                  colors: [const Color(0x00D9D9D9), const Color(0x160D5EF5)],
                ),
              ),
              child: Image.asset(
                ImageUtils.loginLogo,
                height: 46.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    bool showError = _errorText != null;
    const Color errorColor = Color(0xFFFF383C);

    return TextField(
      controller: _emailController,
      inputFormatters: [_asciiFormatter],
      textInputAction: TextInputAction.done,
      onEditingComplete: _onNextStep, // 点击键盘完成时也可触发
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: '邮箱',
        hintStyle: TextStyle(
          fontSize: 16.sp,
        ),
        helperText: showError ? _errorText : ' ', // 使用helperText预留空间
        helperStyle: TextStyle(color: errorColor, fontSize: 12.sp),
        helperMaxLines: 1,
        errorStyle: const TextStyle(height: 0), // 隐藏默认的errorStyle空间
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            ImageUtils.loginEmail,
            width: 24.w,
            height: 24.h,
            color: Colors.grey,
          ),
        ),
        suffixIcon: _emailController.text.isNotEmpty
            ? IconButton(iconSize: 20,
                icon: const Icon(Icons.cancel, color: ColorUtils.colorInputIcon1),
                onPressed: () {
                  _emailController.clear();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: showError ? errorColor : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: showError ? errorColor : ColorUtils.mainColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: errorColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: errorColor, width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _isButtonEnabled && !isLoading
            ? ColorUtils.mainColor
            : ColorUtils.unUseMainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isButtonEnabled && !isLoading ? _onNextStep : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isLoading ? null : () { // 加载时禁用
            setState(() {
              _isAgreed = !_isAgreed;
              _updateButtonState();
            });
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(right: 8.w,top: 16.w,bottom: 16.w),
            child: Image.asset(
              _isAgreed ? ImageUtils.checkSelect : ImageUtils.checkUnSelect,
              width: 16.w,
              height: 16.w,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  text: '已阅读并同意',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(right: 8.w,top: 16.w,bottom: 16.w),
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      _handleAgreementTap();
                    },child: Text('《KuPool用户协议》',style: TextStyle(color: ColorUtils.mainColor, fontSize: 14.sp),)),
              )
            ],
          ),
        ),
      ],
    );
  }
}

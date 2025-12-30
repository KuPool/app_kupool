import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/login/page/register_page.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:nexus/utils/image_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPasswordVisible = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  final _asciiFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[ -~]'));

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
            // 这里可以添加其他标题内容
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.opaque, // Make sure empty areas are tappable
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
                      '登录 Kupool',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildEmailField(),
                    SizedBox(height: 20.h),
                    _buildPasswordField(),
                    SizedBox(height: 40.h),
                    _buildLoginButton(),
                    SizedBox(height: 16.h),
                    _buildRegisterButton(),
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
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
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
    return TextField(
      controller: _emailController,
      inputFormatters: [_asciiFormatter],
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: '邮箱',
        hintStyle: TextStyle(
          fontSize: 16.sp,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            ImageUtils.loginEmail,
            width: 24.w,
            height: 24.h,
          ),
        ),
        suffixIcon: _emailController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.cancel, color: Colors.grey),
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
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorUtils.mainColor),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      inputFormatters: [_asciiFormatter],
      textInputAction: TextInputAction.done,
      onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: '密码',
        hintStyle: TextStyle(
          fontSize: 16.sp,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            ImageUtils.loginPass,
            width: 24.w,
            height: 24.h,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorUtils.mainColor),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: _isButtonEnabled ? ColorUtils.mainColor : ColorUtils.unUseMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: _isButtonEnabled
              ? () {
                FocusManager.instance.primaryFocus?.unfocus();
                  // Login logic here
                }
              : null,
          child: Center(
            child: Text(
              '登录',
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

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
      },
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 34.h),
        side: BorderSide(color: ColorUtils.mainColor, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        '没有账户，去注册',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: ColorUtils.mainColor,
        ),
      ),
    );
  }
}

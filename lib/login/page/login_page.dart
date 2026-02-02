import 'package:Kupool/home/page/home_page.dart';
import 'package:Kupool/login/page/register_page.dart';
import 'package:Kupool/main.dart';
import 'package:Kupool/my/provider/user_info_notifier.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/net/dio_client.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isPasswordVisible = false;

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
      _isButtonEnabled =
          _emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty;
    });
  }

  void _login() {
    final email = _emailController.text.trim();

    // final bool isEmailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
    //     .hasMatch(email);

    if (isUnValidString(email)) {
      ToastUtils.show('请输入有效的邮箱地址');
      return;
    }

    ref.read(authNotifierProvider.notifier).signIn(
          email,
          _passwordController.text,
        );
  }

  final _asciiFormatter = FilteringTextInputFormatter.allow(RegExp(r'[!-~]'));

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null && mounted) {
            context.read<UserInfoNotifier>().fetchUserInfo(); // Fetch user info on successful login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainTabBar()),
              (route) => false,
            );
          }
        },
        loading: () {},
        error: (err, stack) {},
      );
    });

    final authState = ref.watch(authNotifierProvider);

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
                      '登录 KuPool',
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
                    _buildLoginButton(authState.isLoading),
                    SizedBox(height: 16.h),
                    _buildRegisterButton(authState.isLoading),
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
                iconSize: 20,
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
          icon:
          Image.asset(
            _isPasswordVisible ? ImageUtils.minePsShow : ImageUtils.minePsHidden,
            width: 20,
            height: 20,
            color: ColorUtils.colorInputIcon1,
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

  Widget _buildLoginButton(bool isLoading) {
    return Container(
      height: 48.h,
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
          onTap: _isButtonEnabled && !isLoading ? _login : null,
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

  Widget _buildRegisterButton(bool isLoading) {
    return OutlinedButton(
      onPressed: isLoading
          ? null
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage()));
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

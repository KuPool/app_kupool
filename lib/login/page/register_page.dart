import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/login/page/email_verification_page.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:nexus/utils/image_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AutomaticKeepAliveClientMixin<RegisterPage> {
  final _emailController = TextEditingController();
  bool _isAgreed = false;
  bool _isButtonEnabled = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _isAgreed;
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
                    SizedBox(height: 16.h),
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
      textInputAction: TextInputAction.done,
      onEditingComplete: () => FocusManager.instance.primaryFocus?.unfocus(),
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

  Widget _buildNextButton() {
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
              ? () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmailVerificationPage(email: _emailController.text),
                      ),
                    );
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

  Widget _buildAgreementRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isAgreed = !_isAgreed;
              _updateButtonState();
            });
          },
          child: Image.asset(
            _isAgreed ? ImageUtils.checkSelect : ImageUtils.checkUnSelect,
            width: 16.w,
            height: 16.h,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '已阅读并同意',
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              children: [
                TextSpan(
                  text: '《Kupool用户协议》',
                  style: TextStyle(color: ColorUtils.mainColor, fontSize: 14.sp),
                  // Add recognizer to make it tappable
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/loading_state_mixin.dart';
import 'package:Kupool/widget/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPasswordPage extends StatefulWidget {
  final String email;
  final String verificationCode;

  const SetPasswordPage({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> with LoadingStateMixin<SetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode(); // 密码框焦点节点
  final _confirmPasswordFocusNode = FocusNode(); // 确认密码框焦点节点

  // 密码输入格式化器，允许除空格外的所有可打印ASCII字符
  final _passwordInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'[!-~]'));

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isButtonEnabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateState);
    _confirmPasswordController.addListener(_updateState);
    _passwordFocusNode.addListener(_handleFocusChange);
    _confirmPasswordFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.removeListener(_handleFocusChange);
    _confirmPasswordFocusNode.removeListener(_handleFocusChange);
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /// 处理焦点变化的逻辑
  void _handleFocusChange() {
    // 确保在setState之后调用，以获取最新的焦点状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 只有当两个输入框都失去焦点时，才进行校验
      if (!_passwordFocusNode.hasFocus && !_confirmPasswordFocusNode.hasFocus) {
        final password = _passwordController.text;
        final confirmPassword = _confirmPasswordController.text;

        // 如果两个输入框都有内容，但不一致
        if (password.isNotEmpty && confirmPassword.isNotEmpty && password != confirmPassword) {
          setState(() {
            _errorText = '密码不一致';
            _isButtonEnabled = false; // 禁用按钮
          });
        } else {
           // 如果一致或为空，确保错误状态被清除
           _updateState();
        }
      }
    });
  }

  void _updateState() {
    setState(() {
      // 只有当没有错误时，才根据内容更新按钮状态
      if (_errorText == null) {
        _isButtonEnabled = _passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty;
      }
      // 当用户开始编辑时，实时清除错误提示
      _errorText = null;
    });
  }

  void _onComplete() {
    runWithLoading(() async {
      FocusManager.instance.primaryFocus?.unfocus();

      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // 双重保险：再次校验密码一致性
      if (password != confirmPassword) {
        setState(() {
          _errorText = '密码不一致';
        });
        return;
      }

      // 密码长度校验
      if (password.length < 8) {
        // ToastUtils.show('密码长度至少为8位');
        return;
      }
      
      // 调用最终的注册接口
      final result = await ApiService().post(
        '/v1/sign_up',
        data: {
          'email': widget.email,
          'code': widget.verificationCode,
          'password': password,
        },
      );

      // 注册成功
      if (result != null && mounted) {
        // 显示成功对话框
        showDialog(
          context: context,
          barrierDismissible: false, // 用户必须点击按钮才能关闭
          builder: (BuildContext context) {
            return SuccessDialog(
              title: '注册成功',
              buttonText: '完成',
              onButtonPressed: () {
                // 优化：保留第一个路由(HomePage)，移除中间所有路由，然后推入LoginPage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()), 
                  (route) => route.isFirst, // 只保留第一个路由
                );
              },
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // 禁用默认的leading
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero, // 移除IconButton的内边距
              constraints: const BoxConstraints(), // 移除IconButton的默认大小限制
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
        behavior: HitTestBehavior.opaque, // 确保空白区域也可以点击
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '设置密码',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '至少8位，包括大小写字母、数字或符号。',
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
              SizedBox(height: 16.h),
              _buildPasswordField(
                controller: _passwordController,
                focusNode: _passwordFocusNode, // 传入焦点节点
                hint: '请输入密码',
                isVisible: _isPasswordVisible,
                onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              SizedBox(height: 16.h),
              _buildPasswordField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode, // 传入焦点节点
                hint: '确认密码',
                isVisible: _isConfirmPasswordVisible,
                onToggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
              SizedBox(height: 32),
              _buildCompleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    bool showError = _errorText != null;
    const Color successColor = Color(0xFF04AC36);

    // 判断是否应该显示成功状态的边框
    bool shouldShowSuccess =
        !_passwordFocusNode.hasFocus && // 密码框失去焦点
        !_confirmPasswordFocusNode.hasFocus && // 确认密码框失去焦点
        _passwordController.text.isNotEmpty && // 密码不为空
        _passwordController.text == _confirmPasswordController.text; // 两次密码一致

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      inputFormatters: [_passwordInputFormatter], // 应用输入格式化器
      decoration: InputDecoration(
        hintText: hint,
        helperText: showError ? _errorText : ' ', // 使用helperText预留空间
        helperStyle: TextStyle(color: const Color(0xFFFF383C), fontSize: 12.sp),
        helperMaxLines: 1,
        contentPadding: EdgeInsets.only(left: 0, top: 12.h, bottom: 12.h),
        errorStyle: const TextStyle(height: 0), // 隐藏默认的errorStyle空间
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            ImageUtils.loginPass,
            width: 24.w,
            height: 24.h,
            color: Colors.grey,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: showError 
                ? const Color(0xFFFF383C) 
                : (shouldShowSuccess ? successColor : Colors.grey.shade300),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: showError ? const Color(0xFFFF383C) : ColorUtils.mainColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF383C)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF383C), width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isButtonEnabled && !isLoading ? ColorUtils.mainColor : ColorUtils.unUseMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isButtonEnabled && !isLoading ? _onComplete : null,
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isButtonEnabled = false;

  Timer? _timer;
  int _countdownSeconds = 60;
  bool _isCountingDown = false;
  bool tapSendCode = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
    _codeController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _codeController.text.isNotEmpty;
    });
  }

  void _startCountdown() {
    _isCountingDown = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 1) {
          _countdownSeconds--;
        } else {
          _timer?.cancel();
          _isCountingDown = false;
          _countdownSeconds = 60;
        }
      });
    });
  }

  bool _validatePasswords() {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ToastUtils.show('请填写完整信息',displayTime: Duration(seconds: 2));
      return false;
    }

    if (oldPassword.length < 8 || newPassword.length < 8 || confirmPassword.length < 8) {
      ToastUtils.show('密码长度不能少于8位',displayTime: Duration(seconds: 2));
      return false;
    }

    if (newPassword != confirmPassword) {
      ToastUtils.show('两次输入的新密码不一致',displayTime: Duration(seconds: 2));
      return false;
    }

    return true;
  }
  
  final _passwordFormatter = FilteringTextInputFormatter.allow(RegExp(r'[!-~]'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改密码', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
           behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        title: '原密码',
                        controller: _oldPasswordController,
                        hint: '请输入原密码',
                        isPassword: true,
                        isVisible: _oldPasswordVisible,
                        onVisibilityToggle: () => setState(() => _oldPasswordVisible = !_oldPasswordVisible),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        title: '新密码',
                        controller: _newPasswordController,
                        hint: '请输入新密码',
                        isPassword: true,
                        isVisible: _newPasswordVisible,
                        onVisibilityToggle: () => setState(() => _newPasswordVisible = !_newPasswordVisible),
                      ),
                      const SizedBox(height: 24),
                       _buildTextField(
                        title: '确认新密码',
                        controller: _confirmPasswordController,
                        hint: '再次输入新密码',
                        isPassword: true,
                        isVisible: _confirmPasswordVisible,
                        onVisibilityToggle: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                      ),
                      const SizedBox(height: 24),
                      _buildVerificationCodeField(),
                    ],
                  ),
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: ColorUtils.colorTitleOne)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          inputFormatters: isPassword ? [_passwordFormatter] : [],
          style: const TextStyle(fontSize: 15, color: ColorUtils.colorTitleOne),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 15, color: ColorUtils.color999),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Image.asset(
                      isVisible ? ImageUtils.minePsShow : ImageUtils.minePsHidden,
                      width: 20,
                      height: 20,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : (controller.text.isNotEmpty ? 
                    IconButton(
                      icon: const Icon(Icons.cancel, color: ColorUtils.colorInputIcon1, size: 20),
                      onPressed: () => controller.clear(),
                    ) : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none, 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorUtils.mainColor, width: 1.0),
            ),  
          ),
        ),
      ],
    );
  }
  
  Widget _buildVerificationCodeField() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('邮箱验证码', style: TextStyle(fontSize: 14, color: ColorUtils.colorTitleOne)),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(fontSize: 15, color: ColorUtils.colorTitleOne),
          controller: _codeController,
          keyboardType: TextInputType.numberWithOptions(),
          autocorrect: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), 
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            hintText: '输入邮箱验证码',
            hintStyle: const TextStyle(fontSize: 15, color: ColorUtils.color999),
            suffixIcon: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _isCountingDown ? null : () {
                if (!_validatePasswords()) return;
                ApiService().post('/v1/change_password/send_code').then((_) {
                  if (!mounted) return;
                  ToastUtils.show('验证码发送成功');
                  tapSendCode = true;
                  setState(() {
                    _startCountdown();
                  });
                }).catchError((e) {
                  if (!mounted) return;
                  ToastUtils.show('验证码发送失败，请稍后重试');
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _isCountingDown ? '$_countdownSeconds秒后重新发送' : '发送验证码',
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 15,
                      color: _isCountingDown ? Colors.grey : ColorUtils.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
            ),
             border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none, 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorUtils.mainColor, width: 1.0),
            ),  
          ),
        ),
      ],
    );
  }


  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: GestureDetector(
        onTap: _isButtonEnabled
            ? () async {
                if (!_validatePasswords()) return;
                if(tapSendCode == false){
                  ToastUtils.show('请先发送验证码',displayTime: Duration(seconds: 2));
                  return;
                }
                if (isUnValidString(_codeController.text.trim()) ) {
                  ToastUtils.show('请输入验证码',displayTime: Duration(seconds: 2));
                  return;
                }

                ToastUtils.showLoading(message: '正在修改...');
                try {
                  final params = {
                    'current_password': _oldPasswordController.text.trim(),
                    'new_password': _newPasswordController.text.trim(),
                    'code': _codeController.text.trim(),
                  };
                  await ApiService().post('/v1/change_password', data: params);
                  ToastUtils.showSuccess('密码修改成功');
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {

                } finally {
                  ToastUtils.dismiss();
                }
              }
            : null,
        child: Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isButtonEnabled ? ColorUtils.mainColor : ColorUtils.mainColor.withAlpha(125),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '确认修改',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

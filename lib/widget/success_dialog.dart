import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 一个通用的成功提示对话框
class SuccessDialog extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), // 对话框圆角
      ),
      // 增加左右边距，让对话框变窄一些
      insetPadding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 40.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 成功图标
            Image.asset(
              ImageUtils.registerSuccess,
              width: 56.w,
              height: 56.w,
            ),
            SizedBox(height: 16.h),
            // 注册成功文字
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00DF38),
              ),
            ),
            SizedBox(height: 32.h),
            // 完成按钮
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9F0FF), // 按钮的淡蓝色背景
                  foregroundColor: const Color(0xFF3375E0), // 按钮文字颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0, // 移除阴影
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

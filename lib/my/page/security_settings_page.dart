import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全设置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make column wrap content
            children: [
              _buildSettingsItem('修改密码'),
              // Divider(height: 1, color: Colors.grey.shade200, indent: 16.w, endIndent: 16.w),
              // _buildSettingsItem('登录记录'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT1),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

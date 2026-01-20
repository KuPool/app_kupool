import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = '简体中文'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择语言', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
              _buildLanguageOption('简体中文'),
              // Divider(height: 1, color: Colors.grey.shade200, indent: 16.w, endIndent: 16.w),
              // _buildLanguageOption('English'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = _selectedLanguage == language;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // setState(() {
          //   _selectedLanguage = language;
          // });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  language,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorUtils.colorT1,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check, size: 20.sp, color: ColorUtils.mainColor),
            ],
          ),
        ),
      ),
    );
  }
}

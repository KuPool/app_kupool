import 'package:Kupool/my/page/about_kupool_page.dart';
import 'package:Kupool/my/page/language_selection_page.dart';
import 'package:Kupool/my/page/personal_info_page.dart';
import 'package:Kupool/my/page/security_settings_page.dart';
import 'package:Kupool/my/page/sub_account_management_page.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          children: [
            _buildUserInfoCard(),
            SizedBox(height: 12.h),
            _buildSettingsList(),
            SizedBox(height: 12.h),
            _buildAboutList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoPage()));
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, size: 32.r, color: Colors.grey.shade400),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Testuser@kupool.com',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorUtils.colorT1),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Kupool ID: 466102032212',
                        style: TextStyle(fontSize: 13.sp, color: ColorUtils.colorT2),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.shade400),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SubAccountManagementPage()));
                },
                child: _buildMenuItem(iconPath: ImageUtils.mySubAccount, title: '子账户管理'),
              );
            }
          ),
          Divider(height: 1, color: Colors.grey.shade200, indent: 52,endIndent: 16,),
          Builder(
            builder: (context) {
              return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SecuritySettingsPage()));
                  },
                  child: _buildMenuItem(iconPath: ImageUtils.mySecurity, title: '安全设置')
              );
            }
          ),
          Divider(height: 1, color: Colors.grey.shade200, indent: 52,endIndent: 16,),
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSelectionPage()));
                },
                child: _buildMenuItem(
                  iconPath: ImageUtils.myLanguage,
                  title: '选择语言',
                  trailing: Text('简体中文', style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT2)),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildAboutList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildMenuItem(iconPath: ImageUtils.myHelp, title: '帮助中心'),
          Divider(height: 1, color: Colors.grey.shade200, indent: 52,endIndent: 16,),
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutKupoolPage()));
                },
                child: _buildMenuItem(iconPath: ImageUtils.myAbout, title: '关于 Kupool'),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String iconPath, required String title, Widget? trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Image.asset(iconPath, width: 24.w, height: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT1),
            ),
          ),
          if (trailing != null) trailing,
          SizedBox(width: 8.w),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

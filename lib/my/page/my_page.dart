import 'dart:async';

import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/my/page/about_kupool_page.dart';
import 'package:Kupool/my/page/language_selection_page.dart';
import 'package:Kupool/my/page/personal_info_page.dart';
import 'package:Kupool/my/page/security_settings_page.dart';
import 'package:Kupool/my/page/sub_account_management_page.dart';
import 'package:Kupool/my/provider/user_info_notifier.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/net/dio_client.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../login/page/agreement_page.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  StreamSubscription? _tokenRefreshSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserInfoNotifier>().fetchUserInfo();
    });

    _tokenRefreshSubscription = AuthInterceptor.onTokenRefreshed.stream.listen((_) {
      if (mounted) {
        context.read<UserInfoNotifier>().fetchUserInfo();
      }
    });
  }

  @override
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserInfoNotifier>().userInfo;

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          children: [
            _buildUserInfoCard(userInfo?.email, userInfo?.kupoolId.toString()),
            SizedBox(height: 12.h),
            _buildSettingsList(),
            SizedBox(height: 12.h),
            _buildAboutList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(String? email, String? kupoolId) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoPage()));
          },
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  child:
                  Image.asset(ImageUtils.mineHeader, width: 48.w, height: 48.w),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email ?? '--',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorUtils.colorT1),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Kupool ID: ${kupoolId ?? '--'}',
                        style: TextStyle(fontSize: 13.sp, color: ColorUtils.colorT2),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      }
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
                  behavior: HitTestBehavior.opaque,
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
                    behavior: HitTestBehavior.opaque,
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
                  behavior: HitTestBehavior.opaque,
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
          Builder(
            builder: (context) {
              return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgreementPage(title: "", url: "https://help.kupool.com/hc/zh-cn"),
                      ),
                    );
                  },
                  child: _buildMenuItem(iconPath: ImageUtils.myHelp, title: '帮助中心')
              );
            }
          ),
          Divider(height: 1, color: Colors.grey.shade200, indent: 52,endIndent: 16,),
          Builder(
              builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
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

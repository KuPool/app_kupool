import 'package:Kupool/my/provider/user_info_notifier.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../json_serializable_model/login_model_entity.dart';
import '../../main.dart';
import '../../utils/image_utils.dart';

class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = context.watch<UserInfoNotifier>().userInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24.h),
        child: Column(
          children: [
            _buildInfoCard(context, userInfo),
            const Spacer(),
            _buildLogoutButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, LoginModelUserInfo? userInfo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildInfoRow('头像', trailing: CircleAvatar(
            radius: 16,
            child:  Image.asset(ImageUtils.mineHeader, width: 32, height: 32),
          )),
          // _buildInfoRow('用户名', value: userInfo?.name ?? '--'),
          _buildInfoRow('邮箱', value: userInfo?.email ?? '--'),
          _buildInfoRow('Kupool ID', value: userInfo?.kupoolId?.toString() ?? '--', hasDivider: false),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, {String? value, Widget? trailing, bool hasDivider = true}) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 0), // Adjust bottom padding
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT1)),
              const Spacer(),
              if (value != null)
                Text(value, style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT2)),
              if (trailing != null)
                trailing,
            ],
          ),
          SizedBox(height: 14),
          if(hasDivider) ...[
             Divider(height: 1, color: Colors.grey.shade200),
          ]
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Container(
      height: 44,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: ColorUtils.colorRed,width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          '退出登录',
          style: TextStyle(fontSize: 14, color: ColorUtils.colorRed, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.only(left: 24,right: 24,bottom: 10,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '退出登录',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: ColorUtils.colorT1),
                ),
                SizedBox(height: 8.h),
                Text(
                  '确认退出?',
                  style: TextStyle(fontSize: 15, color: ColorUtils.colorT1),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0x190D5EF5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('返回', style: TextStyle(color: ColorUtils.colorNoteT2, fontSize: 14, fontWeight: FontWeight.w500)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: ColorUtils.colorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('退出', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          onPressed: () async {
                            ToastUtils.showLoading(message: "正在退出...");
                            await ref.read(authNotifierProvider.notifier).signOut();
                            ToastUtils.dismiss();
                            ToastUtils.show("退出成功,为你跳转...",onDismiss: (){
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MainTabBar()),
                                    (route) => false, // 移除所有路由
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

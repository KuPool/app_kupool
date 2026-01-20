import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SubAccountManagementPage extends StatelessWidget {
  const SubAccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('子账户管理', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                ImageUtils.myAccountYC,
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        _buildSubAccountRow(context, 'liupro', '内蒙古老刘放假了三等奖付了款戴假发', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '湖南老王', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'jackma', '杭州老马', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'tonyma', '深圳马', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '内蒙古老刘', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '内蒙古老刘', '0.00 TH/s', ImageUtils.homeDoge, false),
                      ],
                    ),
                  ),
                ],
              ),  
            ),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  void _showAccountActionsSheet(BuildContext context, String name, String description, String iconPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: ColorUtils.widgetBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16),
                  child: Row(
                    children: [
                      Image.asset(iconPath, width: 40, height: 40),
                      SizedBox(width: 8),
                      Text(
                        name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: ColorUtils.colorT1),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        _buildSheetMenuItem('修改备注名', trailing: Expanded(child: Text(description, style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT2)))),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16.w, endIndent: 16.w),
                        _buildSheetMenuItem('修改默认币种', trailing: Text('DOGE/LTC', style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT2))),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16.w, endIndent: 16.w),
                        _buildSheetMenuItem('隐藏子账户'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetMenuItem(String title, {Widget? trailing}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: ColorUtils.colorT1),
              ),
            ),
            if (trailing != null) trailing,
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSubAccountRow(BuildContext context, String name, String description, String hashrate, String iconPath, bool hasDivider) {
    final parts = hashrate.split(' ');
    final value = parts.isNotEmpty ? parts[0] : '';
    final unit = parts.length > 1 ? ' ${parts.sublist(1).join(' ')}' : '';

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
      child: Column(
        children: [
          SizedBox(height: 12,),
          Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40), // Placeholder icon
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorUtils.colorTitleOne)),
                      SizedBox(height: 2.h),
                      Text(description, style: TextStyle(fontSize: 12, color: ColorUtils.color888),maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
                  children: <TextSpan>[
                    TextSpan(text: value),
                    TextSpan(text: unit, style: TextStyle(color: ColorUtils.color888)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  _showAccountActionsSheet(context, name, description, iconPath);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 24,right: 16),
                  child: Transform.rotate(
                    angle: math.pi/2,
                    child: Icon(Icons.more_horiz, color: ColorUtils.mainColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          if (hasDivider)
             Divider(height: 1, color: Colors.grey.shade200, indent: 40+12, endIndent: 16),

        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.mainColor, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubAccountCreatePage()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '创建子账户',
                  style: TextStyle(fontSize: 15, color: ColorUtils.mainColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

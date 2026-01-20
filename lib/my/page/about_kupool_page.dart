import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutKupoolPage extends StatelessWidget {
  const AboutKupoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于 Kupool', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        children: [
          _buildAboutCard(),
          SizedBox(height: 12.h),
          _buildContactCard(),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Image.asset(ImageUtils.kupoolLogo, width: 120.w), // Assuming you have a logo in ImageUtils
          SizedBox(height: 16.h),
          Text(
            'Kupool 由一支区块链专家团队于2025年创立, 在包括比特币在内的多条公链上, 其团队曾多次获得矿池算力世界第一的成绩。\n我们相信, 行业的发展离不开持续的创新与合规化运营; 而我们也看到, 行业的创新与合规化进程已面临一定程度的停滞。于是我们放下平静的生活, 再次出发。',
            style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT2, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildInfoRow('邮箱', 'support@kupool.com'),
          Divider(height: 1, color: Colors.grey.shade200, indent: 16.w, endIndent: 16.w),
          _buildInfoRow('Twitter (X)', '@kupoolofficial', hasDivider: false),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool hasDivider = true}) {
    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: value));
        ToastUtils.show("$title-已复制");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorT1)),
            Text(value, style: TextStyle(fontSize: 14.sp, color: ColorUtils.colorNoteT2)),
          ],
        ),
      ),
    );
  }
}

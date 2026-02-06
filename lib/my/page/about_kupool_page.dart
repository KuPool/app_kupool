import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/logger.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutKupoolPage extends StatelessWidget {
  const AboutKupoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于 KuPool', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24.h),
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
            'KuPool 由一支区块链专家团队于2025年创立, 在包括比特币在内的多条公链上, 其团队曾多次获得矿池算力世界第一的成绩。\n我们相信, 行业的发展离不开持续的创新与合规化运营; 而我们也看到, 行业的创新与合规化进程已面临一定程度的停滞。于是我们放下平静的生活, 再次出发。',
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
          _buildInfoRow('Twitter (X)', '@kupooltech', hasDivider: false),
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
      onTap: () async {
        Uri? uri;
        // 1. 判断是哪一行被点击了
        if (title.toLowerCase().contains('twitter')) {
          uri = Uri.parse('https://x.com/kupooltech');
        } else if (title.toLowerCase().contains('邮箱')) {
          // 如果是邮箱，构造 mailto 链接，这会尝试打开邮件客户端
          uri = Uri.parse('mailto:$value');
        }
        // 2. 如果成功构造了 uri，就尝试启动它
        if (uri != null) {
          if (await canLaunchUrl(uri)) {
            var result = await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            // 如果找不到可以打开链接的应用，给用户一个提示
            ToastUtils.show('无法打开链接: $uri');
          }
        }
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

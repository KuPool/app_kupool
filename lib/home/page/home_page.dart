import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/login/page/login_page.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:nexus/utils/image_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          ImageUtils.kupoolLogo, // Assuming you have a logo in ImageUtils
          height: 24.h,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Text(
              '登录/注册',
              style: TextStyle(fontSize: 14.sp, color: ColorUtils.mainColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildTopBanner(context),
            _buildAnnouncementBar(context),
            _buildMiningCoinsSection(context),
            _buildMiningAddressSection(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.only(top: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        ImageUtils.homeBanner,
        height: 80.h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAnnouncementBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.volume_up, color: ColorUtils.mainColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '[11-12] Kupool 上线 TRMP',
              style:
                  TextStyle(fontSize: 14.sp, color: const Color(0xFF0D1835)),
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMiningCoinsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      margin: EdgeInsets.only(top: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text('挖矿币种',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D1835))),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildCoinHeader(),
          ),
          SizedBox(height: 12.h),
          _buildCoinRow(
            context,
            coinName: 'BTC',
            dailyEarning: '¥ 55.04 /G',
            poolHashrate: '6.31 EH/s',
            isUp: null,
          ),
          const Divider(indent: 16, endIndent: 16),
          _buildCoinRow(
            context,
            coinName: 'DOGE/LTC',
            dailyEarning: '¥ 5.04 /G',
            poolHashrate: '76.31 TH/s',
            isUp: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCoinHeader() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text('币种',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey))),
        Expanded(
            flex: 3,
            child: Text('日收益',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey))),
        Expanded(
            flex: 3,
            child: Text('矿池算力',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey))),
      ],
    );
  }

  Widget _buildCoinRow(BuildContext context,
      {
      required String coinName,
      required String dailyEarning,
      required String poolHashrate,
      bool? isUp}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(height: 32.h,color: Colors.grey,),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(coinName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(dailyEarning, style: TextStyle(fontSize: 14.sp))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(poolHashrate, style: TextStyle(fontSize: 14.sp)),
                if (isUp != null)
                  Icon(
                    isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isUp ? Colors.green : Colors.red,
                    size: 16,
                  )
                else
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiningAddressSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(top: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('挖矿地址',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D1835))),
          SizedBox(height: 16.h),
          _buildAddressRow(
              '亚洲', 'stratum+tcp://ltc-cn.kupool.com:8888'),
          SizedBox(height: 12.h),
          _buildAddressRow('全球', 'stratum+tcp://ltc.kupool.com:8888'),
          SizedBox(height: 12.h),
          Text(
            '非加密地址, 仅供测试, 国内用户请勿直连, 请注册后联系商务经理',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          const Divider(height: 32),
          _buildInfoRow('分配方式', 'FPPS'),
          _buildInfoRow('起付额', '40 DOGE / 0.01 LTC'),
          _buildInfoRow('支付时间', '每日 9:00-12:00 (UTC+8)'),
        ],
      ),
    );
  }
  
  Widget _buildAddressRow(String region, String address) {
    return Row(
      children: [
        Text(region, style: TextStyle(fontSize: 14.sp)),
        SizedBox(width: 16.w),
        Expanded(child: Text(address, style: TextStyle(fontSize: 14.sp), overflow: TextOverflow.ellipsis,)),
        SizedBox(width: 8.w),
        const Icon(Icons.copy, size: 16, color: Colors.grey),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF0D1835))),
        ],
      ),
    );
  }
}

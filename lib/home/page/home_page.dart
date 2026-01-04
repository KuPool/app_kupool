import 'dart:math' as math;
import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Map<String, bool> _expansionState = {};

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          ImageUtils.kupoolLogo,
          height: 24.h,
        ),
        actions: [
          authState.when(
            data: (user) {
              if (user != null) {
                return const SizedBox.shrink();
              } else {
                return TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    '登录/注册',
                    style: TextStyle(fontSize: 14.sp, color: ColorUtils.mainColor),
                  ),
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Center(child: Text('Error')),
          ),
        ].where((widget) => widget is! SizedBox).toList(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildTopBanner(context),
            _buildAnnouncementBar(context),
            _buildMiningCoinsSection(context),
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
          Image.asset(ImageUtils.homeVolume, width: 24.w, height: 24.h),
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
    const List<int> flexes = [5, 3, 4];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
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
                    fontWeight: FontWeight.normal,
                    color: ColorUtils.colorT1)),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildCoinHeader(flexes),
          ),
          Column(
            children: [
              _buildCoinRow(
                context,
                flexes: flexes,
                icons: [Icons.currency_bitcoin],
                coinName: 'BTC',
                dailyEarning: '¥ 55.04 /G',
                poolHashrate: '6.31 EH/s',
                isUp: _expansionState['BTC'] ?? false,
                onTap: () => setState(() => _expansionState['BTC'] = !(_expansionState['BTC'] ?? false)),
              ),
              if (_expansionState['BTC'] ?? false) _buildMiningAddressSection(context),
            ],
          ),
           Column(
            children: [
              _buildCoinRow(
                context,
                flexes: flexes,
                icons: [Icons.pets, Icons.flash_on],
                coinName: 'DOGE/LTC',
                dailyEarning: '¥ 5.04 /G',
                poolHashrate: '76.31 TH/s',
                isUp: _expansionState['DOGE/LTC'] ?? false,
                onTap: () => setState(() => _expansionState['DOGE/LTC'] = !(_expansionState['DOGE/LTC'] ?? false)),
              ),
              if (_expansionState['DOGE/LTC'] ?? false) _buildMiningAddressSection(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinHeader(List<int> flexes) {
    return Row(
      children: [
        SizedBox(width: 60), 
        Expanded(
            flex: flexes[0],
            child: Text('币种',
                style: TextStyle(fontSize: 12.sp, color: ColorUtils.colorTableHear))),
        Expanded(
            flex: flexes[1],
            child: Text('日收益',
                style: TextStyle(fontSize: 12.sp, color: ColorUtils.colorTableHear))),
        Expanded(
          flex: flexes[2],
          child: Text(
            '矿池算力',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: ColorUtils.colorTableHear),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinIcons(List<IconData> icons) {
    if (icons.length > 1) {
      return SizedBox(
        width: 48.w, 
        height: 32.h,
        child: Stack(
          children: [
            Positioned(
              left: 16.w,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.blue.shade300,
                child: Icon(icons[1], color: Colors.white, size: 20),
              ),
            ),
            Positioned(
              left: 0,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.yellow.shade600,
                child: Icon(icons[0], color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 48.w, 
        height: 32.h,
        child: CircleAvatar(
          radius: 16.r,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icons.first, color: Colors.grey.shade400, size: 20),
        ),
      );
    }
  }

  Widget _buildCoinRow(BuildContext context,
      {required List<int> flexes, 
      required List<IconData> icons,
      required String coinName,
      required String dailyEarning,
      required String poolHashrate,
      required bool isUp, 
      required VoidCallback onTap, 
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flexes[0],
            child: Row(
              children: [
                _buildCoinIcons(icons),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(coinName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorUtils.colorT1,
                        )
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: flexes[1],
              child: Text(dailyEarning, style: TextStyle(fontSize: 16, color: ColorUtils.colorT1))),
          Expanded(
            flex: flexes[2],
            child: InkWell(
              onTap: onTap, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  Text(poolHashrate, style: TextStyle(fontSize: 16, color: ColorUtils.colorT1)),
                  SizedBox(width: 4.w),
                  Transform.rotate(
                    angle: isUp ? -math.pi / 2 : 0, 
                    child: Image.asset(
                      ImageUtils.turnRight,
                      width: 16,
                      height: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiningAddressSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
      decoration: BoxDecoration(
        color: ColorUtils.widgetBgColor, 
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('挖矿地址',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: ColorUtils.colorTableHear)),
          SizedBox(height: 20.h),
          _buildAddressRow(
              '亚洲', 'stratum+tcp://ltc-cn.kupool.com:8888'),
          SizedBox(height: 20.h),
          _buildAddressRow('全球', 'stratum+tcp://ltc.kupool.com:8888'),
          SizedBox(height: 20.h),
          Text(
            '非加密地址, 仅供测试, 国内用户请勿直连, 请注册后联系商务经理',
            style: TextStyle(fontSize: 12, color: ColorUtils.colorNoteT1),
          ),
          SizedBox(height: 16.h,),
          _buildInfoRow('分配方式', 'FPPS'),
          _buildInfoRow('起付额', '40 DOGE / 0.01 LTC'),
          _buildInfoRow('支付时间', '每日 9:00-12:00 (UTC+8)'),
        ],
      ),
    );
  }
  
  Widget _buildAddressRow(String region, String address) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 顶部对齐，以在文本换行时保持布局稳定
      children: [
        Text(region, style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: TextStyle(fontSize: 14,color: ColorUtils.colorT1),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(width: 8),
        Image.asset(
          ImageUtils.homeCopy,
          width: 16,
          height: 16,
          color: ColorUtils.colorT1,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorTableHear)),
          Text(value, style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
        ],
      ),
    );
  }
}

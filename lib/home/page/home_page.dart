import 'dart:math' as math;

import 'package:Kupool/home/announcement_provider.dart';
import 'package:Kupool/home/home_provider.dart';
import 'package:Kupool/home/widgets/home_error_widget.dart';
import 'package:Kupool/home/widgets/home_skeleton_widget.dart';
import 'package:Kupool/login/page/agreement_page.dart';
import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/format_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/common_widget.dart';
import '../../widgets/app_refresh.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
    );
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh both providers in parallel
    await Future.wait([
      ref.refresh(homeDataProvider.future),
      ref.refresh(announcementProvider.future),
    ]);
    if (mounted) {
      _easyRefreshController.finishRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final homeDataAsync = ref.watch(homeDataProvider);
    final announcementAsync = ref.watch(announcementProvider);

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
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const Icon(Icons.error),
          ),
        ].where((widget) => widget is! SizedBox).toList(),
      ),
      body: EasyRefresh(
        controller: _easyRefreshController,
        header: const AppRefreshHeader(),
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            _buildTopBanner(context),
            announcementAsync.when(
              data: (announcement) => announcement != null ? _buildAnnouncementBar(context, announcement) : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
            ),
            homeDataAsync.when(
              data: (homeData) => _buildMiningCoinsSection(context, homeData),
              loading: () => const HomeSkeletonWidget(),
              error: (err, stack) => const HomeErrorWidget(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(top: 12),
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

  Widget _buildAnnouncementBar(BuildContext context, Map<String, dynamic> announcement) {
    final title = announcement['title'] as String? ?? '';
    final htmlUrl = announcement['html_url'] as String?;

    return InkWell(
      onTap: () {
        if (htmlUrl != null && htmlUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgreementPage(title: title, url: htmlUrl),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                title,
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xFF0D1835)),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMiningCoinsSection(BuildContext context, HomeDataState homeData) {
    const List<int> flexes = [4, 3, 4];
    var coinInfoModel = homeData.coinInfo.ltc;
    var poolHash = FormatUtils.formatHashrate(coinInfoModel?.poolHash);

    var dogeMergeMining =
        coinInfoModel?.mergeMining?.where((mm) => mm.name == "doge").toList();
    var dogeAvg = dogeMergeMining?.first.valueAvg;

    var priceModel = homeData.price;
    var dogePrice = priceModel.price?.doge?.price ?? 0.0;
    var ltcPrice = priceModel.price?.ltc?.price ?? 0.0;
    var cnyPrice = priceModel.fiat?.cny ?? 0.0;

    final earnPerUnit = double.tryParse(coinInfoModel?.earnPerUnit ?? '') ?? 0.0;
    final dogeValueAvg = double.tryParse(dogeAvg ?? '') ?? 0.0;

    final dogeEarning = earnPerUnit * dogeValueAvg * dogePrice * cnyPrice;

    final ltcEarning = earnPerUnit * 1 * ltcPrice * cnyPrice;

    final totalEarning = dogeEarning + ltcEarning;
    var dayEarning = '¥ ${totalEarning.toStringAsFixed(2)} /${coinInfoModel?.earnUnit}';



    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('挖矿币种',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: ColorUtils.colorT1)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildCoinHeader(flexes),
          ),
          _buildCoinRow(
            context,
            flexes: flexes,
            icons: [ImageUtils.homeDoge, ImageUtils.homeLtc],
            coinName: 'DOGE/LTC',
            dailyEarning: dayEarning,
            poolHashrate: '$poolHash ${coinInfoModel?.poolHashUnit}',
          ),
          _buildMiningAddressSection(context,homeData),
        ],
      ),
    );
  }

  Widget _buildCoinHeader(List<int> flexes) {
    return Row(
      children: [
        const SizedBox(width: 56),
        Expanded(
            flex: flexes[0],
            child: Text('币种',
                style: TextStyle(fontSize: 12, color: ColorUtils.colorTableHear))),
        Expanded(
            flex: flexes[1],
            child: Text('日收益',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: ColorUtils.colorTableHear))),
        Expanded(
          flex: flexes[2],
          child: Text(
            '矿池算力',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12, color: ColorUtils.colorTableHear),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinIcons(List<String> icons) {
    if (icons.length > 1) {
      return SizedBox(
        width: 48,
        height: 32,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(icons[1]),
                backgroundColor: Colors.transparent,
              ),
            ),
            Positioned(
              left: 0,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(icons[0]),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 48,
        height: 32,
        child: CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage(icons.first),
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }

  Widget _buildCoinRow(BuildContext context,
      {required List<int> flexes, 
      required List<String> icons,
      required String coinName,
      required String dailyEarning,
      required String poolHashrate}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // _buildCoinIcons(icons),
                CommonWidgets.buildCoinHeaderImageWidget(iconType: "ltc",width:48,coinWidth: 30,coinHeight: 30),
              ],
            ),
          ),
          Expanded(
            flex: flexes[0],
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(coinName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: ColorUtils.colorT1,
                  )
              ),
            ),
          ),
          const SizedBox(width: 6,),
          Expanded(
              flex: flexes[1],
              child: FittedBox(fit: BoxFit.scaleDown,alignment: Alignment.centerRight,child: Text(dailyEarning, textAlign: TextAlign.right, style: TextStyle(fontSize: 16, color: ColorUtils.colorT1)))),
          const SizedBox(width: 6,),
          Expanded(
            flex: flexes[2],
            child: FittedBox(fit: BoxFit.scaleDown,alignment: Alignment.centerRight,child: Text("${poolHashrate}H/s",textAlign: TextAlign.right, style: TextStyle(fontSize: 16, color: ColorUtils.colorT1,))), 
          ),
        ],
      ),
    );
  }

  Widget _buildMiningAddressSection(BuildContext context,HomeDataState homeData) {

    var ltcModel = homeData.coinInfo.ltc;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 0, left: 12, right: 12),
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
          SizedBox(height: 8.h),
          _buildAddressRow(
              '亚洲', '${ltcModel?.miningAddresses?.asia}'),
          SizedBox(height: 4.h),
          _buildAddressRow('全球', '${ltcModel?.miningAddresses?.global}'),
          SizedBox(height: 8.h),
          Text(
            '非加密地址, 仅供测试, 国内用户请勿直连, 请注册后联系商务经理',
            style: TextStyle(fontSize: 12, color: ColorUtils.colorNoteT1),
          ),
          SizedBox(height: 16.h,),
          _buildInfoRow('分配方式',
              value: Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(text: '${ltcModel?.dogeEarnMode} ', style: TextStyle(color: ColorUtils.colorT1)),
                    TextSpan(text: 'DOGE', style: TextStyle(color: ColorUtils.color888)),
                    TextSpan(text: ' / ', style: TextStyle(color: ColorUtils.colorT1)),
                    TextSpan(text: '${ltcModel?.earnMode} ', style: TextStyle(color: ColorUtils.colorT1)),
                    TextSpan(text: 'LTC', style: TextStyle(color: ColorUtils.color888)),
                  ],
                ),
                textAlign: TextAlign.right,
              ),),
          _buildInfoRow('起付额', 
            value: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 14),
                children: <TextSpan>[
                  TextSpan(text: '${ltcModel?.dogeMinimumPayAmount} ', style: TextStyle(color: ColorUtils.colorT1)),
                  TextSpan(text: 'DOGE', style: TextStyle(color: ColorUtils.color888)),
                  TextSpan(text: ' / ', style: TextStyle(color: ColorUtils.colorT1)),
                  TextSpan(text: '${ltcModel?.minimumPayAmount} ', style: TextStyle(color: ColorUtils.colorT1)),
                  TextSpan(text: 'LTC', style: TextStyle(color: ColorUtils.color888)),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
          _buildInfoRow('支付时间', value: Text('每日 9:00-12:00 (UTC+8)', style: TextStyle(fontSize: 14, color: ColorUtils.colorT1), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
  
  Widget _buildAddressRow(String region, String address) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(region, style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
        const SizedBox(width: 8),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              address,
              style: TextStyle(fontSize: 14,color: ColorUtils.colorT1),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Clipboard.setData(ClipboardData(text: address));
            ToastUtils.show("已复制");
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              ImageUtils.homeCopy,
              width: 16,
              height: 16,
              color: ColorUtils.colorT1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, {required Widget value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 1. 添加 start 对齐
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorTableHear)),
          const SizedBox(width: 24),
          Expanded(child: value),
        ],
      ),
    );
  }
}

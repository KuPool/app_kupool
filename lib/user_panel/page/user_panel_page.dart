import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/user_panel/provider/chart_notifier.dart';
import 'package:Kupool/user_panel/provider/user_panel_provider.dart';
import 'package:Kupool/user_panel/widgets/add_miner_guide.dart';
import 'package:Kupool/utils/base_data.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/subAccount_panel_entity.dart';
import '../widgets/chart_for_TH.dart';
import '../widgets/toggle_switch.dart';

class UserPanelPage extends ConsumerStatefulWidget {
  const UserPanelPage({super.key});

  @override
  ConsumerState<UserPanelPage> createState() => _UserPanelPageState();
}

class _UserPanelPageState extends ConsumerState<UserPanelPage> {
  SubAccountMiniInfoList? _previousSelectedAccount;
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
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    final chartNotifier = context.read<ChartNotifier>();
    
    if (selectedAccount != null) {
      await Future.wait([
        context.read<UserPanelNotifier>().fetchPanelData(
              subaccountId: selectedAccount.id!,
              coin: selectedAccount.selectCoin,
            ),
        chartNotifier.fetchChartData(subaccountId: selectedAccount.id!, coin: selectedAccount.selectCoin),
      ]);
    }
    if(mounted) {
       _easyRefreshController.finishRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final panelNotifier = context.watch<UserPanelNotifier>();
    final dogeLtcListNotifier = context.watch<DogeLtcListNotifier>();
    final selectedAccount = dogeLtcListNotifier.selectedAccount;

    if (dogeLtcListNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
    }

    if (selectedAccount != null && selectedAccount.id != 0 && selectedAccount != _previousSelectedAccount) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<UserPanelNotifier>().fetchPanelData(
                subaccountId: selectedAccount.id!,
                coin: selectedAccount.selectCoin,
              );
        }
      });
      _previousSelectedAccount = selectedAccount;
    }
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: authState.when(
        data: (user) {
          if (user != null && isEmpty(dogeLtcListNotifier.accounts)) {
            return _buildEmptyState(context);
          }

          if (selectedAccount != null && (selectedAccount.miningInfo?.activeWorkers ?? 0) == 0) {
            return AddMinerGuide(workerName: '${selectedAccount.name ?? 'subaccount'}.001');
          }

          if (panelNotifier.isLoading && panelNotifier.panelData == null) {
            return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
          }

          final panelData = panelNotifier.panelData;
          if (panelData == null) {
            return const Center(child: Text('请在抽屉中选择一个子账户以查看数据'));
          }
          return _buildUserPanelContent(panelData);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,)),
        error: (err, stack) => const Center(child: Text('请重新登录')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageUtils.homeCoinWa,
              width: 120.r,
              height: 120.r,
            ),
            SizedBox(height: 24.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.colorTitleOne,
                ),
                children: <TextSpan>[
                  TextSpan(text: '挖矿', style: TextStyle(color: ColorUtils.mainColor)),
                  const TextSpan(text: '并赚取收益'),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '欢迎加入 Kupool 矿池，准备开始您的挖矿之旅了吗？\n首先请创建您的第一个子账户，点击这里开始创建。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorUtils.colorT2,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubAccountCreatePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '添加子账户',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPanelContent(SubAccountPanelEntity panelData) {
    return EasyRefresh(
      controller: _easyRefreshController,
      header: const AppRefreshHeader(),
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            _buildInfoCard(
              iconPath: ImageUtils.panelSl,
              iconColor: const Color(0xFF00D187),
              title: '算力',
              child: _buildHashrateContent(panelData),
            ),
            SizedBox(height: 12),
            _buildInfoCard(
              iconPath: ImageUtils.panelKj,
              iconColor: const Color(0xFF3375E0),
              title: '矿机',
              child: _buildMinersContent(panelData),
            ),
            SizedBox(height: 12),
            _buildInfoCard(
              iconPath: ImageUtils.panelWksy,
              iconColor: const Color(0xFFF5A623),
              title: '挖矿收益',
              child: _buildRevenueContent(panelData),
            ),
            SizedBox(height: 12),
            _buildChartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return ChangeNotifierProvider(
      create: (_) => ChartNotifier(),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('算力图表', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorUtils.colorTitleOne)),
                const ToggleSwitch(),
              ],
            ),
            SizedBox(height: 8.h),
            const SizedBox(
              child: ChartForTHPage(),
            ),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: ColorUtils.mainColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text('算力', style: TextStyle(fontSize: 12, color: ColorUtils.color555)),
          ],
        ),
        const SizedBox(width: 24),
        Row(
          children: [
            Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text('拒绝率', style: TextStyle(fontSize: 12, color: ColorUtils.color555)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required String iconPath, required Color iconColor, required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.only(left: 16,top: 20,right: 16,bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 24.sp,
                height: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,color: ColorUtils.colorTitleOne)),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildHashrateContent(SubAccountPanelEntity data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildDataColumn(data.realtimeHashrate ?? "0", "${data.realtimeHashrateUnit ?? ''}H/s", '近 15 分钟',)),
        SizedBox(width: 6,),
        Expanded(child: _buildDataColumn(data.hour24Hashrate ?? '0', "${data.hour24HashrateUnit ?? ''}H/s", '近 24 小时')),
        SizedBox(width: 6,),
        Expanded(child: _buildDataColumn(data.yesterdayAcceptHashrate ?? '0', "${data.yesterdayAcceptHashrateUnit ?? ''}H/s", '昨日结算算力')),
      ],
    );
  }

  Widget _buildMinersContent(SubAccountPanelEntity data) {
    final totalMiners = (data.activeMiners ?? 0) + (data.inactiveMiners ?? 0) + (data.deadMiners ?? 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildDataColumn(totalMiners.toString(), '', '全部')),
        Expanded(child: _buildDataColumn((data.activeMiners ?? 0).toString(), '', '活跃', valueColor: const Color(0xFF04AC36))),
        Expanded(child: _buildDataColumn((data.inactiveMiners ?? 0).toString(), '', '不活跃', valueColor: const Color(0xFFFF383C))),
        Expanded(child: _buildDataColumn((data.deadMiners ?? 0).toString(), '', '失效', valueColor: Colors.grey)),
      ],
    );
  }

  Widget _buildRevenueContent(SubAccountPanelEntity data) {
    return Row(
      children: [
        Expanded(
          child: _buildRevenueColumn('昨日收益', selectCurrentCoinType == "ltc" ? [
           data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.yesterdayEarningsDoge ?? '0.00', 'DOGE'),
            data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.yesterdayEarnings ?? '0.00', 'LTC'),
          ] : [
            data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.yesterdayEarnings ?? '0.00', selectCurrentCoinType.toUpperCase()),
          ]),
        ),
        SizedBox(width: 12,),
        Expanded(
          child: _buildRevenueColumn('今日已挖 (预估)',selectCurrentCoinType == "ltc" ? [
            data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.todayEstimatedDoge ?? '0.00', 'DOGE'),
            data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.todayEstimated ?? '0.00', 'LTC'),
          ] : [
            data.settling ? MapEntry("账单生成中...", '') : MapEntry(data.todayEstimated ?? '0.00', selectCurrentCoinType.toUpperCase()),
          ]),
        ),
      ],
    );
  }

  Widget _buildDataColumn(String value, String unit, String label, {Color? valueColor, Color unitColor = ColorUtils.color888}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor ?? ColorUtils.colorT1),
              children: [
                TextSpan(text: value),
                TextSpan(text: ' $unit', style: TextStyle(fontSize: 12, color: unitColor)),
              ],
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12, color: ColorUtils.colorT2)),
      ],
    );
  }

  Widget _buildRevenueColumn(String label, List<MapEntry<String, String>> revenues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...revenues.map((entry) => Container(
            padding: const EdgeInsets.only(bottom: 6.0),
            child:
            isUnValidString(entry.value) ?
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1, fontWeight: FontWeight.w400),
                ),
              ],
            )
                :
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 2,child: _buildDecimalText(entry.key)),
                SizedBox(width: 4,),
                Flexible(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 36),
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 12, color: ColorUtils.color888, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
        )),
        Text(label, style: TextStyle(fontSize: 12, color: ColorUtils.colorT2,)),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...revenues.map((entry) => Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _buildDecimalText(entry.key)),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 40),
              child: Text(
                entry.value,
                style: const TextStyle(fontSize: 12, color: ColorUtils.color888, fontWeight: FontWeight.bold),
              ),
            ),
          ],)
        )
        )
        , Text(label, style: TextStyle(fontSize: 12, color: ColorUtils.colorT2,)),
      ],
    );
  }

  Widget _buildDecimalText(String text) {
    Color textColor = ColorUtils.colorT1;
    final intStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textColor);
    final decimalStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: textColor);

    if (text.contains('.')) {
      final parts = text.split('.');
      final integerPart = parts[0];
      final decimalPart = parts[1];

      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(text: integerPart, style: intStyle),
              TextSpan(text: '.', style: decimalStyle),
              TextSpan(text: decimalPart, style: decimalStyle),
            ],
          ),
        ),
      );
    } else {
      return Text(
        text,
        style: intStyle,
      );
    }
  }
}

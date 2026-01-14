import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/user_panel/provider/chart_notifier.dart';
import 'package:Kupool/user_panel/provider/user_panel_provider.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../model/subAccount_panel_entity.dart';
import '../widgets/chart_for_TH.dart';
import '../widgets/toggle_switch.dart';

// Reverted to a simple ConsumerWidget that only displays state.
class UserPanelPage extends ConsumerStatefulWidget {
  const UserPanelPage({super.key});

  @override
  ConsumerState<UserPanelPage> createState() => _UserPanelPageState();
}

class _UserPanelPageState extends ConsumerState<UserPanelPage> {
  SubAccountMiniInfoList? _previousSelectedAccount;
  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authNotifierProvider);
    final panelNotifier = context.watch<UserPanelNotifier>();

    final selectedAccount = context.watch<DogeLtcListNotifier>().selectedAccount;

    // 检查 selectedAccount 是否真的发生了变化
    if (selectedAccount != null && selectedAccount.id != 0 && selectedAccount != _previousSelectedAccount) {
      // 使用 addPostFrameCallback 将网络请求推迟到 build 周期之后
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // 安全地调用数据获取方法
        context.read<UserPanelNotifier>().fetchPanelData(
          subaccountId: selectedAccount.id!,
          coin: selectedAccount.selectCoin,
        );

      });
      // 更新追踪变量
      _previousSelectedAccount = selectedAccount;
    }
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: authState.when(
        data: (user) {
          if (user != null && (user.userInfo?.subaccounts ?? 0) == 0) {
            return _buildEmptyState(context);
          }

          if (selectedAccount != null && (selectedAccount.miningInfo?.activeWorkers ?? 0) == 0) {
            return _buildAddMinerGuide();
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
        error: (err, stack) => Center(child: Text('请重新登录')),
      ),
    );
  }

  Widget _buildAddMinerGuide() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "您需要添加矿机到矿池，然后开始挖矿",
              style: TextStyle(fontSize: 16.sp, color: ColorUtils.colorTitleOne),
            ),
          ),
          Text(
            '''1、电脑连接至矿机所在的局域网，获取矿机IP，登录至矿机后台。\n\n2、进入矿机配置页面，参照示例设置挖矿地址、矿工名，密码可为空，并保存配置。矿机名（worker）命名规则：子账户+英文句号+您想为矿机设置的编号。如果您的子账户为，那矿机名可以设置为 ${_previousSelectedAccount?.name ?? ''}.001\n\n3、保存配置等待生效，矿机将在5分钟内自动添加至矿池网站页面。''',
            style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('您还没有子账户', style: TextStyle(fontSize: 16, color: ColorUtils.colorNoteT1)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubAccountCreatePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorUtils.mainColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: const Text('+创建子账户',style: TextStyle(color: Colors.white,fontSize: 14),),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPanelContent(SubAccountPanelEntity panelData) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          _buildInfoCard(
            iconPath: ImageUtils.panelSl,
            iconColor: const Color(0xFF00D187),
            title: '算力',
            child: _buildHashrateContent(panelData),
          ),
          SizedBox(height: 12.h),
          _buildInfoCard(
            iconPath: ImageUtils.panelKj,
            iconColor: const Color(0xFF3375E0),
            title: '矿机',
            child: _buildMinersContent(panelData),
          ),
          SizedBox(height: 12.h),
          _buildInfoCard(
            iconPath: ImageUtils.panelWksy,
            iconColor: const Color(0xFFF5A623),
            title: '挖矿收益',
            child: _buildRevenueContent(panelData),
          ),
          SizedBox(height: 12.h),
          _buildChartCard(),
        ],
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
      padding: EdgeInsets.all(16.w),
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
        _buildDataColumn(data.realtimeHashrate ?? '0', "${data.realtimeHashrateUnit ?? ''}H/s", '近 15 分钟',),
        _buildDataColumn(data.hour24Hashrate ?? '0', "${data.hour24HashrateUnit ?? ''}H/s", '近 24 小时'),
        _buildDataColumn(data.yesterdayAcceptHashrate ?? '0', "${data.yesterdayAcceptHashrateUnit ?? ''}H/s", '昨日结算算力'),
      ],
    );
  }

  Widget _buildMinersContent(SubAccountPanelEntity data) {
    final totalMiners = (data.activeMiners ?? 0) + (data.inactiveMiners ?? 0) + (data.deadMiners ?? 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDataColumn(totalMiners.toString(), '', '全部'),
        _buildDataColumn((data.activeMiners ?? 0).toString(), '', '活跃', valueColor: const Color(0xFF04AC36)),
        _buildDataColumn((data.inactiveMiners ?? 0).toString(), '', '不活跃', valueColor: const Color(0xFFFF383C)),
        _buildDataColumn((data.deadMiners ?? 0).toString(), '', '失效', valueColor: Colors.grey),
      ],
    );
  }

  Widget _buildRevenueContent(SubAccountPanelEntity data) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _buildRevenueColumn('昨日收益', [
            // 使用 MapEntry 确保顺序和内容正确
            MapEntry(data.yesterdayEarningsDoge ?? '0.00', 'DOGE'),
            MapEntry(data.yesterdayEarnings ?? '0.00', 'LTC'),
          ]),
        ),
        SizedBox(width: 12,),
        Expanded(
          child: _buildRevenueColumn('今日已挖 (预估)', [
            // 使用 MapEntry 确保顺序和内容正确
            MapEntry(data.todayEstimatedDoge ?? '0.00', 'DOGE'),
            MapEntry(data.todayEstimated ?? '0.00', 'LTC'),
          ]),
        ),
      ],
    );
  }

  Widget _buildDataColumn(String value, String unit, String label, {Color? valueColor,Color unitColor = ColorUtils.color888}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
            SizedBox(width: 4),
            Text(unit, style: TextStyle(fontSize: 12, color: unitColor)),
          ],
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...revenues.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: _buildDecimalText(entry.key),
                ),
                SizedBox(width: 4),
                Text(entry.value, style: TextStyle(fontSize: 12, color: ColorUtils.color888, fontWeight: FontWeight.bold)),
              ],
            ),
          )),
        ],
      ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12, color: ColorUtils.colorT2,)),
      ],
    );
  }

  Widget _buildDecimalText(String text) {
    Color textColor = ColorUtils.colorT1;
    final intStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textColor);
    final decimalStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: textColor); // 小数点后的样式

    if (text.contains('.')) {
      final parts = text.split('.');
      final integerPart = parts[0];
      final decimalPart = parts[1];

      return RichText(
        text: TextSpan(// 继承默认文本样式
          children: <TextSpan>[
            TextSpan(text: integerPart, style: intStyle),
            TextSpan(text: '.', style: decimalStyle), // 小数点本身也用小号字体
            TextSpan(text: decimalPart, style: decimalStyle),
          ],
        ),
      );
    } else {
      // 如果没有小数点，直接返回一个普通的 Text Widget
      return Text(
        text,
        style: intStyle,
      );
    }
  }

}

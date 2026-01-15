import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/mining_machine/model/miner_list_entity.dart';
import 'package:Kupool/mining_machine/provider/mining_machine_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import '../../utils/image_utils.dart';

class MiningMachinePage extends StatefulWidget {
  const MiningMachinePage({super.key});

  @override
  State<MiningMachinePage> createState() => _MiningMachinePageState();
}

class _MiningMachinePageState extends State<MiningMachinePage> {
  SubAccountMiniInfoList? _previousSelectedAccount;
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    // Initial fetch is now handled by MainTabBar's onTap
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedAccount = context.watch<DogeLtcListNotifier>().selectedAccount;

    // This ensures that when the user switches accounts in the drawer,
    // this page, if already initialized, will fetch new data.
    if (selectedAccount != null && selectedAccount != _previousSelectedAccount) {
      _previousSelectedAccount = selectedAccount;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<MiningMachineNotifier>().fetchMiners(
                subaccountId: selectedAccount.id!,
                coin: selectedAccount.selectCoin,
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<MiningMachineNotifier>();

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 40),
            color: Colors.white,
          ),
          Column(
            children: [
              _buildStatusCards(notifier),
              Expanded(child: _buildMinersTable(notifier)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards(MiningMachineNotifier notifier) {
    final stats = notifier.statistics;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildStatusCard(stats?.total?.toString() ?? '0', '全部', 'all', notifier)),
            Expanded(child: _buildStatusCard(stats?.live?.toString() ?? '0', '活跃', 'live', notifier)),
            Expanded(child: _buildStatusCard(stats?.inactive?.toString() ?? '0', '不活跃', 'inactive', notifier)),
            Expanded(child: _buildStatusCard(stats?.dead?.toString() ?? '0', '失效', 'dead', notifier)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String count, String label, String activeType, MiningMachineNotifier notifier) {
    final isSelected = notifier.activeType == activeType;
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;

    return GestureDetector(
      onTap: () {
        if (selectedAccount != null) {
          notifier.changeStatusFilter(activeType, subaccountId: selectedAccount.id!, coin: selectedAccount.selectCoin);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: ColorUtils.mainColor.withAlpha(16),
                borderRadius: BorderRadius.circular(8.r),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorUtils.mainColor : ColorUtils.colorT1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(fontSize: 12.sp, color: isSelected ? ColorUtils.mainColor : ColorUtils.colorT2)),
            SizedBox(height: 4.h),
            Container(
              width: 20.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: isSelected ? ColorUtils.mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinersTable(MiningMachineNotifier notifier) {
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          _buildTableHeader(notifier),
          Expanded(
            child: EasyRefresh(
              controller: _controller,
              header: const AppRefreshHeader(),
              footer: const AppRefreshFooter(),
              onRefresh: () async {
                if (selectedAccount != null) {
                  await notifier.fetchMiners(
                    subaccountId: selectedAccount.id!,
                    coin: selectedAccount.defaultCoin!,
                    isPullToRefresh: true,
                  );
                  _controller.finishRefresh();
                  _controller.resetFooter();
                } else {
                  _controller.finishRefresh(IndicatorResult.fail);
                }
              },
              onLoad: () async {
                if (selectedAccount != null && notifier.hasMore) {
                  await notifier.fetchMiners(
                    subaccountId: selectedAccount.id!,
                    coin: selectedAccount.defaultCoin!,
                    isLoadMore: true,
                  );
                  _controller.finishLoad(notifier.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
                } else {
                  _controller.finishLoad(IndicatorResult.noMore);
                }
              },
              child: _buildMinerListView(notifier),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinerListView(MiningMachineNotifier notifier) {
    final miners = notifier.miners;
    if (notifier.isLoading && miners.isEmpty) {
        return const Center(child: CircularProgressIndicator());
    }
    if (miners.isEmpty) {
      _controller.finishRefresh();
      _controller.finishLoad();
      return const Center(child: Text('没有矿机数据'));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: miners.length,
      itemBuilder: (context, index) {
        final miner = miners[index];
        final rejectionRateValue = double.tryParse(miner.rejectRate ?? '0') ?? 0.0;
        final isHighRejection = rejectionRateValue > 1;

        return Column(
          children: [
            _buildMinerRow(
              name: miner.minerName ?? '',
              realtimeHashrate: '${miner.hash15m ?? '0'} ${miner.hash15mUnit ?? ''}',
              dailyHashrate: '${miner.hash24h ?? '0'} ${miner.hash24hUnit ?? ''}',
              rejectionRate: '${(rejectionRateValue * 100).toStringAsFixed(2)} %',
              rejectionColor: isHighRejection ? Colors.red : Colors.green,
            ),
            if (index < miners.length - 1)
              Divider(height: 0.5, indent: 16, endIndent: 16, color: Colors.grey[200]),
          ],
        );
      },
    );
  }

  Widget _buildTableHeader(MiningMachineNotifier notifier) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorUtils.widgetBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildHeaderCell('矿机名', 'miner_name', notifier, flex: 2),
          _buildHeaderCell('实时算力', 'hash_15m', notifier, flex: 2, alignment: TextAlign.right),
          _buildHeaderCell('日算力', 'hash_24h', notifier, flex: 2, alignment: TextAlign.right),
          _buildHeaderCell('拒绝率', 'reject_rate', notifier, flex: 2, alignment: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, String field, MiningMachineNotifier notifier, {int flex = 1, TextAlign alignment = TextAlign.left}) {
    final isSelected = notifier.sortField == field;
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          if (selectedAccount != null) {
            notifier.changeSort(field, subaccountId: selectedAccount.id!, coin: selectedAccount.selectCoin);
          }
        },
        child: Row(
          mainAxisAlignment: alignment == TextAlign.right ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? ColorUtils.mainColor : ColorUtils.colorT2,
              ),
            ),
            const SizedBox(width: 2),
            if (isSelected)
              Transform.rotate(
                angle: notifier.sortAscending ? math.pi : 0,
                child: Image.asset(
                  ImageUtils.arrowDown,
                  width: 12,
                  height: 12,
                  color: ColorUtils.mainColor,
                  gaplessPlayback: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashrateWidget(String text, {TextAlign alignment = TextAlign.left}) {
    final parts = text.split(' ');
    final value = parts.isNotEmpty ? parts[0] : '';
    final unit = parts.length > 1 ? ' ${parts.sublist(1).join(' ')}' : '';

    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
        children: [
          TextSpan(text: value),
          TextSpan(
            text: "${unit}H/s",
            style: TextStyle(color: ColorUtils.color888, fontSize: 14),
          ),
        ],
      ),
      textAlign: alignment,
    );
  }

  Widget _buildMinerRow({
    required String name,
    required String realtimeHashrate,
    required String dailyHashrate,
    required String rejectionRate,
    required Color rejectionColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name, textAlign: TextAlign.left, style: TextStyle(fontSize: 14, color: ColorUtils.colorT1))),
          Expanded(flex: 2, child: _buildHashrateWidget(realtimeHashrate, alignment: TextAlign.center)),
          Expanded(flex: 2, child: _buildHashrateWidget(dailyHashrate, alignment: TextAlign.center)),
          Expanded(flex: 1, child: Text(rejectionRate, textAlign: TextAlign.right, style: TextStyle(fontSize: 14, color: rejectionColor))),
        ],
      ),
    );
  }
}

import 'dart:ui' as ui;
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/earnings/provider/standard_earnings_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/logger.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/image_utils.dart';
import '../../widgets/custom_tab_bar.dart';

class StandardEarningsPage extends StatefulWidget {
  const StandardEarningsPage({super.key});

  @override
  State<StandardEarningsPage> createState() => _StandardEarningsPageState();
}

class _StandardEarningsPageState extends State<StandardEarningsPage> with SingleTickerProviderStateMixin {
  late TabController _recordsTabController;
  late EasyRefreshController _refreshController;
  SubAccountMiniInfoList? _previousSelectedAccount;

  final leftPadding = 10.0;
  final rightPadding = 10.0;


  @override
  void initState() {
    super.initState();
    _recordsTabController = TabController(length: 2, vsync: this);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _recordsTabController.addListener(_handleTabSelection);
    // Initial data fetch is now handled by didChangeDependencies
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
          context.read<StandardEarningsNotifier>().refreshAll(selectedAccount.id!, _recordsTabController.index);
        }
      });
    }
  }

  void _handleTabSelection() {
    if (_recordsTabController.indexIsChanging) return;
    final notifier = context.read<StandardEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount == null) return;

    if (_recordsTabController.index == 1 && notifier.paymentRecords.isEmpty) {
      notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 1);
    }
    if (_recordsTabController.index == 0 && notifier.earningRecords.isEmpty) {
      notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 0);
    }
  }

  @override
  void dispose() {
    _recordsTabController.removeListener(_handleTabSelection);
    _recordsTabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final notifier = context.read<StandardEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount != null) {
      await notifier.refreshAll(selectedAccount.id!, _recordsTabController.index);
      _refreshController.finishRefresh();
      _refreshController.resetFooter();
    } else {
      _refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> _onLoad() async {
    final notifier = context.read<StandardEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    final currentTabIndex = _recordsTabController.index;
    bool hasMore = currentTabIndex == 0 ? notifier.hasMoreEarnings : notifier.hasMorePayments;

    if (selectedAccount != null && hasMore) {
      await notifier.fetchRecords(subaccountId: selectedAccount.id!, type: currentTabIndex, isLoadMore: true);
      bool newHasMore = currentTabIndex == 0 ? notifier.hasMoreEarnings : notifier.hasMorePayments;
      _refreshController.finishLoad(newHasMore ? IndicatorResult.success : IndicatorResult.noMore);
    } else {
      _refreshController.finishLoad(IndicatorResult.noMore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<StandardEarningsNotifier>();
    final bool isEarningTab = _recordsTabController.index == 0;
    final List<EarningsRecordList> currentRecords = isEarningTab ? notifier.earningRecords : notifier.paymentRecords;

    // Show loading indicator only when fetching for the first time.
    if (notifier.isSummaryLoading && notifier.dogeInfo == null && notifier.ltcInfo == null) {
        return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
    }

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: EasyRefresh.builder(
        controller: _refreshController,
        header: const AppRefreshHeader(),
        footer: const AppRefreshFooter(),
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        childBuilder: (context, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding:  EdgeInsets.fromLTRB(leftPadding, 10, rightPadding, 0),
                  child: _buildCombinedEarningsCard(notifier),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverHeaderDelegate(
                  child: _buildRecordsSectionHeader(),
                  height: 116.0,
                ),
              ),
              if (notifier.isRecordsLoading && currentRecords.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,)),
                )
              else if (currentRecords.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('暂无记录')),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final record = currentRecords[index];
                      return _buildRecordRow(
                        date: (record.datetime ?? '').split(' ').first,
                        status: record.status?.toString() ?? '',
                        amount: record.amount ?? '0',
                        currency: (record.coin ?? '').toUpperCase(),
                      );
                    },
                    childCount: currentRecords.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordsSectionHeader() {
     return Container(
      margin:  EdgeInsets.only(left: leftPadding,right: rightPadding,top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 12),
            child: AnimatedBuilder(
              animation: _recordsTabController.animation!,
              builder: (context, _) => CustomTabBar(controller: _recordsTabController,tabs: const ["收益记录","支付记录"],
                onTabSelected: (int p1) {
                  LogPrint.i("收益记录-支付记录" + "$p1");
                  context.read<StandardEarningsNotifier>().setSelectIndex(p1);
                },),
            ),
          ),
           _buildRecordsHeader(),
        ],
      ),
    );
  }

  Widget _buildCombinedEarningsCard(StandardEarningsNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 6),
            child: _buildTitledContent(
              title: '昨日收益',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEarningRow(notifier.dogeInfo?.yesterdayEarnings ?? '0.00', 'DOGE', amountSize: 20, currencySize: 16),
                  const SizedBox(height: 2),
                  _buildEarningRow(notifier.ltcInfo?.yesterdayEarnings ?? '0.00', 'LTC', amountSize: 20, currencySize: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6,top: 6),
            child: Row(
              children: [
                Expanded(
                  child: _buildInnerCard(
                    title: '累计已支付',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEarningRow(notifier.dogeInfo?.totalPaid ?? '0.00', 'DOGE'),
                        const SizedBox(height: 8),
                        _buildEarningRow(notifier.ltcInfo?.totalPaid ?? '0.00', 'LTC'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildInnerCard(
                    title: '账户余额',
                    hasInfoIcon: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         _buildEarningRow(notifier.dogeInfo?.balance ?? '0.00', 'DOGE',),
                         const SizedBox(height: 8),
                         _buildEarningRow(notifier.ltcInfo?.balance ?? '0.00', 'LTC',),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildInnerCard({required String title, required Widget child, bool hasInfoIcon = true}) {
    return Container(
        padding: const EdgeInsets.only(left: 6,right: 6,top: 8,bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildTitledContent(title: title, hasInfoIcon: hasInfoIcon, child: child));
  }

  Widget _buildTitledContent({required String title, required Widget child, bool hasInfoIcon = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorT2)),
            if (hasInfoIcon)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Image(
                  image: AssetImage(ImageUtils.infoIcon),
                  width: 14,
                  height: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildEarningRow(String amount, String currency, {double? amountSize, double? currencySize}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(amount, style: TextStyle(fontSize: amountSize ?? 15, fontWeight: FontWeight.normal, color: ColorUtils.colorTitleOne)),
          ),
        ),
        const SizedBox(width: 4),
        Text(currency, style: TextStyle(fontSize: currencySize ?? 12, color: ColorUtils.color888)),
      ],
    );
  }

  Widget _buildRecordsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: ColorUtils.colorHeadBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('挖矿日期', style: TextStyle(fontSize: 13, color: ColorUtils.colorNoteT2)),
              const SizedBox(width: 4),
              Image.asset(ImageUtils.infoIcon, width: 14, height: 14),
            ],
          ),
          Text('数额', style: TextStyle(fontSize: 14, color: ColorUtils.colorNoteT2)),
        ],
      ),
    );
  }

  Widget _buildRecordRow({required String date, required String status, required String amount, required String currency}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1))),
          Expanded(flex: 1, child: Text(status, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: _getStatusColor(status)))),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(child: Text(amount, textAlign: TextAlign.right,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: ColorUtils.colorTitleOne))),
                const SizedBox(width: 4),
                Text(currency, style: const TextStyle(fontSize: 12, color: ColorUtils.color888)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '1': // 已支付
        return Colors.green;
      case '0': // 待支付
        return ColorUtils.mainColor;
      case '2': // 未入账
        return Colors.red;
      default:
        return ColorUtils.colorT2;
    }
  }
}

// A custom delegate for creating a sticky header.
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorUtils.widgetBgColor, // Match scaffold background
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}

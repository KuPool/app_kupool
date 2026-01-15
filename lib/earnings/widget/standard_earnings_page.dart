import 'dart:ui' as ui;
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/earnings/provider/standard_earnings_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StandardEarningsPage extends StatefulWidget {
  const StandardEarningsPage({super.key});

  @override
  State<StandardEarningsPage> createState() => _StandardEarningsPageState();
}

class _StandardEarningsPageState extends State<StandardEarningsPage> with SingleTickerProviderStateMixin {
  late TabController _recordsTabController;
  late EasyRefreshController _refreshController;
  SubAccountMiniInfoList? _previousSelectedAccount;

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
        return const Center(child: CircularProgressIndicator());
    }

    return EasyRefresh.builder(
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: _buildCombinedEarningsCard(notifier),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                child: _buildRecordsSectionHeader(),
                height: 120.0, 
              ),
            ),
            if (notifier.isRecordsLoading && currentRecords.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
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
                      date: record.datetime ?? '',
                      status: record.status?.toString() ?? '',
                      amount: record.amount ?? '0',
                      currency: record.coin ?? '',
                    );
                  },
                  childCount: currentRecords.length,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecordsSectionHeader() {
     return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            child: AnimatedBuilder(
              animation: _recordsTabController.animation!,
              builder: (context, _) => _buildCustomTabBar(),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTitledContent(
              title: '昨日收益',
              child: Column(
                children: [
                  _buildEarningRow(notifier.dogeInfo?.yesterdayEarnings ?? '0.00', 'DOGE', amountSize: 20, currencySize: 16),
                  const SizedBox(height: 8),
                  _buildEarningRow(notifier.ltcInfo?.yesterdayEarnings ?? '0.00', 'LTC', amountSize: 20, currencySize: 16),
                ],
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildInnerCard(
                    title: '累计已支付',
                    child: Column(
                      children: [
                        _buildEarningRow(notifier.dogeInfo?.totalPaid ?? '0.00', 'DOGE'),
                        const SizedBox(height: 8),
                        _buildEarningRow(notifier.ltcInfo?.totalPaid ?? '0.00', 'LTC'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInnerCard(
                    title: '账户余额',
                    hasInfoIcon: false,
                    child: Column(
                      children: [
                         _buildEarningRow(notifier.dogeInfo?.balance ?? '0.00', 'DOGE'),
                         const SizedBox(height: 8),
                         _buildEarningRow(notifier.ltcInfo?.balance ?? '0.00', 'LTC'),
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
        padding: const EdgeInsets.all(12.0),
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
                child: Icon(Icons.info_outline, size: 16, color: ColorUtils.colorT2),
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
        Text(amount, style: TextStyle(fontSize: amountSize ?? 15, fontWeight: FontWeight.normal, color: ColorUtils.colorTitleOne)),
        const SizedBox(width: 8),
        Text(currency, style: TextStyle(fontSize: currencySize ?? 12, color: ColorUtils.color888)),
      ],
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
    return textPainter.size.width;
  }

  Widget _buildCustomTabBar() {
    const double indicatorWidth = 16;
    const double spacing = 24;

    final tabTexts = ['收益记录', '支付记录'];
    final tabWidths = tabTexts.map((text) => _getTextWidth(text, const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))).toList();

    final startX = (tabWidths[0] - indicatorWidth) / 2;
    final endX = tabWidths[0] + spacing + (tabWidths[1] - indicatorWidth) / 2;

    final animation = _recordsTabController.animation!;
    final currentX = ui.lerpDouble(startX, endX, animation.value)!;

    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabItem(text: tabTexts[0], index: 0),
            const SizedBox(width: spacing),
            _buildTabItem(text: tabTexts[1], index: 1),
          ],
        ),
        Positioned(
          bottom: 0,
          left: currentX,
          child: Container(
            height: 3,
            width: indicatorWidth,
            decoration: BoxDecoration(
              color: ColorUtils.mainColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({required String text, required int index}) {
    final animation = _recordsTabController.animation!;
    final double selectionFactor = (1.0 - (animation.value - index).abs()).clamp(0.0, 1.0);
    final Color textColor = Color.lerp(ColorUtils.colorT2, ColorUtils.mainColor, selectionFactor)!;
    final FontWeight fontWeight = FontWeight.lerp(FontWeight.normal, FontWeight.w600, selectionFactor)!;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _recordsTabController.animateTo(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
            const SizedBox(height: 9), // Space for indicator
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white, // Match the card color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('挖矿日期', style: TextStyle(fontSize: 12, color: ColorUtils.colorT2)),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 14, color: ColorUtils.colorT2),
            ],
          ),
          Text('数额', style: TextStyle(fontSize: 12, color: ColorUtils.colorT2)),
        ],
      ),
    );
  }

  Widget _buildRecordRow({required String date, required String status, required String amount, required String currency}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1))),
          Expanded(flex: 1, child: Text(status, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: _getStatusColor(status)))),
          Expanded(
            flex: 4,
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
      color: Theme.of(context).scaffoldBackgroundColor, // Match scaffold background
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}

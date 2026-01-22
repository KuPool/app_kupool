import 'dart:ui' as ui;
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/earnings/provider/ecological_earnings_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:Kupool/widgets/custom_tab_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcologicalEarningsPage extends StatefulWidget {
  const EcologicalEarningsPage({super.key});

  @override
  State<EcologicalEarningsPage> createState() => _EcologicalEarningsPageState();
}

class _EcologicalEarningsPageState extends State<EcologicalEarningsPage> with SingleTickerProviderStateMixin {
  late TabController _recordsTabController;
  late EasyRefreshController _refreshController;
  OverlayEntry? _overlayEntry;

  final GlobalKey _yesterdayEarningsKey = GlobalKey();
  final GlobalKey _cumulativePaymentKey = GlobalKey();

  final List<Map<String, String>> _coins = [
    {'name': 'BELLS', 'icon': ImageUtils.coinBells},
    {'name': 'LKY', 'icon': ImageUtils.coin_lky},
    {'name': 'PEP', 'icon': ImageUtils.coin_pep},
    {'name': 'SHIC', 'icon': ImageUtils.coin_shic},
    {'name': 'TRMP', 'icon': ImageUtils.coin_trmp},
    {'name': 'DIGO', 'icon': ImageUtils.coin_dingo},
    {'name': 'JKC', 'icon': ImageUtils.coin_jkc},
    {'name': 'CRC', 'icon': ImageUtils.coin_crc},
  ];

  @override
  void initState() {
    super.initState();
    _recordsTabController = TabController(length: 2, vsync: this);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _recordsTabController.addListener(_handleTabSelection);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
      if (selectedAccount != null) {
        context.read<EcologicalEarningsNotifier>().initialFetch(selectedAccount.id!);
      }
    });
  }

  void _handleTabSelection() {
    if (_recordsTabController.indexIsChanging) return;
    final notifier = context.read<EcologicalEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount == null) return;

    if (_recordsTabController.index == 1 && notifier.paymentRecords.isEmpty) {
      notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 1);
    } else if (_recordsTabController.index == 0 && notifier.earningRecords.isEmpty) {
      notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 0);
    }
  }

  @override
  void dispose() {
    _removeTooltip();
    _recordsTabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }
  
  void _showTooltip(BuildContext context, GlobalKey key, String message) {
    if (_overlayEntry != null) {
      _removeTooltip();
      return;
    }
    final overlay = Overlay.of(context);
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final screenWidth = MediaQuery.of(context).size.width;
    const tooltipWidth = 220.0; 
    const screenPadding = 10.0;

    double left = offset.dx - 14;

    double arrowX = offset.dx + size.width / 2 - left;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5, 
        left: left,
        child: GestureDetector(
          onTap: _removeTooltip, 
          child: Material(
            color: Colors.transparent,
            child: _TooltipWidget(message: message, arrowX: arrowX, width: tooltipWidth),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }


  Future<void> _onRefresh() async {
    final notifier = context.read<EcologicalEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount != null) {
      await notifier.refreshAll(selectedAccount.id!, _recordsTabController.index);
      _refreshController.finishRefresh();
      _refreshController.resetFooter();
    }
  }

  Future<void> _onLoad() async {
    final notifier = context.read<EcologicalEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    final currentTabIndex = _recordsTabController.index;
    bool hasMore = currentTabIndex == 0 ? notifier.hasMoreEarnings : notifier.hasMorePayments;

    if (selectedAccount != null && hasMore) {
      await notifier.fetchRecords(subaccountId: selectedAccount.id!, type: currentTabIndex, isLoadMore: true);
      _refreshController.finishLoad(notifier.hasMoreEarnings ? IndicatorResult.success : IndicatorResult.noMore);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<EcologicalEarningsNotifier>();
    final bool isEarningTab = _recordsTabController.index == 0;
    final List<EarningsRecordList> currentRecords = isEarningTab ? notifier.earningRecords : notifier.paymentRecords;

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: GestureDetector(
        onTap: _removeTooltip,
        child: Stack(
          children: [
            EasyRefresh.builder(
              controller: _refreshController,
              header: const AppRefreshHeader(),
              footer: AppRefreshFooter(),
              onRefresh: _onRefresh,
              onLoad: _onLoad,
              childBuilder: (context, physics) {
                return CustomScrollView(
                  physics: physics,
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: _buildCoinSelectionChips(notifier)),
                    if (notifier.hasError)
                      const SliverFillRemaining(
                        child: Center(child: Text('数据丢失，下拉重新加载')),
                      )
                    else ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      if (currentRecords.isEmpty)
                        const SliverFillRemaining(child: Center(child: Text('暂无记录')))
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final record = currentRecords[index];
                              final isLast = index == currentRecords.length - 1;
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    _buildRecordRow(
                                      date: (record.datetime ?? '').split(' ').first,
                                      status: record.status?.toString() ?? '',
                                      amount: record.amount ?? '0',
                                      currency: (record.coin ?? '').toUpperCase(),
                                    ),
                                    if (!isLast) Divider(height: 0.5, color: ColorUtils.colorDdd.withAlpha(125),),
                                  ],
                                ),
                              );
                            },
                            childCount: currentRecords.length,
                          ),
                        ),
                      ]
                  ],
                );
              },
            ),
            if (notifier.isLoading)
              const Center(
                child: CircularProgressIndicator(color: ColorUtils.mainColor,),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinSelectionChips(EcologicalEarningsNotifier notifier) {
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _coins.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final GlobalKey chipKey = GlobalKey();
          final coin = _coins[index];
          final bool isSelected = notifier.selectedCoin == coin['name'];
          return ChoiceChip(
            key: chipKey,
            label: Text(coin['name']!),
            avatar: Image.asset(coin['icon']!, width: 24, height: 24),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (selected) {
              if (selected && selectedAccount != null) {
                if (chipKey.currentContext != null) {
                  // 这是核心代码！
                  Scrollable.ensureVisible(
                    chipKey.currentContext!,
                    duration: const Duration(milliseconds: 300), // 滚动动画时长
                    curve: Curves.easeInOut, // 滚动动画曲线
                    alignment: 0.5, // 0.0 表示顶部对齐, 1.0 表示底部对齐, 0.5 表示居中
                  );
                }
                notifier.changeCoin(coin['name']!, selectedAccount.id!);
              }
            },
            selectedColor: ColorUtils.mainColor.withAlpha(30),
            backgroundColor: Color(0xFFE6E6E6),
            labelStyle: TextStyle(
              fontSize: 14,
              color: isSelected ? ColorUtils.mainColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? ColorUtils.mainColor : Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          );
        },
      ),
    );
  }

  Widget _buildRecordsSectionHeader() {
     return Container(
      margin:  const EdgeInsets.only(left: 10,right: 10,top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 12),
            child: CustomTabBar(controller: _recordsTabController,tabs: const ["收益记录","支付记录"], onTabSelected: (tapIndex){
              context.read<EcologicalEarningsNotifier>().setSelectIndex(tapIndex);
            }),
          ),
           _buildRecordsHeader(),
        ],
      ),
    );
  }

  Widget _buildCombinedEarningsCard(EcologicalEarningsNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 6),
            child: _buildTitledContent(
              title: '昨日收益',
              infoKey: _yesterdayEarningsKey,
              tooltipMessage: '当前的收益预估数据是按照FPPS模式计算给出的理论参考值, 可能与实际收入存在略微差异。',
              child: _buildEarningRow(notifier.summaryInfo?.yesterdayEarnings ?? '0.00', notifier.selectedCoin, amountSize: 20, currencySize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6,right: 6,bottom: 6,top: 6),
            child: Row(
              children: [
                Expanded(
                  child: _buildInnerCard(
                    title: '累计已支付',
                    infoKey: _cumulativePaymentKey,
                    tooltipMessage: '累计已支付是矿池已经成功支付到您指定地址的收益总额。',
                    child: _buildEarningRow(notifier.summaryInfo?.totalPaid ?? '0.00', notifier.selectedCoin),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildInnerCard(
                    title: '账户余额',
                    hasInfoIcon: false,
                    child: _buildEarningRow(notifier.summaryInfo?.balance ?? '0.00', notifier.selectedCoin),
                  ),
                ),
              ],
            ),
          )
        ],      ),    );  }
  
  Widget _buildInnerCard({required String title, required Widget child, bool hasInfoIcon = true, String? tooltipMessage, GlobalKey? infoKey}) {
    return Container(
        padding: const EdgeInsets.only(left: 6,right: 6,top: 8,bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildTitledContent(title: title, hasInfoIcon: hasInfoIcon, child: child, tooltipMessage: tooltipMessage, infoKey: infoKey));
  }

  Widget _buildTitledContent({required String title, required Widget child, bool hasInfoIcon = true, String? tooltipMessage, GlobalKey? infoKey}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (hasInfoIcon && tooltipMessage != null && infoKey != null) {
              _showTooltip(context, infoKey, tooltipMessage);
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorT2)),
                if (hasInfoIcon)
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Container(
                      key: infoKey,
                      child: Image(image: AssetImage(ImageUtils.infoIcon), width: 14, height: 14),
                    ),
                  ),
              ],
            ),
          ),
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
            ],
          ),
          Text('数额', style: TextStyle(fontSize: 14, color: ColorUtils.colorNoteT2)),
        ],
      ),
    );
  }

  Widget _buildRecordRow({required String date,required String status, required String amount, required String currency,}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1))),
          Expanded(flex: 1, child: Text(status, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: ColorUtils.mainColor))),
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
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorUtils.widgetBgColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}

class _TooltipWidget extends StatelessWidget {
  final String message;
  final double arrowX;
  final double width;

  const _TooltipWidget({required this.message, required this.arrowX, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CustomPaint(
        painter: _TooltipPainter(arrowX: arrowX),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
          ),
        ),
      ),
    );
  }
}

class _TooltipPainter extends CustomPainter {
  final double arrowX;
  _TooltipPainter({required this.arrowX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    const arrowHeight = 6.0;
    const arrowWidth = 12.0;
    const radius = 10.0;

    final path = Path()
      ..moveTo(arrowX - arrowWidth / 2, arrowHeight)
      ..lineTo(arrowX, 0)
      ..lineTo(arrowX + arrowWidth / 2, arrowHeight)
      ..lineTo(radius, arrowHeight)
      ..arcToPoint(
        const Offset(0, arrowHeight + radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(0, size.height - radius)
      ..arcToPoint(
        Offset(radius, size.height),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width, arrowHeight + radius)
      ..arcToPoint(
        Offset(size.width - radius, arrowHeight),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  bool shouldRebuild(_TooltipPainter oldDelegate) {
    return arrowX != oldDelegate.arrowX;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

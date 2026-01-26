import 'dart:math';
import 'dart:ui' as ui;
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/earnings/provider/standard_earnings_notifier.dart';
import 'package:Kupool/utils/base_data.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:Kupool/widgets/custom_tab_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StandardEarningsPage extends StatefulWidget {
  const StandardEarningsPage({super.key});

  @override
  State<StandardEarningsPage> createState() => _StandardEarningsPageState();
}

class _StandardEarningsPageState extends State<StandardEarningsPage> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  late TabController _recordsTabController;
  late EasyRefreshController _refreshController;
  SubAccountMiniInfoList? _previousSelectedAccount;
  OverlayEntry? _overlayEntry;

  final GlobalKey _yesterdayEarningsKey = GlobalKey();
  final GlobalKey _cumulativePaymentKey = GlobalKey();
  final GlobalKey _wkDatePaymentKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();

  final leftPadding = 10.0;
  final rightPadding = 10.0;

  final ScrollController _scrollController = ScrollController();
  double _scrollPositionEarn = 0.0;
  double _scrollPositionPay = 0.0;

  @override
  void initState() {
    super.initState();
    _recordsTabController = TabController(length: 2, vsync: this);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _scrollController.addListener(_saveScrollPosition);
  }
  void _saveScrollPosition() {
    if(_recordsTabController.index == 0){
      _scrollPositionEarn = _scrollController.position.pixels;
    }else{
      _scrollPositionPay = _scrollController.position.pixels;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedAccount = context.watch<DogeLtcListNotifier>().selectedAccount;

    if (selectedAccount != null && (selectedAccount.id != _previousSelectedAccount?.id || selectedAccount.selectCoin !=  _previousSelectedAccount?.selectCoin)) {
      _previousSelectedAccount = selectedAccount;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<StandardEarningsNotifier>().refreshAll(selectedAccount.id!, _recordsTabController.index,selectedAccount.selectCoin);
        }
      });
    }
  }

  void _handleTabSelection() {
    final notifier = context.read<StandardEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount == null) return;

    final RenderSliver renderSliver =
    _headerKey.currentContext?.findRenderObject() as RenderSliver;

    final headerStick =  renderSliver.constraints.precedingScrollExtent;

    if(_recordsTabController.index == 0 && notifier.earningRecords.isEmpty){
      if(_scrollPositionPay >= headerStick){
        _scrollController.jumpTo(headerStick);
      }
    }
    if(_recordsTabController.index == 1 && notifier.paymentRecords.isEmpty){
      if(_scrollPositionEarn >= headerStick){
        _scrollController.jumpTo(headerStick);
      }
    }
    if(_recordsTabController.index == 0){
      if(_scrollPositionPay >= headerStick && _scrollPositionEarn >= headerStick){
        _scrollController.jumpTo(_scrollPositionEarn);
      }else {
        double minPost = min(headerStick, _scrollPositionPay);
        _scrollController.jumpTo(minPost);
      }
      _scrollPositionEarn = _scrollController.position.pixels;

    }else{
      if(_scrollPositionPay >= headerStick && _scrollPositionEarn >= headerStick){
        _scrollController.jumpTo(_scrollPositionPay);
      }else{
        double minPost = min(headerStick, _scrollPositionEarn);
        _scrollController.jumpTo(minPost);
      }
      _scrollPositionPay = _scrollController.position.pixels;
    }


    if (_recordsTabController.index == 1 && notifier.paymentRecords.isEmpty) {
      _refreshController.finishRefresh();
      _refreshController.resetFooter();
      notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 1,coinType: selectedAccount.selectCoin);
    } else if (_recordsTabController.index == 0 && notifier.earningRecords.isEmpty) {
      _refreshController.finishRefresh();
      _refreshController.resetFooter();
       notifier.fetchRecords(subaccountId: selectedAccount.id!, type: 0,coinType: selectedAccount.selectCoin);
    }

  }

  @override
  void dispose() {
    _removeTooltip();
    _recordsTabController.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
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

    // double left = offset.dx + size.width / 2 - tooltipWidth / 2;
    // left = left.clamp(screenPadding, screenWidth - tooltipWidth - screenPadding);
    double left = offset.dx - 14;

    double arrowX = offset.dx + size.width / 2 - left;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                _removeTooltip();
              },
              child: SizedBox(height:MediaQuery.of(context).size.height ,width: screenWidth,)
          ),
          Positioned(
            top: offset.dy + size.height + 5, // Position below the icon
            left: left,
            child: GestureDetector(
              onTap: _removeTooltip, // Allow tapping the tooltip to dismiss
              child: Material(
                color: Colors.transparent,
                child: _TooltipWidget(message: message, arrowX: arrowX+2, width: tooltipWidth),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _onRefresh() async {
    final notifier = context.read<StandardEarningsNotifier>();
    final selectedAccount = context.read<DogeLtcListNotifier>().selectedAccount;
    if (selectedAccount != null) {
      await notifier.refreshAll(selectedAccount.id!, _recordsTabController.index,selectedAccount.selectCoin);
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
      await notifier.fetchRecords(subaccountId: selectedAccount.id!, type: currentTabIndex, isLoadMore: true,coinType: selectedAccount.selectCoin);
      bool newHasMore = currentTabIndex == 0 ? notifier.hasMoreEarnings : notifier.hasMorePayments;
      _refreshController.finishLoad(newHasMore ? IndicatorResult.success : IndicatorResult.noMore);
    } else {
      _refreshController.finishLoad(IndicatorResult.noMore);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final notifier = context.watch<StandardEarningsNotifier>();
    final bool isEarningTab = _recordsTabController.index == 0;
    final List<EarningsRecordList> currentRecords = isEarningTab ? notifier.earningRecords : notifier.paymentRecords;

    if(isEarningTab){
      _refreshController.finishLoad(notifier.hasMoreEarnings ? IndicatorResult.success : IndicatorResult.noMore);
    }else{
      _refreshController.finishLoad(notifier.hasMorePayments ? IndicatorResult.success : IndicatorResult.noMore);
    }

    if (notifier.isSummaryLoading && notifier.dogeInfo == null && notifier.ltcInfo == null) {
        return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
    }

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: EasyRefresh.builder(
        controller: _refreshController,
        header: const AppRefreshHeader(),
        footer: AppRefreshFooter(),
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        childBuilder: (context, physics) {
          return CustomScrollView(
            controller: _scrollController,
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
                key: _headerKey,
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
                      final isLast = index == currentRecords.length - 1;
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            _buildRecordRow(
                              date: (record.datetime ?? '').split(' ').first,
                              status: record.status,
                              amount: record.amount ?? '0',
                              currency: (record.coin ?? '').toUpperCase(),
                              direction: record.direction ?? "",
                              txHash: record.txHash ?? "",
                            ),
                            if (!isLast)
                              Divider(height: 0.5, color: ColorUtils.colorDdd.withAlpha(125),),
                          ],
                        ),
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

  Widget statusConvertForWidget(int? code, String direction,String txHash) {

    if(code == null){
      return SizedBox.shrink();
    }
    String statusStr = "";
    switch (code) {
      case 0:
        statusStr = '未入账';
       return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
         color: const Color(0xFFF53F3F),
         fontSize: 12,
         fontWeight: FontWeight.w400,
       ),);

      case 10:
        statusStr = '已审核';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case 20:
        statusStr = '准备发款';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);


      case 21:
        statusStr = '发款中';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case 30:
        statusStr = (direction == 'i' && isUnValidString(txHash)) ? '待支付' : '已支付';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: (direction == 'i' && isUnValidString(txHash)) ? ColorUtils.mainColor : const Color(0xFF00C490),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case -1:
        statusStr = '已取消';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: const Color(0xFFF53F3F),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      default:
        return SizedBox.shrink();
    }
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
                context.read<StandardEarningsNotifier>().setSelectIndex(p1);
                _handleTabSelection();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 6),
            child: _buildTitledContent(
              title: '昨日收益',
              tooltipMessage: '当前的收益预估数据是按照FPPS模式计算给出的理论参考值, 可能与实际收入存在略微差异。',
              infoKey: _yesterdayEarningsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectCurrentCoinType == "ltc" ?  [
                  _buildEarningRow(notifier.dogeInfo?.yesterdayEarnings ?? '0.00', 'DOGE', amountSize: 20, currencySize: 16),
                  const SizedBox(height: 2),
                  _buildEarningRow(notifier.ltcInfo?.yesterdayEarnings ?? '0.00', 'LTC', amountSize: 20, currencySize: 16),
                ] : [
                  _buildEarningRow(notifier.coinInfo?.yesterdayEarnings ?? '0.00', selectCurrentCoinType.toUpperCase(), amountSize: 20, currencySize: 16),
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
                    tooltipMessage: '累计已支付是矿池已经成功支付到您指定地址的收益总额。',
                    infoKey: _cumulativePaymentKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectCurrentCoinType == "ltc" ? [
                        _buildEarningRow(notifier.dogeInfo?.totalPaid ?? '0.00', 'DOGE'),
                        const SizedBox(height: 8),
                        _buildEarningRow(notifier.ltcInfo?.totalPaid ?? '0.00', 'LTC'),
                      ] : [
                        _buildEarningRow(notifier.coinInfo?.totalPaid ?? '0.00', selectCurrentCoinType.toUpperCase()),
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
                      children: selectCurrentCoinType == "ltc" ? [
                         _buildEarningRow(notifier.dogeInfo?.balance ?? '0.00', 'DOGE',),
                         const SizedBox(height: 8),
                         _buildEarningRow(notifier.ltcInfo?.balance ?? '0.00', 'LTC',),
                      ] : [
                        _buildEarningRow(notifier.coinInfo?.balance ?? '0.00', selectCurrentCoinType.toUpperCase(),),
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
          onTap: (){
            if (hasInfoIcon){
              if (tooltipMessage != null && infoKey != null) {
                _showTooltip(context, infoKey, tooltipMessage);
              }
            }
          },
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorT2)),
                if (hasInfoIcon)
                  Container(
                    key: infoKey,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Image(
                        image: AssetImage(ImageUtils.infoIcon),
                        width: 14,
                        height: 14,
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: ColorUtils.colorHeadBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _showTooltip(context, _wkDatePaymentKey, "货币挖矿中记录区块生成或算力贡献时间");
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text('挖矿日期', style: TextStyle(fontSize: 13, color: ColorUtils.colorNoteT2)),
                  const SizedBox(width: 4),
                  Container(
                    key: _wkDatePaymentKey,
                    child: Image.asset(ImageUtils.infoIcon, width: 14, height: 14),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          Text('数额', style: TextStyle(fontSize: 14, color: ColorUtils.colorNoteT2)),
        ],
      ),
    );
  }

  Widget _buildRecordRow({
    required String date,
    required int? status,
    required String direction,
    required String txHash,
    required String amount,
    required String currency,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Text(date, style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1), maxLines: 1),
          SizedBox(width: 30.w,),
          statusConvertForWidget(status, direction,txHash),
          SizedBox(width: 16.w,),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: RichText(
                maxLines: 1,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: amount,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: ColorUtils.colorTitleOne),
                    ),
                    TextSpan(
                      text: ' $currency',
                      style: const TextStyle(fontSize: 12, color: ColorUtils.color888),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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

  @override
  bool shouldRepaint(_TooltipPainter oldDelegate) {
    return arrowX != oldDelegate.arrowX;
  }
}

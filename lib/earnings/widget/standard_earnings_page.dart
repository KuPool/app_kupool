import 'dart:ui' as ui;
import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_tab_bar.dart';

class StandardEarningsPage extends StatefulWidget {
  const StandardEarningsPage({super.key});

  @override
  State<StandardEarningsPage> createState() => _StandardEarningsPageState();
}

class _StandardEarningsPageState extends State<StandardEarningsPage> with SingleTickerProviderStateMixin {
  late TabController _recordsTabController;

  @override
  void initState() {
    super.initState();
    _recordsTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _recordsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildCombinedEarningsCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ];
      },
      body: _buildRecordsSection(),
    );
  }

  Widget _buildCombinedEarningsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTitledContent(
              title: '昨日收益',
              child: Column(
                children: [
                  _buildEarningRow('158.41457662', 'DOGE', amountSize: 20, currencySize: 16),
                  const SizedBox(height: 8),
                  _buildEarningRow('1.41457662', 'LTC', amountSize: 20, currencySize: 16),
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
                        _buildEarningRow('158.41457662', 'DOGE'),
                        const SizedBox(height: 8),
                        _buildEarningRow('1.41457662', 'LTC'),
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
                        _buildEarningRow('0.00000000', 'DOGE'),
                        const SizedBox(height: 8),
                        _buildEarningRow('0.00000000', 'LTC'),
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


  Widget _buildRecordsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
              builder: (context, _) => CustomTabBar(
                controller: _recordsTabController,
                tabs: const ['收益记录', '支付记录'],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Expanded(
            child: TabBarView(
              controller: _recordsTabController,
              children: [
                _buildRecordsList(),
                _buildRecordsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    return Column(
      children: [
        _buildRecordsHeader(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 7,
            itemBuilder: (context, index) {
              final statuses = ['待支付', '已支付', '待支付', '未入账', '待支付', '待支付', '待支付'];
              final amounts = ['0.179003919', '0.179003919', '1231315.179003919', '0.179003919', '0.179003919', '0.179003919', '0.179003919'];
              final currencies = ['DOGE', 'LTC', 'DOGE', 'DOGE', 'DOGE', 'DOGE', 'DOGE'];
              return _buildRecordRow(
                date: '2025-10-27',
                status: statuses[index],
                amount: amounts[index],
                currency: currencies[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFF9F9F9),
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
    return Padding(
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
      case '已支付':
        return Colors.green;
      case '待支付':
        return ColorUtils.mainColor;
      case '未入账':
        return Colors.red;
      default:
        return ColorUtils.colorT2;
    }
  }
}

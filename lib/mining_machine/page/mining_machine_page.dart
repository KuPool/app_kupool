import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiningMachinePage extends StatefulWidget {
  const MiningMachinePage({super.key});

  @override
  State<MiningMachinePage> createState() => _MiningMachinePageState();
}

class _MiningMachinePageState extends State<MiningMachinePage> {
  int _selectedStatusIndex = 0;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w,vertical: 40),
            color: Colors.white,
          ),
          Column(
            children: [
              _buildStatusCards(),
              Expanded(child: _buildMinersTable()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCards() {
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
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusCard('59830', '全部', 0),
            _buildStatusCard('58120', '活跃', 1),
            _buildStatusCard('1400', '不活跃', 2),
            _buildStatusCard('20', '失效', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String count, String label, int index) {
    final isSelected = _selectedStatusIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 8),
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
            Text(label, style: TextStyle(fontSize: 12.sp, color:  isSelected ? ColorUtils.mainColor : ColorUtils.colorT2)),
            SizedBox(height: 4.h),
            if (isSelected)
              Container(
                width: 20.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: ColorUtils.mainColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              )
            else
              SizedBox(height: 3.h), // Keep the space to prevent layout jump
          ],
        ),
      ),
    );
  }

  Widget _buildMinersTable() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 8,right: 8),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: _buildMinerListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMinerListView() {
    const int itemCount = 20;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final isHighRejection = index == 0;
        return Column(
          children: [
            _buildMinerRow(
              name: 'DOGE/LTC_01',
              realtimeHashrate: '908.90 TH/s',
              dailyHashrate: '918.90 TH/s',
              rejectionRate: isHighRejection ? '1.00 %' : '0.01 %',
              rejectionColor: isHighRejection ? Colors.red : Colors.green,
            ),
            if (index < itemCount - 1) // Don't add divider for the last item
               Divider(height: 0.5, indent: 16, endIndent: 16,color: Colors.grey[200],),
          ],
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorUtils.widgetBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildHeaderCell('矿机名', 0, flex: 2),
          _buildHeaderCell('实时算力', 1, flex: 2, alignment: TextAlign.right),
          _buildHeaderCell('日算力', 2, flex: 2, alignment: TextAlign.right),
          _buildHeaderCell('拒绝率', 3, flex: 2, alignment: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, int index, {int flex = 1, TextAlign alignment = TextAlign.left}) {
    final isSelected = _sortColumnIndex == index;
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_sortColumnIndex == index) {
              _sortAscending = !_sortAscending;
            } else {
              _sortColumnIndex = index;
              _sortAscending = true;
            }
            // TODO: Implement actual sorting logic here
          });
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
            SizedBox(width: 2),
            Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: isSelected ? ColorUtils.mainColor : ColorUtils.colorT2,
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
            text: unit,
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
          Expanded(flex: 2, child: Text(name, textAlign: TextAlign.left,style: TextStyle(fontSize: 14, color: ColorUtils.colorT1,))),
          Expanded(flex: 2, child: _buildHashrateWidget(realtimeHashrate, alignment: TextAlign.center)),
          Expanded(flex: 2, child: _buildHashrateWidget(dailyHashrate, alignment: TextAlign.center)),
          Expanded(flex: 1, child: Text(rejectionRate, textAlign: TextAlign.right, style: TextStyle(fontSize: 14, color: rejectionColor))),
        ],
      ),
    );
  }
}

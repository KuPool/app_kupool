import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPanelPage extends StatelessWidget {
  const UserPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'doge_lt...',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            _buildInfoCard(
              icon: Icons.flash_on,
              iconColor: const Color(0xFF00D187),
              title: '算力',
              child: _buildHashrateContent(),
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              icon: Icons.storage,
              iconColor: const Color(0xFF3375E0),
              title: '矿机',
              child: _buildMinersContent(),
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              icon: Icons.monetization_on,
              iconColor: const Color(0xFFF5A623),
              title: '挖矿收益',
              child: _buildRevenueContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon, required Color iconColor, required String title, required Widget child}) {
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
              CircleAvatar(
                radius: 12.r,
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(icon, color: iconColor, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildHashrateContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDataColumn('999.98', 'GH/s', '近 15 分钟'),
        _buildDataColumn('998.98', 'GH/s', '近 24 小时'),
        _buildDataColumn('997.98', 'GH/s', '昨日结算算力'),
      ],
    );
  }

  Widget _buildMinersContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDataColumn('50000', '', '全部'),
        _buildDataColumn('48988', '', '活跃', valueColor: const Color(0xFF04AC36)),
        _buildDataColumn('1245', '', '不活跃', valueColor: const Color(0xFFFF383C)),
        _buildDataColumn('5', '', '失效', valueColor: Colors.grey),
      ],
    );
  }

  Widget _buildRevenueContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRevenueColumn('昨日收益', {'998.56898751': 'DOGE', '998.56898751': 'LTC'}),
        _buildRevenueColumn('今日已挖 (预估)', {'0.00000000': 'DOGE', '0.00000000': 'LTC'}),
      ],
    );
  }

  Widget _buildDataColumn(String value, String unit, String label, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
            SizedBox(width: 4.w),
            Text(unit, style: TextStyle(fontSize: 12, color: valueColor)),
          ],
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRevenueColumn(String label, Map<String, String> revenues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...revenues.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              Text(entry.key, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 4.w),
              Text(entry.value, style: TextStyle(fontSize: 12.sp)),
            ],
          ),
        )),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
      ],
    );
  }
}

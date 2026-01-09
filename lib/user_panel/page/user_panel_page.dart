import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../drawer/model/sub_account_mini_info_entity.dart';
import '../../drawer/page/doge_ltc_list_page.dart';
import '../widgets/chart_for_TH.dart';
import '../widgets/toggle_switch.dart';

class UserPanelPage extends ConsumerStatefulWidget {
  const UserPanelPage({super.key});

  @override
  ConsumerState<UserPanelPage> createState() => _UserPanelPageState();
}

class _UserPanelPageState extends ConsumerState<UserPanelPage> {

  SubAccountMiniInfoList? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    _selectedAccount = context.watch<DogeLtcListNotifier>().selectedAccount;

    return Scaffold(
      backgroundColor: ColorUtils.widgetBgColor,
      body: authState.when(
        data: (user) {
          if (user != null && (user.userInfo?.subaccounts ?? 0) == 0) {
            return _buildEmptyState();
          } else {
            if((_selectedAccount?.miningInfo?.activeWorkers ?? 0) > 0) {
              return _buildUserPanelContent();
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 100,left: 16.0,right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text("您需要添加矿机到矿池，然后开始挖矿",style: TextStyle(fontSize: 16.sp,color: ColorUtils.colorTitleOne),),
                    ),
                    Text(
                        '''1、电脑连接至矿机所在的局域网，获取矿机IP，登录至矿机后台。\n\n2、进入矿机配置页面，参照示例设置挖矿地址、矿工名，密码可为空，并保存配置。矿机名（worker）命名规则：子账户+英文句号+您想为矿机设置的编号。如果您的子账户为，那矿机名可以设置为 ${_selectedAccount?.name}.001\n\n3、保存配置等待生效，矿机将在5分钟内自动添加至矿池网站页面。
                  '''
                        ,style: TextStyle(fontSize: 14,color: ColorUtils.colorT1),
                    ),
                  ],
                ),
              );
            }
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('您还没有子账户', style: TextStyle(fontSize: 16, color: ColorUtils.colorNoteT1)),
          SizedBox(height: 24),
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

  Widget _buildUserPanelContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          _buildInfoCard(
            iconPath: ImageUtils.panelSl, // 替换图标
            iconColor: const Color(0xFF00D187),
            title: '算力',
            child: _buildHashrateContent(),
          ),
          SizedBox(height: 12.h),
          _buildInfoCard(
            iconPath: ImageUtils.panelKj, // 替换图标
            iconColor: const Color(0xFF3375E0),
            title: '矿机',
            child: _buildMinersContent(),
          ),
          SizedBox(height: 12.h),
          _buildInfoCard(
            iconPath: ImageUtils.panelWksy, // 替换图标
            iconColor: const Color(0xFFF5A623),
            title: '挖矿收益',
            child: _buildRevenueContent(),
          ),
          SizedBox(height: 12.h),
          _buildChartCard(),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column( // Use Column for vertical arrangement
        children: [
          Row( // First child: the header row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('算力图表', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorUtils.colorTitleOne)),
              const ToggleSwitch(),
            ],
          ),
          SizedBox(height: 8.h), // Add some space
          SizedBox(
            // height: 200.h, // Give the chart a fixed height
            child: const ChartForTHPage(), // Second child: the chart
          ),
          // SizedBox(height: 16.h),
          _buildChartLegend(),
        ],
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
            SizedBox(width: 8),
            Text('算力', style: TextStyle(fontSize: 12, color: ColorUtils.color555)),
          ],
        ),
        SizedBox(width: 24),
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
            SizedBox(width: 8),
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

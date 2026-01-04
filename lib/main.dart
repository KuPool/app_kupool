import 'package:Kupool/earnings/page/earnings_page.dart';
import 'package:Kupool/home/page/home_page.dart';
import 'package:Kupool/mining_machine/page/mining_machine_page.dart';
import 'package:Kupool/my/page/my_page.dart';
import 'package:Kupool/net/env_config.dart';
import 'package:Kupool/user_panel/page/user_panel_page.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  EnvConfig.setEnvironment(Environment.test);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Kupool',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: ColorUtils.mainColor),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const MainTabBar(),
    );
  }
}

class MainTabBar extends StatefulWidget {
  const MainTabBar({super.key});

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

// 1. 将 TickerProvider 混入到根部的 State
class _MainTabBarState extends State<MainTabBar> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController; // 2. 将 TabController 移动到这里

  final List<Widget> _pages = [
    const HomePage(),
    const UserPanelPage(),
    const MiningMachinePage(),
    const EarningsPage(),
    const MyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(), // 3. 将抽屉添加到根 Scaffold
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 11.sp,
        unselectedFontSize: 11.sp,
        selectedItemColor: ColorUtils.mainColor,
        unselectedItemColor: ColorUtils.unselectBarTextColor,
        backgroundColor: ColorUtils.bottomBarBgColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(ImageUtils.homeBottomBar, width: 28, height: 28, color: ColorUtils.unselectBarTextColor),
            activeIcon: Image.asset(ImageUtils.homeBottomBar, width: 28, height: 28, color: ColorUtils.mainColor),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImageUtils.panelBottomBar, width: 28, height: 28, color: ColorUtils.unselectBarTextColor),
            activeIcon: Image.asset(ImageUtils.panelBottomBar, width: 28, height: 28, color: ColorUtils.mainColor),
            label: '用户面板',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImageUtils.machineBottomBar, width: 28, height: 28, color: ColorUtils.unselectBarTextColor),
            activeIcon: Image.asset(ImageUtils.machineBottomBar, width: 28, height: 28, color: ColorUtils.mainColor),
            label: '矿机',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImageUtils.earnBottomBar, width: 28, height: 28, color: ColorUtils.unselectBarTextColor),
            activeIcon: Image.asset(ImageUtils.earnBottomBar, width: 28, height: 28, color: ColorUtils.mainColor),
            label: '收益',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(ImageUtils.mineBottomBar, width: 28, height: 28, color: ColorUtils.unselectBarTextColor),
            activeIcon: Image.asset(ImageUtils.mineBottomBar, width: 28, height: 28, color: ColorUtils.mainColor),
            label: '我的',
          ),
        ],
      ),
    );
  }

  // 4. 将抽屉的构建逻辑移动到这里
  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // 增大抽屉宽度
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('子账户', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: ColorUtils.mainColor,
              tabs: [
                Tab(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.pets), SizedBox(width: 4), Text('DOGE/LTC')]),
                ),
                Tab(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.currency_bitcoin), SizedBox(width: 4), Text('BTC')]),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  return _buildAccountItem(
                    name: index == 0 ? 'doge_ltc_pro' : 'sub_account_001',
                    remark: index == 0 ? '王总的主账户' : '备注名',
                    hashrate: index < 3 ? '14.25 TH/s' : '0.00 TH/s',
                    isSelected: index == 0,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem({required String name, required String remark, required String hashrate, bool isSelected = false}) {
    return Container(
      color: isSelected ? const Color(0xFFE9F0FF) : Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              Text(remark, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              Text(hashrate, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 8.w),
              if (isSelected)
                const Icon(Icons.check_circle, color: ColorUtils.mainColor, size: 20),
            ],
          )
        ],
      ),
    );
  }
}

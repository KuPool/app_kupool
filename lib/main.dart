import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus/home/page/home_page.dart';
import 'package:nexus/user_panel/page/user_panel_page.dart';
import 'package:nexus/mining_machine/page/mining_machine_page.dart';
import 'package:nexus/earnings/page/earnings_page.dart';
import 'package:nexus/my/page/my_page.dart';
import 'package:nexus/utils/color_utils.dart';
import 'package:nexus/utils/image_utils.dart';

import 'net/env_config.dart';

void main() {
  EnvConfig.setEnvironment(Environment.test);
  // 1. 将您的根组件包裹在 ProviderScope 中
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 设计稿的尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Kupool',
          debugShowCheckedModeBanner: false, // 移除右上角的Debug标签
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

class _MainTabBarState extends State<MainTabBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const UserPanelPage(),
    const MiningMachinePage(),
    const EarningsPage(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        selectedFontSize: 11.sp, // 使用.sp进行适配
        unselectedFontSize: 11.sp, // 使用.sp进行适配
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
}

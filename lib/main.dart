import 'package:Kupool/drawer/main_drawer.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/page/earnings_page.dart';
import 'package:Kupool/home/page/home_page.dart';
import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/mining_machine/page/mining_machine_page.dart';
import 'package:Kupool/my/page/my_page.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/net/env_config.dart';
import 'package:Kupool/user_panel/page/user_panel_page.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'net/navigation_service.dart';

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
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          navigatorKey: NavigationService.navigatorKey,
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

class MainTabBar extends ConsumerStatefulWidget {
  const MainTabBar({super.key});

  @override
  ConsumerState<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends ConsumerState<MainTabBar> {
  int _currentIndex = 0;
  SubAccountCoinType _selectedCoinType = SubAccountCoinType.dogeLtc;

  final List<Widget> _pages = [
    const HomePage(),
    const UserPanelPage(),
    const MiningMachinePage(),
    const EarningsPage(),
    const MyPage(),
  ];

  final List<String> _titles = [
    '',
    'doge_ltc',
    '矿机',
    '收益',
    '我的',
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DogeLtcListNotifier()),
        // You can add providers for BTC and other coins here in the future
      ],
      child: Scaffold(
        appBar: _currentIndex == 0
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: Row(
                  children: [
                    Builder(
                      builder: (context) => InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 2),
                          child: Image.asset(
                            ImageUtils.panelMenu,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _titles[_currentIndex],
                      style: TextStyle(color: ColorUtils.colorT1, fontSize: 15.sp),
                    ),
                  ],
                ),
                leadingWidth: 150.w,
              ),
        drawer: MainDrawer(
          selectedCoinType: _selectedCoinType,
          onTabChanged: (coinType) {
            setState(() {
              _selectedCoinType = coinType;
            });
          },
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != 0) {
              final user = ref.read(authNotifierProvider).value;
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
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
      ),
    );
  }
}

import 'package:Kupool/drawer/main_drawer.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/page/earnings_page.dart';
import 'package:Kupool/earnings/provider/standard_earnings_notifier.dart';
import 'package:Kupool/home/page/home_page.dart';
import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/mining_machine/page/mining_machine_page.dart';
import 'package:Kupool/mining_machine/provider/mining_machine_notifier.dart';
import 'package:Kupool/my/page/my_page.dart';
import 'package:Kupool/my/provider/user_info_notifier.dart';
import 'package:Kupool/net/auth_notifier.dart';
import 'package:Kupool/net/env_config.dart';
import 'package:Kupool/user_panel/page/user_panel_page.dart';
import 'package:Kupool/user_panel/provider/chart_notifier.dart';
import 'package:Kupool/user_panel/provider/user_panel_provider.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/logger.dart';
import 'package:Kupool/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'earnings/provider/ecological_earnings_notifier.dart';
import 'net/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DogeLtcListNotifier()),
            ChangeNotifierProvider(create: (_) => UserPanelNotifier()),
            ChangeNotifierProvider(create: (_) => ChartNotifier()),
            ChangeNotifierProvider(create: (_) => MiningMachineNotifier()),
            ChangeNotifierProvider(create: (_) => StandardEarningsNotifier()),
            ChangeNotifierProvider(create: (_) => EcologicalEarningsNotifier()),
            ChangeNotifierProvider(create: (_) => UserInfoNotifier()),
          ],
          child: MaterialApp(
            navigatorObservers: [FlutterSmartDialog.observer],
            // builder: FlutterSmartDialog.init(),
            navigatorKey: NavigationService.navigatorKey,
            title: 'KuPool',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ColorUtils.mainColor),
              useMaterial3: true,
            ),
            builder: (context, widget) {
              // 禁用系统字体大小影响
              final mediaQuery = MediaQuery.of(context);
              final newMediaQueryData = mediaQuery.copyWith(
                // 使用 textScaler (新版Flutter) 或 textScaleFactor (旧版)
                textScaler: TextScaler.linear(1.0),
              );
              // 整合 SmartDialog 的初始化
              return FlutterSmartDialog.init()(
                context,
                MediaQuery(
                  data: newMediaQueryData,
                  child: widget!,
                ),
              );
            },
            home: child,
          ),
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

class _MainTabBarState extends ConsumerState<MainTabBar> with TickerProviderStateMixin {
  int _currentIndex = 0;
  SubAccountCoinType _selectedCoinType = SubAccountCoinType.dogeLtc;
  late final TabController _earningsTabController;
  
  final Map<int, Widget> _pageCache = {};

  @override
  void initState() {
    super.initState();
    _earningsTabController = TabController(length: 2, vsync: this);
    _pageCache[0] = const HomePage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        context.read<DogeLtcListNotifier>().fetchAccounts();
      }
    });
  }

  @override
  void dispose() {
    _earningsTabController.dispose();
    super.dispose();
  }

  final List<String> _titles = [
    '',
    'doge_ltc',
    '矿机',
    '收益',
    '我的',
  ];

  Widget _getPage(int index) {
    if (!_pageCache.containsKey(index)) {
      switch (index) {
        case 1:
          _pageCache[index] = const UserPanelPage();
          break;
        case 2:
          _pageCache[index] = const MiningMachinePage();
          break;
        case 3:
          _pageCache[index] = EarningsPage(tabController: _earningsTabController);
          break;
        case 4:
          _pageCache[index] = const MyPage();
          break;
        default:
          _pageCache[index] = const HomePage();
      }
    }
    return _pageCache[index]!;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.when(data: (user){
        if (user != null) {
          context.read<DogeLtcListNotifier>().fetchAccounts();
        } else  {
          context.read<DogeLtcListNotifier>().clearData();
        }
      }, error: (err, stack){}, loading: (){});
    });

    final selectedAccountName = context.watch<DogeLtcListNotifier>().selectedAccount?.name;

    String appBarTitle;
    if (_currentIndex != 0 && selectedAccountName != null) {
      appBarTitle = selectedAccountName;
    } else {
      appBarTitle = _titles[_currentIndex];
    }

    return Scaffold(
      drawerEnableOpenDragGesture: [1, 2, 3].contains(_currentIndex),
      appBar: _currentIndex == 0 || _currentIndex == 4
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Builder(
                builder: (context) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Scaffold.of(context).openDrawer();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 2),
                          child: Image.asset(
                            ImageUtils.panelMenu,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            appBarTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: ColorUtils.colorT1, fontSize: 15.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
              leadingWidth: 120.w,
              title: _currentIndex == 3 ? _buildEarningsTabBar() : const SizedBox.shrink(),
            ),
      drawer: MainDrawer(
        selectedCoinType: _selectedCoinType,
        onTabChanged: (coinType) {
          _selectedCoinType = coinType;
          context.read<DogeLtcListNotifier>().fetchAccounts(coinType:_selectedCoinType);
        },
      ),
      body: Stack(
        children: _pageCache.keys.map((index) {
          return Offstage(
            offstage: _currentIndex != index,
            child: _pageCache[index],
          );
        }).toList(),
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
                _getPage(index);
              });
            }
          } else {
            setState(() {
              _currentIndex = index;
              _getPage(index);
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
    );
  }

  Widget _buildEarningsTabBar() {
    return CustomTabBar(
      controller: _earningsTabController,
      selectedFontSize: 16,
      unselectedFontSize: 14,
      tabs: const ['收益', '生态收益'], onTabSelected: (int p1) {
      LogPrint.i("收益-生态收益':" + "$p1");
    },
    );
  }

}

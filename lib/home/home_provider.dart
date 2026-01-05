import 'package:Kupool/home/model/home_coin_info_entity.dart';
import 'package:Kupool/home/model/home_price_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 定义一个状态类来聚合来自多个接口的数据
class HomeDataState {
  final HomeCoinInfoEntity coinInfo;
  final HomePriceEntity price;

  HomeDataState({required this.coinInfo, required this.price});
}

// 2. 创建一个 AsyncNotifier，专门负责异步获取和管理首页数据
class HomeDataNotifier extends AsyncNotifier<HomeDataState> {
  
  // build 方法在 Provider 第一次被读取时执行，负责提供初始状态
  @override
  Future<HomeDataState> build() async {
    return _fetchAllData();
  }

  /// 暴露一个公共的刷新方法，以便UI可以触发刷新
  Future<void> refresh() async {
    state = const AsyncValue.loading(); // 手动将状态设置为加载中
    state = await AsyncValue.guard(() => _fetchAllData()); // 安全地执行异步操作并更新状态
  }

  /// 私有的数据获取逻辑
  Future<HomeDataState> _fetchAllData() async {
    final apiService = ApiService();

    // 使用 Future.wait 并行请求两个接口
    final results = await Future.wait([
      apiService.get('/v1/coin_info'),
      apiService.get('/v1/price'),
    ]);

    final coinInfoData = results[0];
    final priceData = results[1];

    // 确保两个接口都成功返回数据后再构建最终状态
    if (coinInfoData != null && priceData != null) {
      final coinInfo = HomeCoinInfoEntity.fromJson(coinInfoData);
      final price = HomePriceEntity.fromJson(priceData);
      return HomeDataState(coinInfo: coinInfo, price: price);
    } else {
      // 如果任一接口失败，则抛出异常，AsyncValue.guard 会自动将其捕获并转换为 AsyncError
      throw Exception('Failed to load home data');
    }
  }
}

// 3. 创建最终的 Provider，UI将通过它来访问和监听 HomeDataNotifier
final homeDataProvider = AsyncNotifierProvider<HomeDataNotifier, HomeDataState>(() {
  return HomeDataNotifier();
});

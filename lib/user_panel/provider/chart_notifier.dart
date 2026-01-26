import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/user_panel/model/panel_chart_hashrate_entity.dart';
import 'package:flutter/material.dart';

class ChartNotifier with ChangeNotifier {
  PanelChartHashrateEntity? _chartData;
  PanelChartHashrateEntity? get chartData => _chartData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _dimension = '15m'; // Default dimension
  String get dimension => _dimension;

  Future<void> fetchChartData({
    required int subaccountId,
    required String coin,
  }) async {
    _isLoading = true;
    notifyListeners();

    final end = DateTime.now();
    final begin = _dimension == '15m'
        ? end.subtract(const Duration(hours: 18))
        : end.subtract(const Duration(days: 30));

    final params = {
      'subaccount_id': subaccountId,
      'coin': coin,
      'dimension': _dimension,
      'begin': (begin.millisecondsSinceEpoch ~/ 1000).toString(),
      'end': (end.millisecondsSinceEpoch ~/ 1000).toString(),
    };

    try {
      final response = await ApiService().get(
        '/v1/dashboard/hashrate_chart',
        queryParameters: params,
      );
      if (response != null) {
        _chartData = PanelChartHashrateEntity.fromJson(response);
      } else {
        _chartData = null;
      }
    } catch (e) {
      debugPrint('Failed to fetch chart data: $e');
      _chartData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeDimension({required int subaccountId, required String coin,String newDimension = "15m"}) {
    _dimension = newDimension;
    fetchChartData(subaccountId: subaccountId, coin: coin);
  }
}

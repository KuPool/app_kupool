import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

import '../model/subAccount_panel_entity.dart';


class UserPanelNotifier with ChangeNotifier {
  SubAccountPanelEntity? _panelData;
  SubAccountPanelEntity? get panelData => _panelData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPanelData({
    required int subaccountId,
    required String coin,
  }) async {
    _isLoading = true;
    notifyListeners();

    final params = {
      'subaccount_id': subaccountId,
      'coin': coin,
    };

    try {
      final response = await ApiService().get(
        '/v1/dashboard/info',
        queryParameters: params,
      );

      if (response != null) {
        _panelData = SubAccountPanelEntity.fromJson(response);
      } else {
        _panelData = null;
      }
    } catch (e) {
      debugPrint('Failed to fetch user panel data: $e');
      _panelData = null;
    } finally {
      _isLoading = false;

      notifyListeners();
      // await Future.microtask(() {
      //   notifyListeners();
      // });
    }
  }
}

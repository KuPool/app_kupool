import 'package:Kupool/mining_machine/model/miner_list_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

class MiningMachineNotifier with ChangeNotifier {
  MinerListEntity? _minerListEntity;
  MinerListEntity? get minerListEntity => _minerListEntity;

  List<MinerListList>? get miners => _minerListEntity?.list;
  MinerListStatistics? get statistics => _minerListEntity?.statistics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // State for sorting and filtering
  String _sortField = 'miner_name'; // Default sort field
  bool _sortAscending = true; // Default sort order
  String _activeType = 'live'; // Default status filter

  String get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  String get activeType => _activeType;

  Future<void> fetchMiners({
    required int subaccountId,
    required String coin,
  }) async {
    _isLoading = true;
    notifyListeners();

    final params = {
      'subaccount_id': subaccountId,
      'coin': coin,
      'order_field': _sortField,
      'order_type': _sortAscending ? 'asc' : 'desc',
      'active_type': _activeType,
      'page': 1,
      'page_size': 20, // Fetch more items
      'miner_name': '',
    };

    try {
      final response = await ApiService().get(
        '/v1/miner/list',
        queryParameters: params,
      );
      if (response != null) {
        _minerListEntity = MinerListEntity.fromJson(response);
      } else {
        _minerListEntity = null;
      }
    } catch (e) {
      debugPrint('Failed to fetch miners: $e');
      _minerListEntity = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeSort(String newSortField, {required int subaccountId, required String coin}) {
    if (_sortField == newSortField) {
      _sortAscending = !_sortAscending;
    } else {
      _sortField = newSortField;
      _sortAscending = true; // Default to ascending for new column
    }
    fetchMiners(subaccountId: subaccountId, coin: coin);
  }

  void changeStatusFilter(String newActiveType, {required int subaccountId, required String coin}) {
    if (_activeType != newActiveType) {
      _activeType = newActiveType;
      fetchMiners(subaccountId: subaccountId, coin: coin);
    }
  }
}

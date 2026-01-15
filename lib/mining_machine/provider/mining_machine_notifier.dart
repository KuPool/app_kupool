import 'package:Kupool/mining_machine/model/miner_list_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

class MiningMachineNotifier with ChangeNotifier {
  MinerListEntity? _minerListEntity;
  MinerListEntity? get minerListEntity => _minerListEntity;

  List<MinerListList> _miners = [];
  List<MinerListList> get miners => _miners;
  
  MinerListStatistics? get statistics => _minerListEntity?.statistics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Pagination state
  int _page = 1;
  bool _hasMore = true;
  final int _pageSize = 20; // Define page size

  // State for sorting and filtering
  String _sortField = 'miner_name'; 
  bool _sortAscending = true; 
  String _activeType = 'live'; // Default to 'live' (active)

  String get sortField => _sortField;
  bool get sortAscending => _sortAscending;
  String get activeType => _activeType;
  bool get hasMore => _hasMore;

  Future<void> fetchMiners({
    required int subaccountId,
    required String coin,
    bool isLoadMore = false,
    bool isPullToRefresh = false,
  }) async {
    if (isLoadMore && !_hasMore) return;
    if (_isLoading) return;

    if (isLoadMore) {
      _page++;
    } else {
      _page = 1;
      if (!isPullToRefresh) {
        _miners = [];
      }
    }

    _isLoading = true;
    if (!isPullToRefresh) {
      notifyListeners();
    }

    final params = <String, dynamic>{
      'subaccount_id': subaccountId,
      'coin': coin,
      'order_field': _sortField,
      'order_type': _sortAscending ? 'asc' : 'desc',
      'page': _page,
      'page_size': _pageSize,
      'miner_name': '',
    };

    // Only add active_type if it's not 'all'
    if (_activeType != 'all') {
      params['active_type'] = _activeType;
    }

    try {
      final response = await ApiService().get(
        '/v1/miner/list',
        queryParameters: params,
      );
      if (response != null) {
        _minerListEntity = MinerListEntity.fromJson(response);
        final newMiners = _minerListEntity?.list ?? [];
        if (isLoadMore) {
          _miners.addAll(newMiners);
        } else {
          _miners = newMiners;
        }
        _hasMore = _miners.length < (_minerListEntity?.total ?? 0);
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Failed to fetch miners: $e');
      _hasMore = false;
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
      _sortAscending = true; 
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

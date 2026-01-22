import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/earnings/provider/standard_earnings_notifier.dart'; // Reusing the same summary model
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

class EcologicalEarningsNotifier with ChangeNotifier {
  // --- State ---
  String _selectedCoin = 'BELLS'; // Default coin
  String get selectedCoin => _selectedCoin;

  EarningsInfoEntity? _summaryInfo;
  EarningsInfoEntity? get summaryInfo => _summaryInfo;

  List<EarningsRecordList> _earningRecords = [];
  List<EarningsRecordList> get earningRecords => _earningRecords;

  List<EarningsRecordList> _paymentRecords = [];
  List<EarningsRecordList> get paymentRecords => _paymentRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _earningPage = 1;
  bool _hasMoreEarnings = true;
  bool get hasMoreEarnings => _hasMoreEarnings;

  int _paymentPage = 1;
  bool _hasMorePayments = true;
  bool get hasMorePayments => _hasMorePayments;

  final int _pageSize = 30;
  bool _isInitialized = false;

  int selectIndex = 0;
  setSelectIndex(int index){
    if(selectIndex != index){
      selectIndex = index;
      notifyListeners();
    }
  }
  // --- Methods ---

  Future<void> initialFetch(int subaccountId) async {
    if (_isInitialized) return;
    _isInitialized = true;
    await refreshAll(subaccountId, 0);
  }

  Future<void> changeCoin(String newCoin, int subaccountId) async {
    if (_selectedCoin == newCoin) return;
    _selectedCoin = newCoin.toUpperCase();
    // Reset all data and states
    _summaryInfo = null;
    _earningRecords = [];
    _paymentRecords = [];
    _earningPage = 1;
    _paymentPage = 1;
    _hasMoreEarnings = true;
    _hasMorePayments = true;
    notifyListeners(); // Notify to show loading indicators
    await refreshAll(subaccountId, 0);
  }

  Future<void> refreshAll(int subaccountId, int currentTabIndex) async {
    _isLoading = true;
    notifyListeners();
    await Future.wait([
      _fetchSummary(subaccountId),
      fetchRecords(subaccountId: subaccountId, type: currentTabIndex, isLoadMore: false),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchSummary(int subaccountId) async {
    try {
      final response = await ApiService().get('/v1/earnings/info', queryParameters: {
        'subaccount_id': subaccountId,
        'coin': _selectedCoin.toLowerCase(),
      });
      if (response != null) {
        _summaryInfo = EarningsInfoEntity.fromJson(response);
      }
    } catch (e) {
      debugPrint('Failed to fetch eco summary for $_selectedCoin: $e');
    }
  }

  Future<void> fetchRecords({required int subaccountId, required int type, bool isLoadMore = false}) async {
    final isEarning = type == 0;
    if (isLoadMore && (isEarning ? !_hasMoreEarnings : !_hasMorePayments)) return;

    int currentPage = isEarning ? _earningPage : _paymentPage;
    if (isLoadMore) {
       isEarning ? _earningPage++ : _paymentPage++;
       currentPage++;
    } else {
       isEarning ? _earningPage = 1 : _paymentPage = 1;
       currentPage = 1;
    }

    try {
      final response = await ApiService().get('/v1/earnings/list', queryParameters: {
        'subaccount_id': subaccountId,
        'coin': _selectedCoin.toLowerCase(),
        'page': currentPage,
        'page_size': _pageSize,
        'type': type,
      });

      if (response != null) {
        final recordEntity = EarningsRecordEntity.fromJson(response);
        final newRecords = recordEntity.list ?? [];
        if (isLoadMore) {
          isEarning ? _earningRecords.addAll(newRecords) : _paymentRecords.addAll(newRecords);
        } else {
          isEarning ? _earningRecords = newRecords : _paymentRecords = newRecords;
        }

        if (isEarning) {
          _earningPage = currentPage;
          _hasMoreEarnings = _earningRecords.length < (recordEntity.total??0);
        } else {
          _paymentPage = currentPage;
          _hasMorePayments = _paymentRecords.length < (recordEntity.total??0);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch eco records for $_selectedCoin: $e');
    }
    notifyListeners();
  }
}

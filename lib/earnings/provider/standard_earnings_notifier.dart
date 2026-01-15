import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

// Model for /v1/earnings/info response
class EarningsInfoEntity {
  final String yesterdayEarnings;
  final String totalPaid;
  final String balance;

  EarningsInfoEntity.fromJson(Map<String, dynamic> json)
      : yesterdayEarnings = json['yesterday_earnings']?.toString() ?? '0.00',
        totalPaid = json['total_paid']?.toString() ?? '0.00',
        balance = json['balance']?.toString() ?? '0.00';
}

class StandardEarningsNotifier with ChangeNotifier {
  // State for summary card
  EarningsInfoEntity? _dogeInfo;
  EarningsInfoEntity? get dogeInfo => _dogeInfo;
  EarningsInfoEntity? _ltcInfo;
  EarningsInfoEntity? get ltcInfo => _ltcInfo;

  // State for lists
  List<EarningsRecordList> _earningRecords = [];
  List<EarningsRecordList> get earningRecords => _earningRecords;
  List<EarningsRecordList> _paymentRecords = [];
  List<EarningsRecordList> get paymentRecords => _paymentRecords;

  // Loading states
  bool _isSummaryLoading = false;
  bool get isSummaryLoading => _isSummaryLoading;
  bool _isRecordsLoading = false;
  bool get isRecordsLoading => _isRecordsLoading;

  // Pagination states
  int _earningPage = 1;
  bool _hasMoreEarnings = true;
  bool get hasMoreEarnings => _hasMoreEarnings;

  int _paymentPage = 1;
  bool _hasMorePayments = true;
  bool get hasMorePayments => _hasMorePayments;

  final int _pageSize = 10;

  // Lazy loading flag
  bool _isInitialized = false;

  Future<void> initialFetch(int subaccountId) async {
    // Fetch only if it has not been initialized yet.
    if (_isInitialized) return;
    _isInitialized = true;
    await refreshAll(subaccountId, 0);
  }

  Future<void> fetchSummary(int subaccountId) async {
    _isSummaryLoading = true;
    notifyListeners();
    try {
      final responses = await Future.wait([
        ApiService().get('/v1/earnings/info', queryParameters: {'subaccount_id': subaccountId, 'coin': 'doge'}),
        ApiService().get('/v1/earnings/info', queryParameters: {'subaccount_id': subaccountId, 'coin': 'ltc'}),
      ]);
      if (responses[0] != null) _dogeInfo = EarningsInfoEntity.fromJson(responses[0]);
      if (responses[1] != null) _ltcInfo = EarningsInfoEntity.fromJson(responses[1]);
    } catch (e) {
      debugPrint('Failed to fetch earnings summary: $e');
    } finally {
      _isSummaryLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecords({required int subaccountId, required int type, bool isLoadMore = false}) async {
    final bool isEarning = type == 0;
    if (isLoadMore && (isEarning ? !_hasMoreEarnings : !_hasMorePayments)) return;
    if (_isRecordsLoading) return;

    _isRecordsLoading = true;
    if (!isLoadMore) notifyListeners(); 

    int currentPage = isEarning ? _earningPage : _paymentPage;
    if (isLoadMore) {
      currentPage++;
    } else {
      currentPage = 1;
    }

    try {
      final response = await ApiService().get('/v1/earnings/list', queryParameters: {
        'subaccount_id': subaccountId,
        'coin': 'doge,ltc',
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
          _hasMoreEarnings = newRecords.length == _pageSize;
        } else {
          _paymentPage = currentPage;
          _hasMorePayments = newRecords.length == _pageSize;
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch records (type: $type): $e');
    } finally {
      _isRecordsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll(int subaccountId, int currentTabIndex) async {
    await Future.wait([
      fetchSummary(subaccountId),
      fetchRecords(subaccountId: subaccountId, type: currentTabIndex, isLoadMore: false),
    ]);
  }
}

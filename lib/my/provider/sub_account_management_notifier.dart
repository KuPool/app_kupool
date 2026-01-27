import 'package:Kupool/my/model/sub_list_with_address_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

import '../../drawer/model/sub_account_mini_info_entity.dart';

class SubAccountManagementNotifier with ChangeNotifier {
  List<SubAccountMiniInfoList> _accounts = [];
  List<SubAccountMiniInfoList> get accounts => _accounts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  int _page = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchAccounts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!_hasMore || _isLoading) return;
    } else {
      _page = 1;
      _hasMore = true;
      _hasError = false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().get('/v1/subaccount/list_with_mining_info', queryParameters: {
        'page': _page,
        'page_size': _pageSize,
        'is_hidden': -1,
        'coins': 'ltc',
      });

      if (response != null) {
        final entity = SubAccountMiniInfoEntity.fromJson(response);
        final newAccounts = entity.list ?? [];

        if (isLoadMore) {
          _accounts.addAll(newAccounts);
        } else {
          _accounts = newAccounts;
        }
        
        _page++;
        _hasMore = _accounts.length < (entity.total ?? 0);
        _hasError = false;
      }
    } catch (e) {
      debugPrint('Failed to fetch sub-accounts: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchAccounts(isLoadMore: false);
  }

  Future<String?> updateRemark(String remark,int accountId) async {
    try {
      final response = await ApiService().post('/v1/subaccount/update_remark', data: {
        "subaccount_id": accountId,
        "remark": remark
      });
      if (response != null) {
        final entity = SubAccountMiniInfoList.fromJson(response);
        final index = accounts.indexWhere((account) => account.id == accountId);
        if (index != -1) {
          // 2. 更新该账户的 remark 字段
          accounts[index].remark = entity.remark;
          // 3. 通知 UI 刷新！
          notifyListeners();
        }
        return entity.remark;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> updateCoin(String coin,int accountId) async {
    try {
      final response = await ApiService().post('/v1/subaccount/default_coin', data: {
        "subaccount_id": accountId,
        "default_coin": coin
      });
      // if (response != null) {}
      final index = accounts.indexWhere((account) => account.id == accountId);
      if (index != -1) {
        accounts[index].defaultCoin = coin;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
    return false;
  }
}

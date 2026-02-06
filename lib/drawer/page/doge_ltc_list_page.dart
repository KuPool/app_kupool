import 'dart:async';

import 'package:Kupool/drawer/main_drawer.dart';
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/utils/base_data.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DogeLtcListNotifier with ChangeNotifier {
  List<SubAccountMiniInfoList>? _accounts;
  List<SubAccountMiniInfoList>? get accounts => _accounts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SubAccountMiniInfoList? _selectedAccount;
  SubAccountMiniInfoList? get selectedAccount => _selectedAccount;

  SubAccountCoinType? _currentCoinType;
  String currentCoinType() {
    return  _currentCoinType == SubAccountCoinType.dogeLtc ? "ltc" : "btc";
  }

  Timer? _pollingTimer;

  DogeLtcListNotifier() {
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_accounts != null) {
        LogPrint.i("自动获取账号数据");
        refreshAccountsPeriodically();
      }
    });
  }

  Future<void> refreshAccountsPeriodically() async {
    try {
      final params = {
        'page': 1,
        'page_size': 50,
        'is_hidden': -1,
        "coin_type": currentCoinType(),
      };

      final response = await ApiService().get(
        '/v1/subaccount/list_with_mining_info',
        queryParameters: params,
      );

      if (response != null) {
        var resultModel = SubAccountMiniInfoEntity.fromJson(response);
        final newAccounts = resultModel.list;

        if (newAccounts != null) {
          final currentSelectedId = _selectedAccount?.id;
          _accounts = newAccounts;
          notifyListeners();
          //
          // SubAccountMiniInfoList? accountToSelect;
          // if (currentSelectedId != null) {
          //   accountToSelect = _accounts!.firstWhere((acc) => acc.id == currentSelectedId,);
          // }
          //
          // if (accountToSelect == null && _accounts!.isNotEmpty) {
          //   accountToSelect = _accounts!.first;
          // }
          //
          // if(accountToSelect != null) {
          //    _selectedAccount = accountToSelect;
          //    _selectedAccount?.selectCoin = currentCoinType();
          //    selectCurrentCoinType = _selectedAccount!.selectCoin;
          // } else {
          //    _selectedAccount = null;
          // }
        }
      }
    } catch (e) {
      print('Failed to periodically refresh accounts: $e');
    }
  }

  Future<void> fetchAccounts({SubAccountCoinType coinType = SubAccountCoinType.dogeLtc}) async {
    _currentCoinType = coinType;
    _isLoading = true;
    _accounts = null;
    notifyListeners();

    try {
      final params = {
        'page': 1,
        'page_size': 50,
        'is_hidden': -1,
        "coin_type": currentCoinType(),
      };

      final response = await ApiService().get(
        '/v1/subaccount/list_with_mining_info',
        queryParameters: params,
      );

      if (response != null) {
        var resultModel = SubAccountMiniInfoEntity.fromJson(response);
        _accounts = resultModel.list;
        if (_accounts != null && _accounts!.isNotEmpty) {
          selectAccount(_accounts!.first);
        }
      } else {
        _accounts = [];
      }

    } catch (e) {
      print('Failed to fetch accounts: $e');
      _accounts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData(){
    _accounts = null;
    _selectedAccount = null;
    notifyListeners();
  }
  void selectAccount(SubAccountMiniInfoList account) {
    if (_selectedAccount?.id != account.id || selectCurrentCoinType != currentCoinType()) {
      _selectedAccount = account;
      _selectedAccount?.selectCoin = currentCoinType();
      selectCurrentCoinType = _selectedAccount!.selectCoin;
      notifyListeners();
    }
  }
}

class DogeLtcListPage extends StatefulWidget {
  final SubAccountCoinType coinType;
  const DogeLtcListPage({super.key, required this.coinType});

  @override
  State<DogeLtcListPage> createState() => _DogeLtcListPageState();
}

class _DogeLtcListPageState extends State<DogeLtcListPage> {

  @override
  Widget build(BuildContext context) {
    final listNotifier = context.watch<DogeLtcListNotifier>();

    if (listNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
    }

    final accounts = listNotifier.accounts;
    if (accounts == null || accounts.isEmpty) {
      return const Center(child: Text('没有子账户'));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final item = accounts[index];
        final hashrate = '${item.miningInfo?.hashrate ?? '0.00'}H/s'.trim();

        return Column(
          children: [
            InkWell(
              onTap: () {
                context.read<DogeLtcListNotifier>().selectAccount(item);
                Navigator.pop(context);
              },
              child: _buildAccountItem(
                name: item.name ?? '',
                remark: item.remark ?? '',
                hashrate: hashrate,
                isSelected: item.id == listNotifier.selectedAccount?.id,
              ),
            ),
            if (index < accounts.length - 1)
              Divider(
                height: 0.5,
                indent: 16.w,
                endIndent: 16.w,
                color: const Color(0xFFF0F0F0),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAccountItem(
      {required String name,
      required String remark,
      required String hashrate,
      bool isSelected = false}) {
    return Container(
      color: isSelected ? const Color(0xFFE9F0FF) : Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black.withAlpha(180)),
                ),
              ),
              SizedBox(height: 4.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  remark,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: ColorUtils.colorNoteT2),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      hashrate,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: ColorUtils.colorT1),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (isSelected)
                  Image.asset(ImageUtils.subAccountSelect, width: 18, height: 18)
              ],
            ),
          )
        ],
      ),
    );
  }
}

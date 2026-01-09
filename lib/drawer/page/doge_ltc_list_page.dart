import 'package:Kupool/drawer/main_drawer.dart';
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
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

  // Keep track of which coin type the data belongs to
  SubAccountCoinType? _currentCoinType;

  Future<void> fetchAccounts(SubAccountCoinType coinType) async {
    // If the data for the current coinType is already loaded, do nothing.
    if (_currentCoinType == coinType && _accounts != null) {
      return;
    }
    _currentCoinType = coinType;
    _isLoading = true;
    notifyListeners();

    final params = {
      'page': 1,
      'page_size': 50,
      'is_hidden': -1,
      // 'coin_type': _currentCoinType, 待后台开发，先预留
    };
    final response = await ApiService().get(
      '/v1/subaccount/list_with_mining_info',
      queryParameters: params,
    );

    if (response != null) {
      var resultModel = SubAccountMiniInfoEntity.fromJson(response);
      _accounts = resultModel.list;
      if (_accounts != null && _accounts!.isNotEmpty) {
        _selectedAccount = _accounts!.first;
      }
    } else {
      _accounts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectAccount(SubAccountMiniInfoList account) {
    if (_selectedAccount != account) {
      _selectedAccount = account;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DogeLtcListNotifier>().fetchAccounts(widget.coinType);
    });
  }

  @override
  void didUpdateWidget(covariant DogeLtcListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinType != widget.coinType) {
      // When the coinType changes, fetch new data.
      context.read<DogeLtcListNotifier>().fetchAccounts(widget.coinType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listNotifier = context.watch<DogeLtcListNotifier>();

    if (listNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
        final hashrate = '${item.miningInfo?.earn ?? '0.00'} H/s'.trim();

        return Column(
          children: [
            InkWell(
              onTap: () {
                context.read<DogeLtcListNotifier>().selectAccount(item);
              },
              child: _buildAccountItem(
                name: item.name ?? '',
                remark: item.remark ?? '',
                hashrate: hashrate,
                isSelected: item == listNotifier.selectedAccount,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black.withAlpha(180))),
              SizedBox(height: 4.h),
              Text(remark, style: TextStyle(fontSize: 14, color: ColorUtils.colorNoteT2)),
            ],
          ),
          Row(
            children: [
              Text(hashrate, style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT1)),
              SizedBox(width: 8.w),
              if (isSelected)
                Image.asset(ImageUtils.subAccountSelect, width: 18, height: 18)
            ],
          )
        ],
      ),
    );
  }
}

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

  SubAccountCoinType? _currentCoinType;

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
        "coin_type": _currentCoinType == SubAccountCoinType.dogeLtc ? "ltc" : "btc",
      };

      final response = await ApiService().get(
        '/v1/subaccount/list_with_mining_info',
        queryParameters: params,
      );

      // ---- 成功逻辑 ----
      if (response != null) {
        var resultModel = SubAccountMiniInfoEntity.fromJson(response);
        _accounts = resultModel.list;
        // 只有在首次加载且没有选中账户时，才设置默认选中
        if (_accounts != null && _accounts!.isNotEmpty) {
          _selectedAccount = _accounts!.first;
        }
      } else {
        _accounts = [];
      }

    } catch (e) {
      // ---- 错误处理逻辑 ----
      // ApiService 已经弹了 Toast，这里我们只需要处理好本 Notifier 的状态即可
      print('Failed to fetch accounts: $e'); // 可以在 debug 时打印错误
      _accounts = []; // 将列表设置为空，避免 UI 显示旧数据
      // 你也可以根据需求设置一个专门的错误状态变量
    } finally {
      // ---- 无论成功还是失败，最终都必须执行的逻辑 ----
      _isLoading = false;
      notifyListeners(); // 通知 UI 停止加载并刷新界面
    }
  }


  void clearData(){
    _accounts = null;
    _selectedAccount = null;
    notifyListeners();
  }
  void selectAccount(SubAccountMiniInfoList account) {
    if (_selectedAccount != account) {
      _selectedAccount = account;
      _selectedAccount?.selectCoin = _currentCoinType == SubAccountCoinType.dogeLtc ? "ltc" : "btc";
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
                // The UI only needs to update the state and close the drawer.
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
              Text(hashrate, style: TextStyle(fontSize: 15, color: ColorUtils.colorT1)),
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

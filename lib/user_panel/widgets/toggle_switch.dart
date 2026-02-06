import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/user_panel/provider/chart_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  SubAccountMiniInfoList? _previousSelectedAccount;
  @override
  Widget build(BuildContext context) {
    // 1. Watch the ChartNotifier for the current dimension
    final chartNotifier = context.watch<ChartNotifier>();
    final dimension = chartNotifier.dimension;
    var is15mSelected = dimension == '15m';

    // 2. Watch the DogeLtcListNotifier to get the selected account for the onTap callback
    final SubAccountMiniInfoList? selectedAccount =
        context.watch<DogeLtcListNotifier>().selectedAccount;

    if (selectedAccount != null && selectedAccount.id != 0 && selectedAccount != _previousSelectedAccount) {
      // 使用 addPostFrameCallback 将网络请求推迟到 build 周期之后
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // 安全地调用数据获取方法
        context.read<ChartNotifier>().changeDimension(
          newDimension: "15m",
          subaccountId: selectedAccount.id!,
          coin: selectedAccount.selectCoin,
        );
      });
      // 更新追踪变量
      _previousSelectedAccount = selectedAccount;
    }

    return GestureDetector(
      onTap: () {
        // If no account is selected, do nothing.
        if (selectedAccount == null) return;

        final newDimension = is15mSelected ? '1d' : '15m';
        context.read<ChartNotifier>().changeDimension(
              newDimension: newDimension,
              subaccountId: selectedAccount.id!,
              coin: selectedAccount.selectCoin,
            );
      },
      child: Container(
        width: 120,
        height: 36,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36 / 2),
          color: const Color(0xff767680).withAlpha(30),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment:
                  is15mSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 120 / 2,
                decoration: BoxDecoration(
                  color: ColorUtils.mainColor,
                  borderRadius: BorderRadius.circular(36 / 2),
                ),
              ),
            ),
            Row(
              children: [
                _buildToggleOption('15 分钟', is15mSelected),
                _buildToggleOption('1 天', !is15mSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String text, bool selected) {
    return Expanded(
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}

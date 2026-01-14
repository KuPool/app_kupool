import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinerConfigExample extends StatefulWidget {
  final String workerName;
  const MinerConfigExample({super.key, required this.workerName});

  @override
  State<MinerConfigExample> createState() => _MinerConfigExampleState();
}

class _MinerConfigExampleState extends State<MinerConfigExample> {
  String _selectedPoolRegion = '亚洲'; // Manages its own state

  @override
  Widget build(BuildContext context) {
    final isAsiaSelected = _selectedPoolRegion == '亚洲';
    final poolUrl = isAsiaSelected
        ? 'stratum+ssl://ltcssl-cn.kupool.com:7777'
        : 'stratum+ssl://ltcssl.kupool.com:7777';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '矿机配置示例',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              _buildRegionToggle(isAsiaSelected),
            ],
          ),
          const SizedBox(height: 16),
          _buildConfigRow('Pool URL', poolUrl, showCopyButton: true),
          const SizedBox(height: 16),
          _buildConfigRow('Worker', widget.workerName),
          const SizedBox(height: 16),
          _buildConfigRow('Password', '建议不填'),
        ],
      ),
    );
  }

  Widget _buildRegionToggle(bool isAsiaSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPoolRegion = isAsiaSelected ? '全球' : '亚洲';
        });
      },
      child: Container(
        width: 140, // Adjusted width
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff767680).withAlpha(30),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: isAsiaSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 140 / 2, // Half the width
                decoration: BoxDecoration(
                  color: ColorUtils.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Row(
              children: [
                _buildToggleOption('亚洲', isAsiaSelected),
                _buildToggleOption('全球', !isAsiaSelected),
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
            fontSize: 14,
            color: selected ? Colors.white : ColorUtils.colorT2,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConfigRow(String title, String value, {bool showCopyButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorT2)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: ColorUtils.widgetBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
                ),
              ),
              if (showCopyButton)
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ToastUtils.show("已复制");
                  },
                  child: Text(
                    '复制',
                    style: TextStyle(fontSize: 14, color: ColorUtils.mainColor),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

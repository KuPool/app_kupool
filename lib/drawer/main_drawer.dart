import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SubAccountCoinType { dogeLtc, btc }

class MainDrawer extends StatelessWidget {
  final SubAccountCoinType selectedCoinType;
  final ValueChanged<SubAccountCoinType> onTabChanged;

  const MainDrawer({
    super.key,
    required this.selectedCoinType,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('子账户', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xfff0f0f0),width: 1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCustomTabBar(),
            ),
            const SizedBox(height: 8),
            Expanded(
              // Pass the selected coin type to the single list page
              child: DogeLtcListPage(coinType: selectedCoinType),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Row(
      children: [
        _buildTabItem(
          text: 'DOGE/LTC',
          icon: _buildDogeLtcIcon(),
          isSelected: selectedCoinType == SubAccountCoinType.dogeLtc,
          onTap: () => onTabChanged(SubAccountCoinType.dogeLtc),
        ),
        const SizedBox(width: 32),
        _buildTabItem(
          text: 'BTC',
          icon: _buildBtcIcon(),
          isSelected: selectedCoinType == SubAccountCoinType.btc,
          onTap: () => onTabChanged(SubAccountCoinType.btc),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required String text,
    required Widget icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the icon and text
            children: [
              icon,
              const SizedBox(width: 2),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? ColorUtils.mainColor : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Use Padding to align the indicator with the text
          Padding(
            padding: const EdgeInsets.only(left: 42.0), // 40 for icon + 2 for spacing
            child: Container(
              height: 3,
              width: 22,
              decoration: BoxDecoration(
                color: isSelected ? ColorUtils.mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDogeLtcIcon() {
    return SizedBox(
      width: 40,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            left: 12,
            child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.transparent,
                child: Image.asset(ImageUtils.homeLtc)),
          ),
          const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(ImageUtils.homeDoge)),
        ],
      ),
    );
  }

  Widget _buildBtcIcon() {
    return SizedBox(
      width: 40,
      height: 24,
      child: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.orange,
          child: Image.asset(ImageUtils.homeBtc, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

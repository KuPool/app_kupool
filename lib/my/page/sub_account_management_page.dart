import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../utils/toast_utils.dart';

class SubAccountManagementPage extends StatelessWidget {
  const SubAccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('子账户管理', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                ImageUtils.myAccountYC,
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ColorUtils.widgetBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSubAccountRow(context, 'liupro', '内蒙古老刘放假了三等奖付了款戴假发反反复复', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '湖南老王', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'jackma', '杭州老马', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'tonyma', '深圳马', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '内蒙古老刘', '918.90 TH/s', ImageUtils.homeDoge, true),
                        _buildSubAccountRow(context, 'wakuang1', '内蒙古老刘', '0.00 TH/s', ImageUtils.homeDoge, false),
                      ],
                    ),
                  ),
                ],
              ),  
            ),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  void _showEditRemarkDialog(BuildContext context, String currentRemark) {
    final controller = TextEditingController(text: currentRemark);
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              if (focusNode.hasFocus) {
                focusNode.unfocus();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '修改备注',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: Listenable.merge([controller, focusNode]),
                          builder: (context, _) {
                            return TextField(
                              autofocus: true,
                              focusNode: focusNode,
                              controller: controller,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: ColorUtils.mainColor, width: 0.5),
                                ),
                                suffixIcon: focusNode.hasFocus && controller.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () => controller.clear(),
                                        child: Icon(Icons.cancel, color: Colors.grey.shade400, size: 16),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add update logic here
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtils.mainColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text(
                              '确认修改',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      controller.dispose();
      focusNode.dispose();
    });
  }


  void _showChangeCoinSheet(BuildContext context) {
    String selectedCoin = "DOGE/LTC";
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: ColorUtils.widgetBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
                    child: Text('选择默认币种', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          _buildCoinOption(context, 'DOGE/LTC', ImageUtils.homeDoge, selectedCoin, (value) => setState(() => selectedCoin = value)),
                          Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                          _buildCoinOption(context, 'BTC', ImageUtils.homeDoge, selectedCoin, (value) => setState(() => selectedCoin = value)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCoinOption(BuildContext context, String title, String iconPath, String selectedCoin, ValueChanged<String> onSelected) {
    bool isSelected = selectedCoin == title;
    return InkWell(
      onTap: () => onSelected(title),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
            ),
            if (isSelected)
              Icon(Icons.check, color: ColorUtils.mainColor, size: 20),
          ],
        ),
      ),
    );
  }

  void _showHideAccountSheet(BuildContext context, String accountName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 10), // Margin from bottom
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('隐藏子账户', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                  SizedBox(height: 8),
                 RichText(
                   textAlign: TextAlign.center,
                   text: TextSpan(
                   children: [
                     WidgetSpan(child: Text('确认隐藏子账户 ', style: TextStyle(fontSize: 15, color: ColorUtils.colorTitleOne))),
                     WidgetSpan(child: Text(accountName, style: TextStyle(fontSize: 15, color: ColorUtils.mainColor))),
                   ],
                 )),
                  SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0x190D5EF5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('返回', style: TextStyle(color: ColorUtils.colorNoteT2, fontSize: 14, fontWeight: FontWeight.w500)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: ColorUtils.colorRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('确认隐藏', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ToastUtils.showLoading(message: '正在隐藏...');
                              Future.delayed(const Duration(seconds: 2), () {
                                ToastUtils.dismiss();
                                ToastUtils.showSuccess('子账户已隐藏'); // 显示成功提示
                                // 在这里可以写真正的刷新页面的逻辑
                              });
                            }

                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _showAccountActionsSheet(BuildContext context, String name, String description, String iconPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: ColorUtils.widgetBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16),
                  child: Row(
                    children: [
                      Image.asset(iconPath, width: 40, height: 40),
                      SizedBox(width: 8),
                      Text(
                        name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: ColorUtils.colorT1),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        _buildSheetMenuItem('修改备注名', trailing: Expanded(child: Text(description,textAlign: TextAlign.right, style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT2))), onTap: () {
                          Navigator.of(context).pop(); // Dismiss first sheet
                          _showEditRemarkDialog(context, description);
                        }),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildSheetMenuItem('修改默认币种', trailing: Text('DOGE/LTC', style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT2)), onTap: () {
                           Navigator.of(context).pop();
                          _showChangeCoinSheet(context);
                        }),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildSheetMenuItem('隐藏子账户', onTap: () {
                           Navigator.of(context).pop();
                          _showHideAccountSheet(context, name);
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetMenuItem(String title, {Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: ColorUtils.colorT1),
              ),
            ),
            if (trailing != null) trailing,
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSubAccountRow(BuildContext context, String name, String description, String hashrate, String iconPath, bool hasDivider) {
    final parts = hashrate.split(' ');
    final value = parts.isNotEmpty ? parts[0] : '';
    final unit = parts.length > 1 ? ' ${parts.sublist(1).join(' ')}' : '';

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
      child: Column(
        children: [
          SizedBox(height: 12,),
          Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40), // Placeholder icon
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorUtils.colorTitleOne)),
                      SizedBox(height: 2),
                      Text(description, style: TextStyle(fontSize: 12, color: ColorUtils.color888),maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
                  children: <TextSpan>[
                    TextSpan(text: value),
                    TextSpan(text: unit, style: TextStyle(color: ColorUtils.color888)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  _showAccountActionsSheet(context, name, description, iconPath);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 24,right: 16),
                  child: Transform.rotate(
                    angle: math.pi/2,
                    child: Icon(Icons.more_horiz, color: ColorUtils.mainColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          if (hasDivider)
             Divider(height: 1, color: Colors.grey.shade200, indent: 40+12, endIndent: 16),

        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.mainColor, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubAccountCreatePage()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '创建子账户',
                  style: TextStyle(fontSize: 15, color: ColorUtils.mainColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

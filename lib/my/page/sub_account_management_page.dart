import 'dart:math' as math;

import 'package:Kupool/my/model/sub_list_with_address_entity.dart';
import 'package:Kupool/my/page/sub_account_create.dart';
import 'package:Kupool/my/page/sub_account_hidden_page.dart';
import 'package:Kupool/my/provider/sub_account_hidden_notifier.dart';
import 'package:Kupool/my/provider/sub_account_management_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/common_widget.dart';
import 'package:Kupool/utils/empty_check.dart';
import 'package:Kupool/utils/empty_emoji_formatter.dart';
import 'package:Kupool/utils/format_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../drawer/model/sub_account_mini_info_entity.dart';
import '../../utils/toast_utils.dart';

class SubAccountManagementPage extends StatelessWidget {
  const SubAccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubAccountManagementNotifier(),
      child: const _SubAccountManagementView(),
    );
  }
}

class _SubAccountManagementView extends StatefulWidget {
  const _SubAccountManagementView();

  @override
  State<_SubAccountManagementView> createState() => _SubAccountManagementViewState();
}

class _SubAccountManagementViewState extends State<_SubAccountManagementView> {
  late EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubAccountManagementNotifier>().fetchAccounts();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<SubAccountManagementNotifier>().refresh();
    _refreshController.finishRefresh();
    _refreshController.resetFooter();
  }

  Future<void> _onLoad() async {
    final notifier = context.read<SubAccountManagementNotifier>();
    if (notifier.hasMore) {
      await notifier.fetchAccounts(isLoadMore: true);
      _refreshController.finishLoad(notifier.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
    } else {
      _refreshController.finishLoad(IndicatorResult.noMore);
    }
  }

  @override
  Widget build(BuildContext context) {

    final notifier = context.watch<SubAccountManagementNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('子账户管理', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: ColorUtils.widgetBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (contextRoute) =>  SubAccountHiddenPage( onAccountUpdated: () {
                    hiddenSuccessCallBack();
                },)));
              },
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: EasyRefresh(
                    controller: _refreshController,
                    onLoad: _onLoad,
                    onRefresh: _onRefresh,
                    header: AppRefreshHeader(),
                    footer: AppRefreshFooter(),
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(itemBuilder: (context,index){
                        SubAccountMiniInfoList listModel = notifier.accounts[index];
                        return  Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: _buildSubAccountRow(context, "${listModel.id ?? ""}",listModel.name ?? "" , listModel.remark ?? "", '${listModel.miningInfo?.hashrate}H/s', listModel.defaultCoin ?? "ltc", true),
                        );
                      },
                        itemCount: notifier.accounts.length,
                      ),
                    ),
                  ),
                ),
                if (!notifier.isLoading)
                    _buildCreateButton(),
              ],
            ),
            if (notifier.isLoading && isEmpty(notifier.accounts))
             const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,))
            else if(!notifier.isLoading && isEmpty(notifier.accounts))
              const Center(child: Text("暂无数据"),)
          ],
        ),
      ),
    );
  }
  void hiddenSuccessCallBack(){
    _refreshController.callRefresh();
  }
  void _showEditRemarkDialog(BuildContext superContext, String currentRemark,String accountId) {
    final controller = TextEditingController(text: currentRemark);
    final focusNode = FocusNode();

    showModalBottomSheet(
      context: superContext,
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
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '修改备注',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: Listenable.merge([controller, focusNode]),
                          builder: (context, _) {
                            return TextField(
                              autofocus: true,
                              focusNode: focusNode,
                              controller: controller,
                              inputFormatters: [
                                NoSpaceEmojiFormatter()
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: ColorUtils.mainColor, width: 0.5),
                                ),
                                suffixIcon: focusNode.hasFocus && controller.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () => controller.clear(),
                                        child: const Icon(Icons.cancel, color: ColorUtils.colorInputIcon1, size: 20),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller.text.trim().isEmpty) {
                                ToastUtils.show('请输入备注');
                                return;
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                              ToastUtils.showLoading(message: '正在修改...');
                              final remark =  await superContext.read<SubAccountManagementNotifier>().updateRemark(controller.text, int.parse(accountId));
                              ToastUtils.dismiss();
                              Navigator.of(superContext).pop();
                              if(isValidString(remark)){
                                ToastUtils.showSuccess("修改成功");
                              }else{
                                ToastUtils.show("请稍后重试");
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtils.mainColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text(
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

  void _showChangeCoinSheet(BuildContext superContext,String iconType,String accountId) {
    showModalBottomSheet(
      context: superContext,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: const BoxDecoration(
                color: ColorUtils.widgetBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 12.0),
                    child: Text('选择默认币种', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                  SafeArea(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          _buildCoinOption(superContext, 'DOGE/LTC', ImageUtils.homeDoge, iconType,accountId),
                          Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                          _buildCoinOption(superContext, 'BTC', ImageUtils.homeDoge, iconType,accountId),
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

  Widget _buildCoinOption(BuildContext context, String title, String iconPath, String selectedCoin,String accountId) {
    String selectedCoinName = selectedCoin == "ltc" ? "DOGE/LTC" : "BTC";
    bool isSelected = selectedCoinName == title;
    return InkWell(
      onTap: () async {
        ToastUtils.showLoading(message: '设置中...');
        final isSuccess =  await context.read<SubAccountManagementNotifier>().updateCoin(title == "DOGE/LTC" ? "ltc" : "btc", int.parse(accountId));
        ToastUtils.dismiss();
        Navigator.of(context).pop();
        if(isSuccess){
          ToastUtils.showSuccess("设置成功");
        }else{
          ToastUtils.show("请稍后重试");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CommonWidgets.buildCoinHeaderImageWidget(iconType: title == "DOGE/LTC" ? "ltc" : "btc"),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
            ),
            if (isSelected)
              const Icon(Icons.check, color: ColorUtils.mainColor, size: 20),
          ],
        ),
      ),
    );
  }

  void _showHideAccountSheet(BuildContext superContext, String accountName,String accountId) {
    showModalBottomSheet(
      context: superContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10), // Margin from bottom
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
                            child: const Text('返回', style: TextStyle(color: ColorUtils.colorNoteT2, fontSize: 14, fontWeight: FontWeight.w500)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            child: const Text('确认隐藏', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            onPressed: () async {
                              ToastUtils.showLoading(message: '正在隐藏...');
                              final isSuccess = await superContext.read<SubAccountManagementNotifier>().updateAccountIsHidden(1, int.parse(accountId));
                              ToastUtils.dismiss();
                              Navigator.of(superContext).pop();
                              if(isSuccess){
                                ToastUtils.showSuccess("子账号已隐藏");
                              }else{
                                ToastUtils.show("请稍后重试");
                              }
                            },
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


  void _showAccountActionsSheet(BuildContext context, String name, String description, String iconType,String accountId) {
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
                      CommonWidgets.buildCoinHeaderImageWidget(iconType: iconType),
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
                          _showEditRemarkDialog(context, description,accountId);
                        }),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildSheetMenuItem('修改默认币种', trailing: Text(iconType == "ltc" ? 'DOGE/LTC' : "BTC", style: TextStyle(fontSize: 15, color: ColorUtils.colorNoteT2)), onTap: () {
                           Navigator.of(context).pop();
                          _showChangeCoinSheet(context,iconType,accountId);
                        }),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildSheetMenuItem('隐藏子账户', onTap: () {
                           Navigator.of(context).pop();
                          _showHideAccountSheet(context, name,accountId);
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

  Widget _buildSubAccountRow(BuildContext context, String accountId ,String name, String description, String hashrate, String iconType, bool hasDivider) {

    final (value, unit) = FormatUtils.splitValueAndUnit(hashrate);

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
      child: Column(
        children: [
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidgets.buildCoinHeaderImageWidget(iconType: iconType),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ColorUtils.colorTitleOne)),
                      Offstage(
                        offstage: isUnValidString(description),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(description, style: TextStyle(fontSize: 12, color: ColorUtils.color888),maxLines: 1, overflow: TextOverflow.ellipsis,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: ColorUtils.colorT1),
                  children: [
                    TextSpan(text: value),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(text: unit, style: TextStyle(color: ColorUtils.color888)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  _showAccountActionsSheet(context, name, description, iconType,accountId);
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubAccountCreatePage()));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.mainColor, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Builder(
          builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '创建子账户',
                  style: TextStyle(fontSize: 15, color: ColorUtils.mainColor, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

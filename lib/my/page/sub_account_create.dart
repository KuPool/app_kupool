import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../net/api_service.dart';

class SubAccountCreatePage extends ConsumerStatefulWidget {
  const SubAccountCreatePage({super.key});

  @override
  ConsumerState<SubAccountCreatePage> createState() => _SubAccountCreatePageState();
}

class _SubAccountCreatePageState extends ConsumerState<SubAccountCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _remarkController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  String _nameError = '';
  String _addressError = '';
  bool _isSubmitEnabled = false;

  String _selectedCoin = 'DOGE/LTC';
  String  defaultCoin = "ltc";


  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateSubmitButtonState);
    _remarkController.addListener(_updateSubmitButtonState);
    _addressController.addListener(_updateSubmitButtonState);

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _nameController.text = _nameController.text.trim();
        _validateNameOnFocusLoss();
      }
    });
    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        _addressController.text = _addressController.text.trim();
        _validateAddressOnFocusLoss();
      }
    });
  }

  void _validateNameOnFocusLoss() {
    setState(() {
      final name = _nameController.text;
      if (name.isNotEmpty &&
          (name.length < 4 ||
              name.length > 30 ||
              !RegExp(r'^[a-z0-9]+$').hasMatch(name))) {
        _nameError = '子账户名格式错误';
      } else {
        _nameError = '';
      }
    });
  }

  void _validateAddressOnFocusLoss() {
    setState(() {
      final address = _addressController.text;
      if (address.isNotEmpty && !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(address)) {
        _addressError = '地址格式错误，仅支持字母和数字';
      } else {
        _addressError = '';
      }
    });
  }

  void _updateSubmitButtonState() {
    final name = _nameController.text;
    final isNameValid = name.isNotEmpty &&
        name.length >= 4 &&
        name.length <= 30 &&
        RegExp(r'^[a-z0-9]+$').hasMatch(name);

    setState(() {
      _isSubmitEnabled = isNameValid;
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateSubmitButtonState);
    _remarkController.removeListener(_updateSubmitButtonState);
    _addressController.removeListener(_updateSubmitButtonState);
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _nameController.dispose();
    _remarkController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('创建子账户', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          label: '子账户名',
                          hint: '仅 4-30 位小写字母或数字',
                          isRequired: true,
                          errorText: _nameError),
                      const SizedBox(height: 24),
                      _buildTextField(
                          controller: _remarkController,
                          label: '子账户备注',
                          hint: '请添加子账户备注',
                          isOptional: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9\u4E00-\u9FFF_.+@#%&*\[\]{}():;!,?\-\\|]')
                            )
                          ]),
                      const SizedBox(height: 24),
                      _buildCoinSelector(),
                      const SizedBox(height: 24),
                      _buildTextField(
                          controller: _addressController,
                          focusNode: _addressFocusNode,
                          label: '设置收款地址',
                          hint: '填写收款地址',
                          isOptional: true,
                          errorText: _addressError,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              reverseDuration: Duration.zero,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: MediaQuery.of(context).viewInsets.bottom == 0
                  ? _buildSubmitButton()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    required String hint,
    bool isRequired = false,
    bool isOptional = false,
    String errorText = '',
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isRequired)
                Text('●', style: TextStyle(color: Colors.red, fontSize: 6.w)),
            if (isRequired) const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: ColorUtils.colorT1)),
            if (isOptional)
              const Text(' (选填)', style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 15,color: ColorUtils.colorT1,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: errorText.isNotEmpty ? const BorderSide(color: Colors.red, width: 1) : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: errorText.isNotEmpty ? const BorderSide(color: Colors.red, width: 1) : BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.cancel, color: ColorUtils.colorInputIcon1),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                : null,
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildCoinSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('选择默认币种', style: TextStyle(fontSize: 14, color: ColorUtils.colorT1)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showCoinSelectionSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8),
            ), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedCoin, style: const TextStyle(fontSize: 15)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCoinSelectionSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorUtils.colorEXBg2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Text('选择默认币种', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: SizedBox(
                              width: 40,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 12,
                                    child: CircleAvatar(radius: 12,backgroundColor: Colors.transparent, child: Image.asset(ImageUtils.homeLtc),),
                                  ),
                                  const CircleAvatar(radius: 12,backgroundColor: Colors.transparent, backgroundImage: AssetImage(ImageUtils.homeDoge)),
                                ],
                              ),
                            ),
                            title: const Text('DOGE/LTC'),
                            trailing: _selectedCoin == 'DOGE/LTC'
                                ? const Icon(Icons.check, color: ColorUtils.mainColor)
                                : null,
                            onTap: () {
                              setState(() => _selectedCoin = 'DOGE/LTC');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: SizedBox(
                              width: 40,
                              child: Center(child: const CircleAvatar(radius: 12,backgroundColor: Colors.transparent, backgroundImage: AssetImage(ImageUtils.homeBtc))),
                            ),
                            title: const Text('BTC'),
                            trailing: _selectedCoin == 'BTC'
                                ? const Icon(Icons.check, color: ColorUtils.mainColor)
                                : null,
                            onTap: () {
                              setState(() => _selectedCoin = 'BTC');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildSubmitButton() {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        child: InkWell(
          onTap: _isSubmitEnabled
              ? () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  var name = _nameController.text.trim();
                  var remark = _remarkController.text.trim();
                  var address = _addressController.text.trim();

                  defaultCoin = _selectedCoin == "DOGE/LTC" ? "ltc" : "btc";
                  var parm = {
                    "name": name,
                    "default_coin": defaultCoin,
                    "addresses": {
                      defaultCoin: address,
                    },
                    "remark": remark
                  };

                  SmartDialog.showLoading(msg: "创建中...");
                  await ApiService().post('/v1/subaccount/create', data: parm);
                  SmartDialog.dismiss();
                  SmartDialog.showToast("创建成功",alignment: Alignment.center,displayTime: Duration(seconds: 2),onDismiss: (){
                    Navigator.pop(context);
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 42,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _isSubmitEnabled ? ColorUtils.mainColor : ColorUtils.mainColor.withAlpha(75),
            ),
            child: Center(
              child: const Text(
                      '提交',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

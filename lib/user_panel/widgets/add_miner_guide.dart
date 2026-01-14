import 'package:Kupool/user_panel/widgets/miner_config_example.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:Kupool/utils/image_utils.dart';
import 'package:Kupool/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddMinerGuide extends StatefulWidget {
  final String workerName;
  const AddMinerGuide({super.key, required this.workerName});

  @override
  State<AddMinerGuide> createState() => _AddMinerGuideState();
}

class _AddMinerGuideState extends State<AddMinerGuide> {
  String _selectedPoolRegion = '亚洲'; // Manages its own state

  @override
  Widget build(BuildContext context) {
    final poolUrl = _selectedPoolRegion == '亚洲'
        ? 'stratum+ssl://ltcssl-cn.kupool.com:7777'
        : 'stratum+ssl://ltcssl.kupool.com:7777';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildStepItem(
                  ImageUtils.panelLian, 
                  '01、连接矿机所在的局域网',
                  '电脑连接至矿机所在的局域网，登录矿机后台，填写您的子账户（密码建议留空），保存即可，矿机将在在一分钟内自动添加到矿池网站页面。',
                ),
                const SizedBox(height: 20),
                _buildStepItem(
                  ImageUtils.panelSet,
                  '02、配置矿机',
                  '矿机名规则为：子账户+英文句号+编号，例如，您的子账户是${widget.workerName.split('.').first}，可以设置矿机名为${widget.workerName}、${widget.workerName.split('.').first}.002，以此类推，一个矿机名对应一台矿机。',
                ),
                const SizedBox(height: 20),
                _buildStepItem(
                  ImageUtils.panelLook,
                  '03、查看算力',
                   '矿机名规则为：子账户+英文句号+编号，例如，您的子账户是${widget.workerName.split('.').first}，可以设置矿机名为${widget.workerName}、${widget.workerName.split('.').first}.002，以此类推，一个矿机名对应一台矿机。',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MinerConfigExample(workerName: widget.workerName)
        ],
      ),
    );
  }
  
  Widget _buildStepItem(String iconPath, String title, String description) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 24.r,
              height: 24.r,
            ),
            const SizedBox(width: 8,),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: ColorUtils.colorTitleOne,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8,),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: ColorUtils.colorNoteT1,
          ),
        ),
      ],
    );
  }

}

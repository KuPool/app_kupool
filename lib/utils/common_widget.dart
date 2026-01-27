import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'empty_check.dart';
import 'image_utils.dart';

class CommonWidgets{


  static Widget statusConvertForWidget(int? code, String direction,String txHash) {

    if(code == null){
      return SizedBox.shrink();
    }
    String statusStr = "";
    switch (code) {
      case 0:
        statusStr = '未入账';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: const Color(0xFFF53F3F),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case 10:
        statusStr = '已审核';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case 20:
        statusStr = '准备发款';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);


      case 21:
        statusStr = '发款中';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: ColorUtils.mainColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case 30:
        statusStr = (direction == 'i' && isUnValidString(txHash)) ? '待支付' : '已支付';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: (direction == 'i' && isUnValidString(txHash)) ? ColorUtils.mainColor : const Color(0xFF00C490),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      case -1:
        statusStr = '已取消';
        return Text(statusStr,textAlign: TextAlign.right,style:TextStyle(
          color: const Color(0xFFF53F3F),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),);

      default:
        return SizedBox.shrink();
    }
  }

  static  Widget buildCoinHeaderImageWidget({required String iconType,double width = 40,double height = 40}) {
    final coinType = iconType.toLowerCase();
    switch (coinType) {
      case "ltc":
        final icons = [ImageUtils.homeDoge, ImageUtils.homeLtc];
        return _buildCoinIcons(icons, width, height);
      case "btc":
        final icons = [ImageUtils.homeBtc];
        return _buildCoinIcons(icons,width,height);

      default:
        return SizedBox.shrink();
    }
  }

  static Widget _buildCoinIcons(List<String> icons,double width,double height) {
    if (icons.length > 1) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: (26*2 - width),
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircleAvatar(
                    radius: 26 / 2,
                    backgroundImage: AssetImage(icons[1]),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircleAvatar(
                    radius: 26 / 2,
                    backgroundImage: AssetImage(icons[0]),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircleAvatar(
              radius: 26 / 2,
              backgroundImage: AssetImage(icons.first),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      );
    }
  }


}
import 'package:flutter/material.dart';

import 'image_utils.dart';

class CommonWidgets{

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
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'image_utils.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  // static void show(
  //   String msg, {
  //   Toast toastLength = Toast.LENGTH_SHORT,
  //   int timeInSecForIosWeb = 2,
  //   ToastGravity gravity = ToastGravity.CENTER,
  //   Color backgroundColor = Colors.black87,
  //   Color textColor = Colors.white,
  //   double fontSize = 16.0,
  // }) {
  //   Fluttertoast.showToast(
  //     msg: msg,
  //     toastLength: toastLength,
  //     timeInSecForIosWeb: timeInSecForIosWeb,
  //     gravity: gravity,
  //     backgroundColor: backgroundColor,
  //     textColor: textColor,
  //     fontSize: fontSize,
  //   );
  // }

  /// 显示一个简单的文字 Toast,时间 ，位置可选
  static void show(String message,{Duration? displayTime,Alignment alignment = Alignment.center,VoidCallback? onDismiss}) {
    SmartDialog.showToast(message,displayTime: displayTime,alignment: alignment,onDismiss: onDismiss);
  }

  /// 显示加载中的对话框
  static void showLoading({String message = '加载中...'}) {
    SmartDialog.showLoading(msg: message);
  }

  /// 隐藏对话框
  static void dismiss() {
    SmartDialog.dismiss();
  }
  /// 显示一个居中的、带图标的成功提示
  static void showSuccess(String message) {
    SmartDialog.showToast(
      '', // toast本身的消息为空，我们用自定义的widget
      alignment: Alignment.center,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 成功图标
              Container(
                alignment: Alignment.center,
                height: 40,width: 40,
                padding: EdgeInsets.only(left: 12,right: 12,top: 11,bottom: 11),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white60, width: 1.5),
                ),
                child:
                    Image.asset(ImageUtils.selectStatusCheck,),
              ),
              const SizedBox(height: 15),
              // 提示文字
              Text(message, style:  TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }
}

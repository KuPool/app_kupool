// lib/utils/logger.dart
import 'package:flutter/foundation.dart';

class LogPrint {
  // 一个简单的静态方法，用于打印日志
  static void i(Object? message) {
    // 关键：只有在 kDebugMode 为 true (即 Debug 模式) 时才执行打印
    if (kDebugMode) {
      print(message);
    }
  }
}

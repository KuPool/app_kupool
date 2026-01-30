import 'package:flutter/services.dart';

// 大小写字母和数字，中英文标点符号，不包含汉字
class NoSpaceEmojiChineseFormatter extends FilteringTextInputFormatter {
  NoSpaceEmojiChineseFormatter()
      : super.deny(
    // 这个正则表达式使用 `unicode: true` 来正确处理复杂的 Unicode 范围，例如 Emoji。
    RegExp(
      // 这个字符集 `[...]` 匹配以下任意一种模式:
      // 1. `\s`: 匹配所有标准的空白字符（包括空格、制表符、换行符等）。
      // 2. `|`: "或" 操作符。
      // 3. 一系列 Emoji 的 Unicode 范围。这个列表覆盖了绝大多数日常使用的表情符号。
      r'[\s]|\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}|\u{1F900}-\u{1F9FF}|\u{1FA70}-\u{1FAFF}',
      unicode: true, // 关键：必须启用 unicode 模式来正确解析 `\u{...}` 格式的范围
    ),
  );
}

// 包含汉字、大小写字母和数字，中英文标点符号
class NoSpaceEmojiFormatter extends FilteringTextInputFormatter {
  /// 创建一个禁止输入空格和 Emoji 的格式化器。
  NoSpaceEmojiFormatter()
      : super.allow(
    // 这个正则表达式使用 `unicode: true` 来正确处理复杂的 Unicode 范围，例如 Emoji。
    RegExp(r'[a-zA-Z0-9\u4E00-\u9FA5!@#$%^&*(),.?":{}|<>_`~\[\];、。，；：？！（）《》]+',unicode: true),
  );
}
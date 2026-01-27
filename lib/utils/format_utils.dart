class FormatUtils {
  /// Formats a hashrate string to a number with two decimal places.
  ///
  /// Returns '0.00' if the input is null, empty, or cannot be parsed as a double.
  static String formatHashrate(String? hashrate) {
    if (hashrate == null || hashrate.isEmpty) {
      return '0.00';
    }
    final double? value = double.tryParse(hashrate);
    if (value == null) {
      return '0.00';
    }
    return value.toStringAsFixed(2);
  }

  /// e.g., "756.98MH/s" -> ("756.98", "MH/s")
  /// e.g., "123" -> ("123", "")
  static (String, String) splitValueAndUnit(String input) {
    if (input.isEmpty) {
      return ('', '');
    }
    // 正则表达式：匹配开头部分的数字（可以包含小数点）
    final RegExp regExp = RegExp(r'^[0-9.]+');
    final Match? match = regExp.firstMatch(input);

    if (match != null) {
      final String value = match.group(0)!;
      final String unit = input.substring(value.length);
      return (value, unit);
    } else {
      // 如果开头不是数字，则将整个字符串视为单位
      return ('', input);
    }
  }


}



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
}

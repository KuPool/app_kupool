/// BusinessException
class BusinessException implements Exception {
  final int code;
  final String message;

  BusinessException(this.code, this.message);

  @override
  String toString() {
    return 'BusinessException: code=$code, message=$message';
  }
}

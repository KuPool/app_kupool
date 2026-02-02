import 'package:dio/dio.dart';

import '../net/business_exception.dart';

/// Extracts a user-friendly error message from a DioException.
String getErrorMessage(DioException e) {
  String message;
  if (e.error is BusinessException) {
    // Extract message from our custom business exception
    message = (e.error as BusinessException).message;
  } else {
    // Handle other Dio errors (network, timeout, etc.)
    // You can customize these messages as needed.
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.badResponse:
        message = 'Bad response from server';
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error';
        break;
      default:
        message = e.message ?? 'An unknown error occurred';
    }
  }
  return message;
}

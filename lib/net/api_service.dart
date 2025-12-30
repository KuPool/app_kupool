import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../utils/toast_utils.dart';
import 'dio_client.dart';

/// A service layer that provides "safe" network requests.
/// It wraps DioClient calls with try-catch blocks to handle errors
/// gracefully by showing a toast message and returning null on failure.
class ApiService {
  // Singleton pattern for easy access
  static final ApiService _instance = ApiService._internal();
  factory ApiService() {
    return _instance;
  }
  ApiService._internal();

  final DioClient _dioClient = DioClient();

  /// Performs a POST request with centralized error handling.
  /// On success, returns the response data.
  /// On failure, shows a toast and returns null.
  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dioClient.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final message = getErrorMessage(e);
      ToastUtils.show(message);
      return null;
    }
  }

  /// Performs a GET request with centralized error handling.
  /// On success, returns the response data.
  /// On failure, shows a toast and returns null.
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dioClient.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      final message = getErrorMessage(e);
      ToastUtils.show(message);
      return null;
    }
  }
}

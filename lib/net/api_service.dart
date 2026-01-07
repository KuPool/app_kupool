import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../utils/toast_utils.dart';
import 'dio_client.dart';

/// A service layer that provides "safe" network requests.
/// It wraps DioClient calls with try-catch blocks to handle errors
/// gracefully by showing a toast message and re-throwing the exception.
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
  /// On failure, shows a toast and re-throws the exception.
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
      rethrow; // Re-throw the exception to be caught by the caller (e.g., Riverpod Notifier)
    }
  }

  /// Performs a GET request with centralized error handling.
  /// On success, returns the response data.
  /// On failure, shows a toast and re-throws the exception.
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
      rethrow; // Re-throw the exception
    }
  }
  
  Future<bool> createSubAccount(Map<String, dynamic> parm) async {
    try {
      await post('/v1/subaccount/create', data: parm);
      return true;
    } catch (_) {
      return false;
    }
  }
}

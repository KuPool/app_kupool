import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Kupool/json_serializable_model/login_model_entity.dart';
import 'package:Kupool/login/page/login_page.dart';
import 'package:Kupool/net/base_response.dart';
import 'package:Kupool/net/business_exception.dart';
import 'package:Kupool/net/env_config.dart';
import 'package:Kupool/net/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension RequestOptionsExtension on RequestOptions {
  static const String _returnRawDataKey = 'returnRawData';

  bool get returnRawData => (extra[_returnRawDataKey] as bool?) ?? false;
  set returnRawData(bool value) => extra[_returnRawDataKey] = value;
}

class DioClient {
  late final Dio _dio;

  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'X-Client-Type': 'FlutterAppKuPool',
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);

    // *** Charles 抓包代理配置 ***
    // 注意：此配置仅用于开发调试，发布时请务必移除！
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      // 设置代理
      client.findProxy = (uri) {
        // 代理到你的电脑IP和Charles端口
        return 'PROXY 192.168.110.93:8888';
      };
      // 信任Charles的自签名证书，抓取 https 请求
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ResponseInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);
  }

  Future<T> get<T>(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool returnRawData = false,
  }) async {
    return _request(
      path,
      queryParameters: queryParameters,
      options: (options ?? Options())..method = 'GET',
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      returnRawData: returnRawData,
    );
  }

  Future<T> post<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool returnRawData = false,
  }) async {
    return _request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options())..method = 'POST',
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      returnRawData: returnRawData,
    );
  }

  Future<T> _request<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool returnRawData = false,
  }) async {
    options ??= Options();
    options.extra ??= {};
    options.extra?['returnRawData'] = returnRawData;

    final response = await _dio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.data as T;
  }
}

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      BaseResponse baseResponse;
      try {
        baseResponse = BaseResponse.fromJson(response.data, (json) => json);
      } catch (e) {
        return handler.next(response); // Not a standard response, pass it through.
      }

      if (baseResponse.code == 0) {
        if (response.requestOptions.returnRawData) {
          return handler.next(response);
        } else {
          response.data = baseResponse.data ?? true;
          return handler.next(response);
        }
      } else {
        final businessException = BusinessException(baseResponse.code, baseResponse.msg);
        final error = DioException(
          requestOptions: response.requestOptions,
          error: businessException,
          // Use `unknown` to prevent retry interceptors from retrying a business logic error.
          type: DioExceptionType.unknown,
        );
        // 附加一个 "disableRetry" 标志给 RetryInterceptor
        // 这会告诉 dio-smart-retry 拦截器：这是一个业务逻辑错误，不要重试！
        error.requestOptions.extra['disableRetry'] = true;
        return handler.reject(error);
      }
    } else {
      return handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}


class AuthInterceptor extends Interceptor {
  static const String _userSessionKey = 'user_session';
  static bool _isNavigating = false;

  static void reset() {
    _isNavigating = false;
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);

    if (userJson != null) {
      try {
        final user = LoginModelEntity.fromJson(jsonDecode(userJson));
        final accessToken = user.accessToken;

        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      } catch (e) {
        debugPrint('AuthInterceptor: Failed to decode user session: $e');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (_isNavigating) {
        return; // Already handling navigation, do nothing.
      }
      _isNavigating = true;

      final navigator = NavigationService.navigatorKey.currentState;
      if (navigator != null) {
        navigator.popUntil((route) => route.isFirst);
        navigator.push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      return;
    }
    super.onError(err, handler);
  }
}

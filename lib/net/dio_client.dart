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
    // *** Charles 抓包代理配置 ***

    _dio.interceptors.addAll([
      AuthInterceptor(_dio),
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
        return handler.next(response);
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
          type: DioExceptionType.unknown,
        );
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
  final Dio _dio;
  AuthInterceptor(this._dio);

  static const String _userSessionKey = 'user_session';
  // Use a Completer as an async lock to prevent multiple refresh calls.
  static Completer<String?>? _completer;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);

    if (userJson != null) {
      try {
        final user = LoginModelEntity.fromJson(jsonDecode(userJson));

        final refreshTokenExpires = DateTime.fromMillisecondsSinceEpoch((user.refreshTokenExpiresAt ?? 0) * 1000);
        if (refreshTokenExpires.isBefore(DateTime.now())) {
           await prefs.remove(_userSessionKey);
           _navigateToLogin();
           final error = DioException(requestOptions: options, error: 'Refresh token expired. Please log in again.');
           return handler.reject(error);
        }

        if (user.accessToken != null && user.accessToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${user.accessToken}';
        }
      } catch (e) {
        debugPrint('AuthInterceptor: Failed to decode user session: $e');
        await prefs.remove(_userSessionKey);
      }
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || err.requestOptions.path == '/v1/refresh_token') {
      return handler.next(err);
    }

    if (_completer == null) {
      _completer = Completer<String?>();
      try {
        final newAccessToken = await _refreshToken();
        _completer!.complete(newAccessToken);
      } catch (e) {
        _completer!.completeError(e);
      }
    }

    try {
      final newAccessToken = await _completer!.future;
      if (newAccessToken == null) {
        // If refresh failed, reject the original request.
        return handler.reject(err);
      }

      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch(e) {
      return handler.next(e);
    } finally {
       if (_completer?.isCompleted ?? false) {
        _completer = null;
      }
    }
  }

  Future<String?> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);
    if (userJson == null) throw Exception('No user session found.');

    final user = LoginModelEntity.fromJson(jsonDecode(userJson));
    final refreshToken = user.refreshToken;

    if (refreshToken == null || refreshToken.isEmpty) throw Exception('No refresh token available.');

    try {
      final refreshDio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
      final response = await refreshDio.post(
        '/v1/refresh_token',
        data: {'refresh_token': refreshToken},
      );
      
      BaseResponse baseResponse = BaseResponse.fromJson(response.data, (json) => json);

      if (baseResponse.code == 0) {
        print("刷了一下");
        final newTokens = LoginModelEntity.fromJson(baseResponse.data);
        await prefs.setString(_userSessionKey, jsonEncode(newTokens.toJson()));
        return newTokens.accessToken;
      } else {
        throw DioException(requestOptions: response.requestOptions, error: baseResponse.msg);
      }
    } catch (e) {
      await prefs.remove(_userSessionKey);
      _navigateToLogin();
      rethrow;
    }
  }
  
  void _navigateToLogin() {
      final navigator = NavigationService.navigatorKey.currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
        navigator.push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
  }
}

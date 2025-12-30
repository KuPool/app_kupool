import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';

import 'env_config.dart';
import 'navigation_service.dart';


class DioClient {
  late final Dio _dio;

  // 单例模式
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: EnvConfig.baseUrl, // 从环境配置中获取baseUrl
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // 添加全局的Header
      headers: {
        'X-Client-Type': 'Flutter',
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
        return 'PROXY 192.168.110.13:8888';
      };
      // 信任Charles的自签名证书，抓取 https 请求
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 添加拦截器
    _dio.interceptors.addAll([
      // 认证拦截器
      AuthInterceptor(),
      // 日志拦截器，需要放在最后，以便打印完整的请求信息
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);
  }

  // ... [get, post, put, delete 方法保持不变] ...
  /// GET 请求
  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<T> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      // 在这里你可以统一处理错误，例如抛出一个自定义的异常
      rethrow;
    }
  }

  /// POST 请求
  Future<Response<T>> post<T>(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<T> response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT 请求
  Future<Response<T>> put<T>(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<T> response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE 请求
  Future<Response<T>> delete<T>(String path,
      {data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken}) async {
    try {
      final Response<T> response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  // 1. 创建一个静态的“锁”
  static bool _isNavigating = false;

  /// 提供一个公开的静态方法，以便在用户成功登录后可以重置状态
  static void reset() {
    _isNavigating = false;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 检查是否是401错误
    if (err.response?.statusCode == 401) {
      // 2. 在执行跳转前，检查“锁”的状态
      if (_isNavigating) {
        // 如果已经在跳转过程中，则直接返回，不再处理后续的401错误
        print('AuthInterceptor: Navigation is already in progress, ignoring subsequent 401.');
        // 依然需要调用 next，但传入一个特殊的错误或不处理，让请求静默失败
        // 这里我们选择直接返回，让请求静默失败，避免上层触发不必要的UI更新
        return;
      }

      // 3. 上锁，并开始执行跳转
      _isNavigating = true;
      print('AuthInterceptor: Detected 401, locking and navigating to login page.');

      // 使用全局 navigatorKey 跳转到登录页
      NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );

      // 直接返回，中断错误处理链
      return;
    }

    // 如果不是401错误，则继续将错误传递下去
    super.onError(err, handler);
  }
}

// 我们需要一个 LoginPage 的引用
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('请先登录'),
      ),
      body: const Center(
        child: Text(
          'Token 已失效, 请重新登录',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

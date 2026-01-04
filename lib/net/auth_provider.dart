import 'package:Kupool/net/api_service.dart';
import 'package:Kupool/net/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 提供 ApiService 的单例
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// 提供 AuthRepository 的实例，它依赖于 ApiService
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // 监听apiServiceProvider，当它变化时，authRepositoryProvider会自动重建
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService);
});

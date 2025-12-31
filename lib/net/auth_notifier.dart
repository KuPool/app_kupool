import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus/json_serializable_model/login_model_entity.dart';
import 'package:nexus/net/auth_provider.dart';
import 'package:nexus/net/auth_repository.dart';


/// 认证状态的 Notifier (已升级到 AsyncNotifier)
///
/// AsyncNotifier 是 Riverpod 2.0+ 中处理异步操作和状态的推荐方式。
/// 它内置了对加载（loading）、错误（error）和数据（data）状态的完美管理。
class AuthNotifier extends AsyncNotifier<LoginModelEntity?> {
  // 1. 添加一个成员变量来持有AuthRepository
  late AuthRepository _authRepository;

  @override
  Future<LoginModelEntity?> build() async {
    // 2. 在build方法中初始化Repository
    _authRepository = ref.read(authRepositoryProvider);
    // 这个方法用于提供初始状态。我们暂时返回null，表示未登录。
    return null;
  }

  /// 执行登录操作
  Future<void> signIn(String email, String password) async {
    // 将状态设置为加载中，UI会自动更新以显示加载动画
    state = const AsyncValue.loading();

    // 使用 AsyncValue.guard 来安全地执行异步代码，它会自动处理 try/catch
    state = await AsyncValue.guard(() async {
      // 3. 直接使用成员变量，而不是在方法内部读取
      final user = await _authRepository.signIn(email, password);

      if (user != null) {
        // 登录成功
        print('登录成功，Token: ${user.accessToken}');
        return user;
      } else {
        // 登录失败（由 ApiService 弹出Toast）
        // 抛出一个异常，让 AsyncValue.guard 将 state 转为 AsyncError
        throw Exception('用户名或密码错误');
      }
    });
  }

  /// 执行登出操作
  Future<void> signOut() async {
    // 在这里执行清除token等操作
    // ...
    
    // 将状态重置为未认证
    state = const AsyncValue.data(null);
  }
}

/// 提供 AuthNotifier 的实例 (已升级到 AsyncNotifierProvider)
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, LoginModelEntity?>(() {
  return AuthNotifier();
});

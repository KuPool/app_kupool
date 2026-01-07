import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../json_serializable_model/login_model_entity.dart';
import 'auth_provider.dart';
import 'auth_repository.dart';

// 1. 定义存储用户信息的Key
const String _userSessionKey = 'user_session';
late AuthRepository _authRepository;

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, LoginModelEntity?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<LoginModelEntity?> {
  @override
  Future<LoginModelEntity?> build() async {
    _authRepository = ref.read(authRepositoryProvider);

    // 2. 首次构建时，尝试从本地恢复登录状态
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);
    if (userJson != null) {
      return LoginModelEntity.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // 登录
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signIn(email, password);
      final prefs = await SharedPreferences.getInstance();
      // 3. 登录成功后，将用户信息保存到本地
      await prefs.setString(_userSessionKey, jsonEncode(user?.toJson()));
      state = AsyncValue.data(user);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // 登出
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    // 4. 登出时，清除本地的用户信息
    await prefs.remove(_userSessionKey);
    state = const AsyncValue.data(null);
  }
}

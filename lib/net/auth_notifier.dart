import 'dart:convert';

import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/my/provider/user_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../json_serializable_model/login_model_entity.dart';
import 'auth_provider.dart';
import 'auth_repository.dart';
import 'dio_client.dart';

const String _userSessionKey = 'user_session';
late AuthRepository _authRepository;

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, LoginModelEntity?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<LoginModelEntity?> {
  @override
  Future<LoginModelEntity?> build() async {
    _authRepository = ref.read(authRepositoryProvider);

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);
    if (userJson != null) {
      return LoginModelEntity.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signIn(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userSessionKey, jsonEncode(user?.toJson()));
      state = AsyncValue.data(user);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);

    if (userJson != null) {
      final user = LoginModelEntity.fromJson(jsonDecode(userJson));

      final accessTokenExpiresAtExpires = DateTime.fromMillisecondsSinceEpoch((user.accessTokenExpiresAt ?? 0) * 1000);
      if (accessTokenExpiresAtExpires.isBefore(DateTime.now())) {
      //  兼容 token失效，可以直接退出
      }else{
        try {
          await DioClient().post('/v1/sign_out', data: {'token': user.accessToken});
        } catch (_) {

        }
      }

    }
    
    await prefs.remove(_userSessionKey);

    state = const AsyncValue.data(null);
  }
}

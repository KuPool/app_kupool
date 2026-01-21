import '../../json_serializable_model/login_model_entity.dart';
import 'package:Kupool/net/api_service.dart';
import 'package:flutter/material.dart';

class UserInfoNotifier with ChangeNotifier {
  LoginModelUserInfo? _userInfo;
  LoginModelUserInfo? get userInfo => _userInfo;

  Future<void> fetchUserInfo() async {
    try {
      final response = await ApiService().get('/v1/user_info');
      if (response != null) {
        _userInfo = LoginModelUserInfo.fromJson(response);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to fetch user info: $e');
    }
  }

  void clearUserInfo() {
    _userInfo = null;
    notifyListeners();
  }
}

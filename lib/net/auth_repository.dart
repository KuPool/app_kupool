import 'package:nexus/json_serializable_model/login_model_entity.dart';
import 'package:nexus/net/api_service.dart';

/// 认证相关的仓库层
///
/// 负责处理所有与用户认证相关的网络请求，例如登录、注册等。
class AuthRepository {
  final ApiService _apiService;

  // 通过构造函数注入ApiService，方便测试
  AuthRepository(this._apiService);

  /// 发起登录请求
  ///
  /// [email] - 用户的邮箱
  /// [password] - 用户的密码
  ///
  /// 成功时返回解析好的 [LoginModelEntity]，失败时返回 null。
  Future<LoginModelEntity?> signIn(String email, String password) async {
    final responseData = await _apiService.post(
      '/v1/sign_in',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (responseData != null) {
      return LoginModelEntity.fromJson(responseData as Map<String, dynamic>);
    }
    return null;
  }
}

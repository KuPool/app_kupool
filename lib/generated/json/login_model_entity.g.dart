import 'package:nexus/generated/json/base/json_convert_content.dart';
import 'package:nexus/json_serializable_model/login_model_entity.dart';

LoginModelEntity $LoginModelEntityFromJson(Map<String, dynamic> json) {
  final LoginModelEntity loginModelEntity = LoginModelEntity();
  final String? accessToken = jsonConvert.convert<String>(json['access_token']);
  if (accessToken != null) {
    loginModelEntity.accessToken = accessToken;
  }
  final int? accessTokenExpiresAt = jsonConvert.convert<int>(
      json['access_token_expires_at']);
  if (accessTokenExpiresAt != null) {
    loginModelEntity.accessTokenExpiresAt = accessTokenExpiresAt;
  }
  final String? refreshToken = jsonConvert.convert<String>(
      json['refresh_token']);
  if (refreshToken != null) {
    loginModelEntity.refreshToken = refreshToken;
  }
  final int? refreshTokenExpiresAt = jsonConvert.convert<int>(
      json['refresh_token_expires_at']);
  if (refreshTokenExpiresAt != null) {
    loginModelEntity.refreshTokenExpiresAt = refreshTokenExpiresAt;
  }
  final bool? twoFactorRequired = jsonConvert.convert<bool>(
      json['two_factor_required']);
  if (twoFactorRequired != null) {
    loginModelEntity.twoFactorRequired = twoFactorRequired;
  }
  final LoginModelUserInfo? userInfo = jsonConvert.convert<LoginModelUserInfo>(
      json['user_info']);
  if (userInfo != null) {
    loginModelEntity.userInfo = userInfo;
  }
  return loginModelEntity;
}

Map<String, dynamic> $LoginModelEntityToJson(LoginModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['access_token'] = entity.accessToken;
  data['access_token_expires_at'] = entity.accessTokenExpiresAt;
  data['refresh_token'] = entity.refreshToken;
  data['refresh_token_expires_at'] = entity.refreshTokenExpiresAt;
  data['two_factor_required'] = entity.twoFactorRequired;
  data['user_info'] = entity.userInfo?.toJson();
  return data;
}

extension LoginModelEntityExtension on LoginModelEntity {
  LoginModelEntity copyWith({
    String? accessToken,
    int? accessTokenExpiresAt,
    String? refreshToken,
    int? refreshTokenExpiresAt,
    bool? twoFactorRequired,
    LoginModelUserInfo? userInfo,
  }) {
    return LoginModelEntity()
      ..accessToken = accessToken ?? this.accessToken
      ..accessTokenExpiresAt = accessTokenExpiresAt ?? this.accessTokenExpiresAt
      ..refreshToken = refreshToken ?? this.refreshToken
      ..refreshTokenExpiresAt = refreshTokenExpiresAt ??
          this.refreshTokenExpiresAt
      ..twoFactorRequired = twoFactorRequired ?? this.twoFactorRequired
      ..userInfo = userInfo ?? this.userInfo;
  }
}

LoginModelUserInfo $LoginModelUserInfoFromJson(Map<String, dynamic> json) {
  final LoginModelUserInfo loginModelUserInfo = LoginModelUserInfo();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    loginModelUserInfo.id = id;
  }
  final int? kupoolId = jsonConvert.convert<int>(json['kupool_id']);
  if (kupoolId != null) {
    loginModelUserInfo.kupoolId = kupoolId;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    loginModelUserInfo.email = email;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    loginModelUserInfo.phone = phone;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    loginModelUserInfo.status = status;
  }
  final int? subaccounts = jsonConvert.convert<int>(json['subaccounts']);
  if (subaccounts != null) {
    loginModelUserInfo.subaccounts = subaccounts;
  }
  return loginModelUserInfo;
}

Map<String, dynamic> $LoginModelUserInfoToJson(LoginModelUserInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['kupool_id'] = entity.kupoolId;
  data['email'] = entity.email;
  data['phone'] = entity.phone;
  data['status'] = entity.status;
  data['subaccounts'] = entity.subaccounts;
  return data;
}

extension LoginModelUserInfoExtension on LoginModelUserInfo {
  LoginModelUserInfo copyWith({
    int? id,
    int? kupoolId,
    String? email,
    String? phone,
    int? status,
    int? subaccounts,
  }) {
    return LoginModelUserInfo()
      ..id = id ?? this.id
      ..kupoolId = kupoolId ?? this.kupoolId
      ..email = email ?? this.email
      ..phone = phone ?? this.phone
      ..status = status ?? this.status
      ..subaccounts = subaccounts ?? this.subaccounts;
  }
}
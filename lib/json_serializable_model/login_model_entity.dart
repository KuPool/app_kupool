import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/login_model_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/login_model_entity.g.dart';

@JsonSerializable()
class LoginModelEntity {
	@JSONField(name: 'access_token')
	String? accessToken;
	@JSONField(name: 'access_token_expires_at')
	int? accessTokenExpiresAt;
	@JSONField(name: 'refresh_token')
	String? refreshToken;
	@JSONField(name: 'refresh_token_expires_at')
	int? refreshTokenExpiresAt;
	@JSONField(name: 'two_factor_required')
	bool? twoFactorRequired;
	@JSONField(name: 'user_info')
	LoginModelUserInfo? userInfo;

	LoginModelEntity();

	factory LoginModelEntity.fromJson(Map<String, dynamic> json) => $LoginModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LoginModelUserInfo {
	int? id;
	@JSONField(name: 'kupool_id')
	int? kupoolId;
	String? email;
	String? phone;
	int? status;
	int? subaccounts;

	LoginModelUserInfo();

	factory LoginModelUserInfo.fromJson(Map<String, dynamic> json) => $LoginModelUserInfoFromJson(json);

	Map<String, dynamic> toJson() => $LoginModelUserInfoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
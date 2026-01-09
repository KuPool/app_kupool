import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/sub_account_mini_info_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/sub_account_mini_info_entity.g.dart';

@JsonSerializable()
class SubAccountMiniInfoEntity {
	int? total;
	int? page;
	@JSONField(name: 'page_size')
	int? pageSize;
	List<SubAccountMiniInfoList>? list;

	SubAccountMiniInfoEntity();

	factory SubAccountMiniInfoEntity.fromJson(Map<String, dynamic> json) => $SubAccountMiniInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubAccountMiniInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SubAccountMiniInfoList {
	int? id;
	int? uid;
	String? name;
  String? remark;
	@JSONField(name: 'default_coin')
	String? defaultCoin;
	@JSONField(name: 'is_hidden')
	int? isHidden;
	@JSONField(name: 'is_default')
	int? isDefault;
	@JSONField(name: 'created_at')
	String? createdAt;
	@JSONField(name: 'updated_at')
	String? updatedAt;
	@JSONField(name: 'mining_info')
	SubAccountMiniInfoListMiningInfo? miningInfo;

	SubAccountMiniInfoList();

	factory SubAccountMiniInfoList.fromJson(Map<String, dynamic> json) => $SubAccountMiniInfoListFromJson(json);

	Map<String, dynamic> toJson() => $SubAccountMiniInfoListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SubAccountMiniInfoListMiningInfo {
	String? date;
	@JSONField(name: 'subaccount_id')
	int? subaccountId;
	String? hashrate;
	@JSONField(name: 'active_workers')
	int? activeWorkers;
	@JSONField(name: 'coin_type')
	String? coinType;
	String? earn;

	SubAccountMiniInfoListMiningInfo();

	factory SubAccountMiniInfoListMiningInfo.fromJson(Map<String, dynamic> json) => $SubAccountMiniInfoListMiningInfoFromJson(json);

	Map<String, dynamic> toJson() => $SubAccountMiniInfoListMiningInfoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
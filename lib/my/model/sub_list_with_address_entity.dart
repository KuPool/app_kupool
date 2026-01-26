import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/sub_list_with_address_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/sub_list_with_address_entity.g.dart';

@JsonSerializable()
class SubListWithAddressEntity {
	int? total;
	int? page;
	@JSONField(name: 'page_size')
	int? pageSize;
	List<SubListWithAddressList>? list;

	SubListWithAddressEntity();

	factory SubListWithAddressEntity.fromJson(Map<String, dynamic> json) => $SubListWithAddressEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubListWithAddressEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SubListWithAddressList {
	int? id;
	int? uid;
	String? name;
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
	SubListWithAddressListAddresses? addresses;
	String? remark;

	SubListWithAddressList();

	factory SubListWithAddressList.fromJson(Map<String, dynamic> json) => $SubListWithAddressListFromJson(json);

	Map<String, dynamic> toJson() => $SubListWithAddressListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SubListWithAddressListAddresses {
	dynamic btc;
	dynamic doge;
	dynamic ltc;

	SubListWithAddressListAddresses();

	factory SubListWithAddressListAddresses.fromJson(Map<String, dynamic> json) => $SubListWithAddressListAddressesFromJson(json);

	Map<String, dynamic> toJson() => $SubListWithAddressListAddressesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
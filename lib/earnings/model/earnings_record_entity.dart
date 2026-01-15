import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/earnings_record_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/earnings_record_entity.g.dart';

@JsonSerializable()
class EarningsRecordEntity {
	int? total;
	int? page;
	@JSONField(name: 'page_size')
	int? pageSize;
	List<EarningsRecordList>? list;

	EarningsRecordEntity();

	factory EarningsRecordEntity.fromJson(Map<String, dynamic> json) => $EarningsRecordEntityFromJson(json);

	Map<String, dynamic> toJson() => $EarningsRecordEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class EarningsRecordList {
	int? id;
	@JSONField(name: 'bill_no')
	int? billNo;
	String? datetime;
	@JSONField(name: 'subaccount_id')
	int? subaccountId;
	String? name;
	String? direction;
	String? coin;
	String? address;
	int? type;
	String? amount;
	int? status;
	String? hashrate;
	@JSONField(name: 'hash_unit')
	String? hashUnit;
	@JSONField(name: 'fee_type')
	String? feeType;
	@JSONField(name: 'tx_hash')
	String? txHash;
	@JSONField(name: 'created_at')
	String? createdAt;
	@JSONField(name: 'updated_at')
	String? updatedAt;

	EarningsRecordList();

	factory EarningsRecordList.fromJson(Map<String, dynamic> json) => $EarningsRecordListFromJson(json);

	Map<String, dynamic> toJson() => $EarningsRecordListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
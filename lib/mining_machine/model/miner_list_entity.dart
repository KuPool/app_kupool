import 'dart:convert';

import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/miner_list_entity.g.dart';

export 'package:Kupool/generated/json/miner_list_entity.g.dart';

@JsonSerializable()
class MinerListEntity {
	int? total;
	int? page;
	@JSONField(name: 'page_size')
	int? pageSize;
	List<MinerListList>? list;
	MinerListStatistics? statistics;

	MinerListEntity();

	factory MinerListEntity.fromJson(Map<String, dynamic> json) => $MinerListEntityFromJson(json);

	Map<String, dynamic> toJson() => $MinerListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MinerListList {
	@JSONField(name: 'miner_id')
	int? minerId;
	@JSONField(name: 'subaccount_name')
	String? subaccountName;
	String? coin;
	@JSONField(name: 'miner_name')
	String? minerName;
	@JSONField(name: 'hash_15m')
	String? hash15m;
	@JSONField(name: 'hash_15m_unit')
	String? hash15mUnit;
	@JSONField(name: 'hash_24h')
	String? hash24h;
	@JSONField(name: 'hash_24h_unit')
	String? hash24hUnit;
	@JSONField(name: 'reject_rate')
	String? rejectRate;
	@JSONField(name: 'stale_rate')
	String? staleRate;
	@JSONField(name: 'last_share_time')
	String? lastShareTime;
	@JSONField(name: 'active_type')
	String? activeType;
	String? version;
	String? ip;

	MinerListList();

	factory MinerListList.fromJson(Map<String, dynamic> json) => $MinerListListFromJson(json);

	Map<String, dynamic> toJson() => $MinerListListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MinerListStatistics {
	int? total;
	int? active;
	int? inactive;
	int? dead;
	int? live;

	MinerListStatistics();

	factory MinerListStatistics.fromJson(Map<String, dynamic> json) => $MinerListStatisticsFromJson(json);

	Map<String, dynamic> toJson() => $MinerListStatisticsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/home_coin_info_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/home_coin_info_entity.g.dart';

@JsonSerializable()
class HomeCoinInfoEntity {
	HomeCoinInfoLtc? ltc;

	HomeCoinInfoEntity();

	factory HomeCoinInfoEntity.fromJson(Map<String, dynamic> json) => $HomeCoinInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $HomeCoinInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeCoinInfoLtc {
	@JSONField(name: 'pool_hash')
	String? poolHash;
	@JSONField(name: 'pool_hash_unit')
	String? poolHashUnit;
	@JSONField(name: 'miner_count')
	int? minerCount;
	@JSONField(name: 'earn_per_unit')
	String? earnPerUnit;
	@JSONField(name: 'earn_unit')
	String? earnUnit;
	@JSONField(name: 'earn_mode')
	String? earnMode;
	@JSONField(name: 'minimum_pay_amount')
	double? minimumPayAmount;
	String? difficulty;
	@JSONField(name: 'next_difficulty')
	String? nextDifficulty;
	@JSONField(name: 'next_difficulty_rate')
	String? nextDifficultyRate;
	@JSONField(name: 'next_difficulty_time')
	int? nextDifficultyTime;
	@JSONField(name: 'net_hash')
	String? netHash;
	@JSONField(name: 'mining_addresses')
	HomeCoinInfoLtcMiningAddresses? miningAddresses;
	@JSONField(name: 'merge_mining')
	List<HomeCoinInfoLtcMergeMining>? mergeMining;
	String? datetime;
	@JSONField(name: 'doge_earn_per_unit')
	String? dogeEarnPerUnit;
	@JSONField(name: 'doge_earn_unit')
	String? dogeEarnUnit;
	@JSONField(name: 'doge_earn_mode')
	String? dogeEarnMode;
	@JSONField(name: 'doge_minimum_pay_amount')
	int? dogeMinimumPayAmount;
	@JSONField(name: 'doge_difficulty')
	String? dogeDifficulty;
	@JSONField(name: 'doge_next_difficulty')
	String? dogeNextDifficulty;
	@JSONField(name: 'doge_next_difficulty_rate')
	String? dogeNextDifficultyRate;
	@JSONField(name: 'doge_next_difficulty_time')
	int? dogeNextDifficultyTime;
	@JSONField(name: 'doge_net_hash')
	String? dogeNetHash;

	HomeCoinInfoLtc();

	factory HomeCoinInfoLtc.fromJson(Map<String, dynamic> json) => $HomeCoinInfoLtcFromJson(json);

	Map<String, dynamic> toJson() => $HomeCoinInfoLtcToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeCoinInfoLtcMiningAddresses {
	String? asia;
	String? global;

	HomeCoinInfoLtcMiningAddresses();

	factory HomeCoinInfoLtcMiningAddresses.fromJson(Map<String, dynamic> json) => $HomeCoinInfoLtcMiningAddressesFromJson(json);

	Map<String, dynamic> toJson() => $HomeCoinInfoLtcMiningAddressesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeCoinInfoLtcMergeMining {
	String? name;
	String? value;
	@JSONField(name: 'value_avg')
	String? valueAvg;

	HomeCoinInfoLtcMergeMining();

	factory HomeCoinInfoLtcMergeMining.fromJson(Map<String, dynamic> json) => $HomeCoinInfoLtcMergeMiningFromJson(json);

	Map<String, dynamic> toJson() => $HomeCoinInfoLtcMergeMiningToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
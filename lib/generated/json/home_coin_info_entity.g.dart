import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/home/model/home_coin_info_entity.dart';

HomeCoinInfoEntity $HomeCoinInfoEntityFromJson(Map<String, dynamic> json) {
  final HomeCoinInfoEntity homeCoinInfoEntity = HomeCoinInfoEntity();
  final HomeCoinInfoLtc? ltc = jsonConvert.convert<HomeCoinInfoLtc>(
      json['ltc']);
  if (ltc != null) {
    homeCoinInfoEntity.ltc = ltc;
  }
  return homeCoinInfoEntity;
}

Map<String, dynamic> $HomeCoinInfoEntityToJson(HomeCoinInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['ltc'] = entity.ltc?.toJson();
  return data;
}

extension HomeCoinInfoEntityExtension on HomeCoinInfoEntity {
  HomeCoinInfoEntity copyWith({
    HomeCoinInfoLtc? ltc,
  }) {
    return HomeCoinInfoEntity()
      ..ltc = ltc ?? this.ltc;
  }
}

HomeCoinInfoLtc $HomeCoinInfoLtcFromJson(Map<String, dynamic> json) {
  final HomeCoinInfoLtc homeCoinInfoLtc = HomeCoinInfoLtc();
  final String? poolHash = jsonConvert.convert<String>(json['pool_hash']);
  if (poolHash != null) {
    homeCoinInfoLtc.poolHash = poolHash;
  }
  final String? poolHashUnit = jsonConvert.convert<String>(
      json['pool_hash_unit']);
  if (poolHashUnit != null) {
    homeCoinInfoLtc.poolHashUnit = poolHashUnit;
  }
  final int? minerCount = jsonConvert.convert<int>(json['miner_count']);
  if (minerCount != null) {
    homeCoinInfoLtc.minerCount = minerCount;
  }
  final String? earnPerUnit = jsonConvert.convert<String>(
      json['earn_per_unit']);
  if (earnPerUnit != null) {
    homeCoinInfoLtc.earnPerUnit = earnPerUnit;
  }
  final String? earnUnit = jsonConvert.convert<String>(json['earn_unit']);
  if (earnUnit != null) {
    homeCoinInfoLtc.earnUnit = earnUnit;
  }
  final String? earnMode = jsonConvert.convert<String>(json['earn_mode']);
  if (earnMode != null) {
    homeCoinInfoLtc.earnMode = earnMode;
  }
  final double? minimumPayAmount = jsonConvert.convert<double>(
      json['minimum_pay_amount']);
  if (minimumPayAmount != null) {
    homeCoinInfoLtc.minimumPayAmount = minimumPayAmount;
  }
  final String? difficulty = jsonConvert.convert<String>(json['difficulty']);
  if (difficulty != null) {
    homeCoinInfoLtc.difficulty = difficulty;
  }
  final String? nextDifficulty = jsonConvert.convert<String>(
      json['next_difficulty']);
  if (nextDifficulty != null) {
    homeCoinInfoLtc.nextDifficulty = nextDifficulty;
  }
  final String? nextDifficultyRate = jsonConvert.convert<String>(
      json['next_difficulty_rate']);
  if (nextDifficultyRate != null) {
    homeCoinInfoLtc.nextDifficultyRate = nextDifficultyRate;
  }
  final int? nextDifficultyTime = jsonConvert.convert<int>(
      json['next_difficulty_time']);
  if (nextDifficultyTime != null) {
    homeCoinInfoLtc.nextDifficultyTime = nextDifficultyTime;
  }
  final String? netHash = jsonConvert.convert<String>(json['net_hash']);
  if (netHash != null) {
    homeCoinInfoLtc.netHash = netHash;
  }
  final HomeCoinInfoLtcMiningAddresses? miningAddresses = jsonConvert.convert<
      HomeCoinInfoLtcMiningAddresses>(json['mining_addresses']);
  if (miningAddresses != null) {
    homeCoinInfoLtc.miningAddresses = miningAddresses;
  }
  final List<
      HomeCoinInfoLtcMergeMining>? mergeMining = (json['merge_mining'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<HomeCoinInfoLtcMergeMining>(
          e) as HomeCoinInfoLtcMergeMining).toList();
  if (mergeMining != null) {
    homeCoinInfoLtc.mergeMining = mergeMining;
  }
  final String? datetime = jsonConvert.convert<String>(json['datetime']);
  if (datetime != null) {
    homeCoinInfoLtc.datetime = datetime;
  }
  final String? dogeEarnPerUnit = jsonConvert.convert<String>(
      json['doge_earn_per_unit']);
  if (dogeEarnPerUnit != null) {
    homeCoinInfoLtc.dogeEarnPerUnit = dogeEarnPerUnit;
  }
  final String? dogeEarnUnit = jsonConvert.convert<String>(
      json['doge_earn_unit']);
  if (dogeEarnUnit != null) {
    homeCoinInfoLtc.dogeEarnUnit = dogeEarnUnit;
  }
  final String? dogeEarnMode = jsonConvert.convert<String>(
      json['doge_earn_mode']);
  if (dogeEarnMode != null) {
    homeCoinInfoLtc.dogeEarnMode = dogeEarnMode;
  }
  final int? dogeMinimumPayAmount = jsonConvert.convert<int>(
      json['doge_minimum_pay_amount']);
  if (dogeMinimumPayAmount != null) {
    homeCoinInfoLtc.dogeMinimumPayAmount = dogeMinimumPayAmount;
  }
  final String? dogeDifficulty = jsonConvert.convert<String>(
      json['doge_difficulty']);
  if (dogeDifficulty != null) {
    homeCoinInfoLtc.dogeDifficulty = dogeDifficulty;
  }
  final String? dogeNextDifficulty = jsonConvert.convert<String>(
      json['doge_next_difficulty']);
  if (dogeNextDifficulty != null) {
    homeCoinInfoLtc.dogeNextDifficulty = dogeNextDifficulty;
  }
  final String? dogeNextDifficultyRate = jsonConvert.convert<String>(
      json['doge_next_difficulty_rate']);
  if (dogeNextDifficultyRate != null) {
    homeCoinInfoLtc.dogeNextDifficultyRate = dogeNextDifficultyRate;
  }
  final int? dogeNextDifficultyTime = jsonConvert.convert<int>(
      json['doge_next_difficulty_time']);
  if (dogeNextDifficultyTime != null) {
    homeCoinInfoLtc.dogeNextDifficultyTime = dogeNextDifficultyTime;
  }
  final String? dogeNetHash = jsonConvert.convert<String>(
      json['doge_net_hash']);
  if (dogeNetHash != null) {
    homeCoinInfoLtc.dogeNetHash = dogeNetHash;
  }
  return homeCoinInfoLtc;
}

Map<String, dynamic> $HomeCoinInfoLtcToJson(HomeCoinInfoLtc entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['pool_hash'] = entity.poolHash;
  data['pool_hash_unit'] = entity.poolHashUnit;
  data['miner_count'] = entity.minerCount;
  data['earn_per_unit'] = entity.earnPerUnit;
  data['earn_unit'] = entity.earnUnit;
  data['earn_mode'] = entity.earnMode;
  data['minimum_pay_amount'] = entity.minimumPayAmount;
  data['difficulty'] = entity.difficulty;
  data['next_difficulty'] = entity.nextDifficulty;
  data['next_difficulty_rate'] = entity.nextDifficultyRate;
  data['next_difficulty_time'] = entity.nextDifficultyTime;
  data['net_hash'] = entity.netHash;
  data['mining_addresses'] = entity.miningAddresses?.toJson();
  data['merge_mining'] = entity.mergeMining?.map((v) => v.toJson()).toList();
  data['datetime'] = entity.datetime;
  data['doge_earn_per_unit'] = entity.dogeEarnPerUnit;
  data['doge_earn_unit'] = entity.dogeEarnUnit;
  data['doge_earn_mode'] = entity.dogeEarnMode;
  data['doge_minimum_pay_amount'] = entity.dogeMinimumPayAmount;
  data['doge_difficulty'] = entity.dogeDifficulty;
  data['doge_next_difficulty'] = entity.dogeNextDifficulty;
  data['doge_next_difficulty_rate'] = entity.dogeNextDifficultyRate;
  data['doge_next_difficulty_time'] = entity.dogeNextDifficultyTime;
  data['doge_net_hash'] = entity.dogeNetHash;
  return data;
}

extension HomeCoinInfoLtcExtension on HomeCoinInfoLtc {
  HomeCoinInfoLtc copyWith({
    String? poolHash,
    String? poolHashUnit,
    int? minerCount,
    String? earnPerUnit,
    String? earnUnit,
    String? earnMode,
    double? minimumPayAmount,
    String? difficulty,
    String? nextDifficulty,
    String? nextDifficultyRate,
    int? nextDifficultyTime,
    String? netHash,
    HomeCoinInfoLtcMiningAddresses? miningAddresses,
    List<HomeCoinInfoLtcMergeMining>? mergeMining,
    String? datetime,
    String? dogeEarnPerUnit,
    String? dogeEarnUnit,
    String? dogeEarnMode,
    int? dogeMinimumPayAmount,
    String? dogeDifficulty,
    String? dogeNextDifficulty,
    String? dogeNextDifficultyRate,
    int? dogeNextDifficultyTime,
    String? dogeNetHash,
  }) {
    return HomeCoinInfoLtc()
      ..poolHash = poolHash ?? this.poolHash
      ..poolHashUnit = poolHashUnit ?? this.poolHashUnit
      ..minerCount = minerCount ?? this.minerCount
      ..earnPerUnit = earnPerUnit ?? this.earnPerUnit
      ..earnUnit = earnUnit ?? this.earnUnit
      ..earnMode = earnMode ?? this.earnMode
      ..minimumPayAmount = minimumPayAmount ?? this.minimumPayAmount
      ..difficulty = difficulty ?? this.difficulty
      ..nextDifficulty = nextDifficulty ?? this.nextDifficulty
      ..nextDifficultyRate = nextDifficultyRate ?? this.nextDifficultyRate
      ..nextDifficultyTime = nextDifficultyTime ?? this.nextDifficultyTime
      ..netHash = netHash ?? this.netHash
      ..miningAddresses = miningAddresses ?? this.miningAddresses
      ..mergeMining = mergeMining ?? this.mergeMining
      ..datetime = datetime ?? this.datetime
      ..dogeEarnPerUnit = dogeEarnPerUnit ?? this.dogeEarnPerUnit
      ..dogeEarnUnit = dogeEarnUnit ?? this.dogeEarnUnit
      ..dogeEarnMode = dogeEarnMode ?? this.dogeEarnMode
      ..dogeMinimumPayAmount = dogeMinimumPayAmount ?? this.dogeMinimumPayAmount
      ..dogeDifficulty = dogeDifficulty ?? this.dogeDifficulty
      ..dogeNextDifficulty = dogeNextDifficulty ?? this.dogeNextDifficulty
      ..dogeNextDifficultyRate = dogeNextDifficultyRate ??
          this.dogeNextDifficultyRate
      ..dogeNextDifficultyTime = dogeNextDifficultyTime ??
          this.dogeNextDifficultyTime
      ..dogeNetHash = dogeNetHash ?? this.dogeNetHash;
  }
}

HomeCoinInfoLtcMiningAddresses $HomeCoinInfoLtcMiningAddressesFromJson(
    Map<String, dynamic> json) {
  final HomeCoinInfoLtcMiningAddresses homeCoinInfoLtcMiningAddresses = HomeCoinInfoLtcMiningAddresses();
  final String? asia = jsonConvert.convert<String>(json['asia']);
  if (asia != null) {
    homeCoinInfoLtcMiningAddresses.asia = asia;
  }
  final String? global = jsonConvert.convert<String>(json['global']);
  if (global != null) {
    homeCoinInfoLtcMiningAddresses.global = global;
  }
  return homeCoinInfoLtcMiningAddresses;
}

Map<String, dynamic> $HomeCoinInfoLtcMiningAddressesToJson(
    HomeCoinInfoLtcMiningAddresses entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['asia'] = entity.asia;
  data['global'] = entity.global;
  return data;
}

extension HomeCoinInfoLtcMiningAddressesExtension on HomeCoinInfoLtcMiningAddresses {
  HomeCoinInfoLtcMiningAddresses copyWith({
    String? asia,
    String? global,
  }) {
    return HomeCoinInfoLtcMiningAddresses()
      ..asia = asia ?? this.asia
      ..global = global ?? this.global;
  }
}

HomeCoinInfoLtcMergeMining $HomeCoinInfoLtcMergeMiningFromJson(
    Map<String, dynamic> json) {
  final HomeCoinInfoLtcMergeMining homeCoinInfoLtcMergeMining = HomeCoinInfoLtcMergeMining();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    homeCoinInfoLtcMergeMining.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    homeCoinInfoLtcMergeMining.value = value;
  }
  final String? valueAvg = jsonConvert.convert<String>(json['value_avg']);
  if (valueAvg != null) {
    homeCoinInfoLtcMergeMining.valueAvg = valueAvg;
  }
  return homeCoinInfoLtcMergeMining;
}

Map<String, dynamic> $HomeCoinInfoLtcMergeMiningToJson(
    HomeCoinInfoLtcMergeMining entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['value_avg'] = entity.valueAvg;
  return data;
}

extension HomeCoinInfoLtcMergeMiningExtension on HomeCoinInfoLtcMergeMining {
  HomeCoinInfoLtcMergeMining copyWith({
    String? name,
    String? value,
    String? valueAvg,
  }) {
    return HomeCoinInfoLtcMergeMining()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..valueAvg = valueAvg ?? this.valueAvg;
  }
}
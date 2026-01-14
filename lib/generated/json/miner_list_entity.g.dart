import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/mining_machine/model/miner_list_entity.dart';

MinerListEntity $MinerListEntityFromJson(Map<String, dynamic> json) {
  final MinerListEntity minerListEntity = MinerListEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    minerListEntity.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    minerListEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['page_size']);
  if (pageSize != null) {
    minerListEntity.pageSize = pageSize;
  }
  final List<MinerListList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<MinerListList>(e) as MinerListList)
      .toList();
  if (list != null) {
    minerListEntity.list = list;
  }
  final MinerListStatistics? statistics = jsonConvert.convert<
      MinerListStatistics>(json['statistics']);
  if (statistics != null) {
    minerListEntity.statistics = statistics;
  }
  return minerListEntity;
}

Map<String, dynamic> $MinerListEntityToJson(MinerListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['statistics'] = entity.statistics?.toJson();
  return data;
}

extension MinerListEntityExtension on MinerListEntity {
  MinerListEntity copyWith({
    int? total,
    int? page,
    int? pageSize,
    List<MinerListList>? list,
    MinerListStatistics? statistics,
  }) {
    return MinerListEntity()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..list = list ?? this.list
      ..statistics = statistics ?? this.statistics;
  }
}

MinerListList $MinerListListFromJson(Map<String, dynamic> json) {
  final MinerListList minerListList = MinerListList();
  final int? minerId = jsonConvert.convert<int>(json['miner_id']);
  if (minerId != null) {
    minerListList.minerId = minerId;
  }
  final String? subaccountName = jsonConvert.convert<String>(
      json['subaccount_name']);
  if (subaccountName != null) {
    minerListList.subaccountName = subaccountName;
  }
  final String? coin = jsonConvert.convert<String>(json['coin']);
  if (coin != null) {
    minerListList.coin = coin;
  }
  final String? minerName = jsonConvert.convert<String>(json['miner_name']);
  if (minerName != null) {
    minerListList.minerName = minerName;
  }
  final String? hash15m = jsonConvert.convert<String>(json['hash_15m']);
  if (hash15m != null) {
    minerListList.hash15m = hash15m;
  }
  final String? hash15mUnit = jsonConvert.convert<String>(
      json['hash_15m_unit']);
  if (hash15mUnit != null) {
    minerListList.hash15mUnit = hash15mUnit;
  }
  final String? hash24h = jsonConvert.convert<String>(json['hash_24h']);
  if (hash24h != null) {
    minerListList.hash24h = hash24h;
  }
  final String? hash24hUnit = jsonConvert.convert<String>(
      json['hash_24h_unit']);
  if (hash24hUnit != null) {
    minerListList.hash24hUnit = hash24hUnit;
  }
  final String? rejectRate = jsonConvert.convert<String>(json['reject_rate']);
  if (rejectRate != null) {
    minerListList.rejectRate = rejectRate;
  }
  final String? staleRate = jsonConvert.convert<String>(json['stale_rate']);
  if (staleRate != null) {
    minerListList.staleRate = staleRate;
  }
  final String? lastShareTime = jsonConvert.convert<String>(
      json['last_share_time']);
  if (lastShareTime != null) {
    minerListList.lastShareTime = lastShareTime;
  }
  final String? activeType = jsonConvert.convert<String>(json['active_type']);
  if (activeType != null) {
    minerListList.activeType = activeType;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    minerListList.version = version;
  }
  final String? ip = jsonConvert.convert<String>(json['ip']);
  if (ip != null) {
    minerListList.ip = ip;
  }
  return minerListList;
}

Map<String, dynamic> $MinerListListToJson(MinerListList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['miner_id'] = entity.minerId;
  data['subaccount_name'] = entity.subaccountName;
  data['coin'] = entity.coin;
  data['miner_name'] = entity.minerName;
  data['hash_15m'] = entity.hash15m;
  data['hash_15m_unit'] = entity.hash15mUnit;
  data['hash_24h'] = entity.hash24h;
  data['hash_24h_unit'] = entity.hash24hUnit;
  data['reject_rate'] = entity.rejectRate;
  data['stale_rate'] = entity.staleRate;
  data['last_share_time'] = entity.lastShareTime;
  data['active_type'] = entity.activeType;
  data['version'] = entity.version;
  data['ip'] = entity.ip;
  return data;
}

extension MinerListListExtension on MinerListList {
  MinerListList copyWith({
    int? minerId,
    String? subaccountName,
    String? coin,
    String? minerName,
    String? hash15m,
    String? hash15mUnit,
    String? hash24h,
    String? hash24hUnit,
    String? rejectRate,
    String? staleRate,
    String? lastShareTime,
    String? activeType,
    String? version,
    String? ip,
  }) {
    return MinerListList()
      ..minerId = minerId ?? this.minerId
      ..subaccountName = subaccountName ?? this.subaccountName
      ..coin = coin ?? this.coin
      ..minerName = minerName ?? this.minerName
      ..hash15m = hash15m ?? this.hash15m
      ..hash15mUnit = hash15mUnit ?? this.hash15mUnit
      ..hash24h = hash24h ?? this.hash24h
      ..hash24hUnit = hash24hUnit ?? this.hash24hUnit
      ..rejectRate = rejectRate ?? this.rejectRate
      ..staleRate = staleRate ?? this.staleRate
      ..lastShareTime = lastShareTime ?? this.lastShareTime
      ..activeType = activeType ?? this.activeType
      ..version = version ?? this.version
      ..ip = ip ?? this.ip;
  }
}

MinerListStatistics $MinerListStatisticsFromJson(Map<String, dynamic> json) {
  final MinerListStatistics minerListStatistics = MinerListStatistics();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    minerListStatistics.total = total;
  }
  final int? active = jsonConvert.convert<int>(json['active']);
  if (active != null) {
    minerListStatistics.active = active;
  }
  final int? inactive = jsonConvert.convert<int>(json['inactive']);
  if (inactive != null) {
    minerListStatistics.inactive = inactive;
  }
  final int? dead = jsonConvert.convert<int>(json['dead']);
  if (dead != null) {
    minerListStatistics.dead = dead;
  }
  final int? live = jsonConvert.convert<int>(json['live']);
  if (live != null) {
    minerListStatistics.live = live;
  }
  return minerListStatistics;
}

Map<String, dynamic> $MinerListStatisticsToJson(MinerListStatistics entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['active'] = entity.active;
  data['inactive'] = entity.inactive;
  data['dead'] = entity.dead;
  data['live'] = entity.live;
  return data;
}

extension MinerListStatisticsExtension on MinerListStatistics {
  MinerListStatistics copyWith({
    int? total,
    int? active,
    int? inactive,
    int? dead,
    int? live,
  }) {
    return MinerListStatistics()
      ..total = total ?? this.total
      ..active = active ?? this.active
      ..inactive = inactive ?? this.inactive
      ..dead = dead ?? this.dead
      ..live = live ?? this.live;
  }
}
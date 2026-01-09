import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/user_panel/model/subAccount_panel_entity.dart';

SubAccountPanelEntity $SubAccountPanelEntityFromJson(
    Map<String, dynamic> json) {
  final SubAccountPanelEntity subAccountPanelEntity = SubAccountPanelEntity();
  final String? realtimeHashrate = jsonConvert.convert<String>(
      json['realtime_hashrate']);
  if (realtimeHashrate != null) {
    subAccountPanelEntity.realtimeHashrate = realtimeHashrate;
  }
  final String? realtimeHashrateUnit = jsonConvert.convert<String>(
      json['realtime_hashrate_unit']);
  if (realtimeHashrateUnit != null) {
    subAccountPanelEntity.realtimeHashrateUnit = realtimeHashrateUnit;
  }
  final String? hour24Hashrate = jsonConvert.convert<String>(
      json['hour24_hashrate']);
  if (hour24Hashrate != null) {
    subAccountPanelEntity.hour24Hashrate = hour24Hashrate;
  }
  final String? hour24HashrateUnit = jsonConvert.convert<String>(
      json['hour24_hashrate_unit']);
  if (hour24HashrateUnit != null) {
    subAccountPanelEntity.hour24HashrateUnit = hour24HashrateUnit;
  }
  final int? activeMiners = jsonConvert.convert<int>(json['active_miners']);
  if (activeMiners != null) {
    subAccountPanelEntity.activeMiners = activeMiners;
  }
  final int? inactiveMiners = jsonConvert.convert<int>(json['inactive_miners']);
  if (inactiveMiners != null) {
    subAccountPanelEntity.inactiveMiners = inactiveMiners;
  }
  final int? deadMiners = jsonConvert.convert<int>(json['dead_miners']);
  if (deadMiners != null) {
    subAccountPanelEntity.deadMiners = deadMiners;
  }
  final String? yesterdayEarnings = jsonConvert.convert<String>(
      json['yesterday_earnings']);
  if (yesterdayEarnings != null) {
    subAccountPanelEntity.yesterdayEarnings = yesterdayEarnings;
  }
  final String? yesterdayEarningsDoge = jsonConvert.convert<String>(
      json['yesterday_earnings_doge']);
  if (yesterdayEarningsDoge != null) {
    subAccountPanelEntity.yesterdayEarningsDoge = yesterdayEarningsDoge;
  }
  final String? todayEstimated = jsonConvert.convert<String>(
      json['today_estimated']);
  if (todayEstimated != null) {
    subAccountPanelEntity.todayEstimated = todayEstimated;
  }
  final String? todayEstimatedDoge = jsonConvert.convert<String>(
      json['today_estimated_doge']);
  if (todayEstimatedDoge != null) {
    subAccountPanelEntity.todayEstimatedDoge = todayEstimatedDoge;
  }
  final String? yesterdayAcceptHashrate = jsonConvert.convert<String>(
      json['yesterday_accept_hashrate']);
  if (yesterdayAcceptHashrate != null) {
    subAccountPanelEntity.yesterdayAcceptHashrate = yesterdayAcceptHashrate;
  }
  final String? yesterdayAcceptHashrateUnit = jsonConvert.convert<String>(
      json['yesterday_accept_hashrate_unit']);
  if (yesterdayAcceptHashrateUnit != null) {
    subAccountPanelEntity.yesterdayAcceptHashrateUnit =
        yesterdayAcceptHashrateUnit;
  }
  return subAccountPanelEntity;
}

Map<String, dynamic> $SubAccountPanelEntityToJson(
    SubAccountPanelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['realtime_hashrate'] = entity.realtimeHashrate;
  data['realtime_hashrate_unit'] = entity.realtimeHashrateUnit;
  data['hour24_hashrate'] = entity.hour24Hashrate;
  data['hour24_hashrate_unit'] = entity.hour24HashrateUnit;
  data['active_miners'] = entity.activeMiners;
  data['inactive_miners'] = entity.inactiveMiners;
  data['dead_miners'] = entity.deadMiners;
  data['yesterday_earnings'] = entity.yesterdayEarnings;
  data['yesterday_earnings_doge'] = entity.yesterdayEarningsDoge;
  data['today_estimated'] = entity.todayEstimated;
  data['today_estimated_doge'] = entity.todayEstimatedDoge;
  data['yesterday_accept_hashrate'] = entity.yesterdayAcceptHashrate;
  data['yesterday_accept_hashrate_unit'] = entity.yesterdayAcceptHashrateUnit;
  return data;
}

extension SubAccountPanelEntityExtension on SubAccountPanelEntity {
  SubAccountPanelEntity copyWith({
    String? realtimeHashrate,
    String? realtimeHashrateUnit,
    String? hour24Hashrate,
    String? hour24HashrateUnit,
    int? activeMiners,
    int? inactiveMiners,
    int? deadMiners,
    String? yesterdayEarnings,
    String? yesterdayEarningsDoge,
    String? todayEstimated,
    String? todayEstimatedDoge,
    String? yesterdayAcceptHashrate,
    String? yesterdayAcceptHashrateUnit,
  }) {
    return SubAccountPanelEntity()
      ..realtimeHashrate = realtimeHashrate ?? this.realtimeHashrate
      ..realtimeHashrateUnit = realtimeHashrateUnit ?? this.realtimeHashrateUnit
      ..hour24Hashrate = hour24Hashrate ?? this.hour24Hashrate
      ..hour24HashrateUnit = hour24HashrateUnit ?? this.hour24HashrateUnit
      ..activeMiners = activeMiners ?? this.activeMiners
      ..inactiveMiners = inactiveMiners ?? this.inactiveMiners
      ..deadMiners = deadMiners ?? this.deadMiners
      ..yesterdayEarnings = yesterdayEarnings ?? this.yesterdayEarnings
      ..yesterdayEarningsDoge = yesterdayEarningsDoge ??
          this.yesterdayEarningsDoge
      ..todayEstimated = todayEstimated ?? this.todayEstimated
      ..todayEstimatedDoge = todayEstimatedDoge ?? this.todayEstimatedDoge
      ..yesterdayAcceptHashrate = yesterdayAcceptHashrate ??
          this.yesterdayAcceptHashrate
      ..yesterdayAcceptHashrateUnit = yesterdayAcceptHashrateUnit ??
          this.yesterdayAcceptHashrateUnit;
  }
}
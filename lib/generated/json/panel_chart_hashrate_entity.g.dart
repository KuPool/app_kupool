import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/user_panel/model/panel_chart_hashrate_entity.dart';

PanelChartHashrateEntity $PanelChartHashrateEntityFromJson(
    Map<String, dynamic> json) {
  final PanelChartHashrateEntity panelChartHashrateEntity = PanelChartHashrateEntity();
  final List<PanelChartHashrateTicks>? ticks = (json['ticks'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<PanelChartHashrateTicks>(
          e) as PanelChartHashrateTicks)
      .toList();
  if (ticks != null) {
    panelChartHashrateEntity.ticks = ticks;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    panelChartHashrateEntity.unit = unit;
  }
  return panelChartHashrateEntity;
}

Map<String, dynamic> $PanelChartHashrateEntityToJson(
    PanelChartHashrateEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['ticks'] = entity.ticks?.map((v) => v.toJson()).toList();
  data['unit'] = entity.unit;
  return data;
}

extension PanelChartHashrateEntityExtension on PanelChartHashrateEntity {
  PanelChartHashrateEntity copyWith({
    List<PanelChartHashrateTicks>? ticks,
    String? unit,
  }) {
    return PanelChartHashrateEntity()
      ..ticks = ticks ?? this.ticks
      ..unit = unit ?? this.unit;
  }
}

PanelChartHashrateTicks $PanelChartHashrateTicksFromJson(
    Map<String, dynamic> json) {
  final PanelChartHashrateTicks panelChartHashrateTicks = PanelChartHashrateTicks();
  final int? unix = jsonConvert.convert<int>(json['unix']);
  if (unix != null) {
    panelChartHashrateTicks.unix = unix;
  }
  final String? datetime = jsonConvert.convert<String>(json['datetime']);
  if (datetime != null) {
    panelChartHashrateTicks.datetime = datetime;
  }
  final String? hashrate = jsonConvert.convert<String>(json['hashrate']);
  if (hashrate != null) {
    panelChartHashrateTicks.hashrate = hashrate;
  }
  final String? rejectHashrate = jsonConvert.convert<String>(
      json['reject_hashrate']);
  if (rejectHashrate != null) {
    panelChartHashrateTicks.rejectHashrate = rejectHashrate;
  }
  final String? staleHashrate = jsonConvert.convert<String>(
      json['stale_hashrate']);
  if (staleHashrate != null) {
    panelChartHashrateTicks.staleHashrate = staleHashrate;
  }
  return panelChartHashrateTicks;
}

Map<String, dynamic> $PanelChartHashrateTicksToJson(
    PanelChartHashrateTicks entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unix'] = entity.unix;
  data['datetime'] = entity.datetime;
  data['hashrate'] = entity.hashrate;
  data['reject_hashrate'] = entity.rejectHashrate;
  data['stale_hashrate'] = entity.staleHashrate;
  return data;
}

extension PanelChartHashrateTicksExtension on PanelChartHashrateTicks {
  PanelChartHashrateTicks copyWith({
    int? unix,
    String? datetime,
    String? hashrate,
    String? rejectHashrate,
    String? staleHashrate,
  }) {
    return PanelChartHashrateTicks()
      ..unix = unix ?? this.unix
      ..datetime = datetime ?? this.datetime
      ..hashrate = hashrate ?? this.hashrate
      ..rejectHashrate = rejectHashrate ?? this.rejectHashrate
      ..staleHashrate = staleHashrate ?? this.staleHashrate;
  }
}
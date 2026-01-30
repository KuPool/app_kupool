import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/subAccount_panel_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/subAccount_panel_entity.g.dart';

@JsonSerializable()
class SubAccountPanelEntity {
	@JSONField(name: 'realtime_hashrate')
	String? realtimeHashrate;
	@JSONField(name: 'realtime_hashrate_unit')
	String? realtimeHashrateUnit;
	@JSONField(name: 'hour24_hashrate')
	String? hour24Hashrate;
	@JSONField(name: 'hour24_hashrate_unit')
	String? hour24HashrateUnit;
	@JSONField(name: 'active_miners')
	int? activeMiners;
	@JSONField(name: 'inactive_miners')
	int? inactiveMiners;
	@JSONField(name: 'dead_miners')
	int? deadMiners;
	@JSONField(name: 'yesterday_earnings')
	String? yesterdayEarnings;
	@JSONField(name: 'yesterday_earnings_doge')
	String? yesterdayEarningsDoge;
	@JSONField(name: 'today_estimated')
	String? todayEstimated;
	@JSONField(name: 'today_estimated_doge')
	String? todayEstimatedDoge;
	@JSONField(name: 'yesterday_accept_hashrate')
	String? yesterdayAcceptHashrate;
	@JSONField(name: 'yesterday_accept_hashrate_unit')
	String? yesterdayAcceptHashrateUnit;
  bool settling = false;

	SubAccountPanelEntity();

	factory SubAccountPanelEntity.fromJson(Map<String, dynamic> json) => $SubAccountPanelEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubAccountPanelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
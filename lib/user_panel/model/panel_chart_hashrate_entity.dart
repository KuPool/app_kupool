import 'dart:convert';

import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/panel_chart_hashrate_entity.g.dart';

export 'package:Kupool/generated/json/panel_chart_hashrate_entity.g.dart';

@JsonSerializable()
class PanelChartHashrateEntity {
	List<PanelChartHashrateTicks>? ticks;
	String? unit;

	PanelChartHashrateEntity();

	factory PanelChartHashrateEntity.fromJson(Map<String, dynamic> json) => $PanelChartHashrateEntityFromJson(json);

	Map<String, dynamic> toJson() => $PanelChartHashrateEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class PanelChartHashrateTicks {
	int? unix;
	String? datetime;
	String? hashrate;
	@JSONField(name: 'reject_hashrate')
	String? rejectHashrate;
	@JSONField(name: 'stale_hashrate')
	String? staleHashrate;

	PanelChartHashrateTicks();

	factory PanelChartHashrateTicks.fromJson(Map<String, dynamic> json) => $PanelChartHashrateTicksFromJson(json);

	Map<String, dynamic> toJson() => $PanelChartHashrateTicksToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
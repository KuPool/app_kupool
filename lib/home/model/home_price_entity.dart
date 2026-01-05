import 'package:Kupool/generated/json/base/json_field.dart';
import 'package:Kupool/generated/json/home_price_entity.g.dart';
import 'dart:convert';
export 'package:Kupool/generated/json/home_price_entity.g.dart';

@JsonSerializable()
class HomePriceEntity {
	HomePriceFiat? fiat;
	HomePricePrice? price;

	HomePriceEntity();

	factory HomePriceEntity.fromJson(Map<String, dynamic> json) => $HomePriceEntityFromJson(json);

	Map<String, dynamic> toJson() => $HomePriceEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePriceFiat {
	double? btc;
	double? cny;
	double? eur;
	double? jpy;
	double? krw;
	double? rub;
	double? sar;
	int? usd;

	HomePriceFiat();

	factory HomePriceFiat.fromJson(Map<String, dynamic> json) => $HomePriceFiatFromJson(json);

	Map<String, dynamic> toJson() => $HomePriceFiatToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePrice {
	HomePricePriceBel? bel;
	HomePricePriceDingo? dingo;
	HomePricePriceDoge? doge;
	HomePricePriceLky? lky;
	HomePricePriceLtc? ltc;
	HomePricePricePep? pep;
	HomePricePriceShic? shic;
	HomePricePriceTrmp? trmp;

	HomePricePrice();

	factory HomePricePrice.fromJson(Map<String, dynamic> json) => $HomePricePriceFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceBel {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePriceBel();

	factory HomePricePriceBel.fromJson(Map<String, dynamic> json) => $HomePricePriceBelFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceBelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceDingo {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePriceDingo();

	factory HomePricePriceDingo.fromJson(Map<String, dynamic> json) => $HomePricePriceDingoFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceDingoToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceDoge {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePriceDoge();

	factory HomePricePriceDoge.fromJson(Map<String, dynamic> json) => $HomePricePriceDogeFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceDogeToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceLky {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePriceLky();

	factory HomePricePriceLky.fromJson(Map<String, dynamic> json) => $HomePricePriceLkyFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceLkyToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceLtc {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePriceLtc();

	factory HomePricePriceLtc.fromJson(Map<String, dynamic> json) => $HomePricePriceLtcFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceLtcToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePricePep {
	double? price;
	@JSONField(name: 'change_24h')
	double? change24h;

	HomePricePricePep();

	factory HomePricePricePep.fromJson(Map<String, dynamic> json) => $HomePricePricePepFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePricePepToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceShic {
	double? price;
	@JSONField(name: 'change_24h')
	int? change24h;

	HomePricePriceShic();

	factory HomePricePriceShic.fromJson(Map<String, dynamic> json) => $HomePricePriceShicFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceShicToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomePricePriceTrmp {
	double? price;
	@JSONField(name: 'change_24h')
	int? change24h;

	HomePricePriceTrmp();

	factory HomePricePriceTrmp.fromJson(Map<String, dynamic> json) => $HomePricePriceTrmpFromJson(json);

	Map<String, dynamic> toJson() => $HomePricePriceTrmpToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
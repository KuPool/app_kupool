import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/home/model/home_price_entity.dart';

HomePriceEntity $HomePriceEntityFromJson(Map<String, dynamic> json) {
  final HomePriceEntity homePriceEntity = HomePriceEntity();
  final HomePriceFiat? fiat = jsonConvert.convert<HomePriceFiat>(json['fiat']);
  if (fiat != null) {
    homePriceEntity.fiat = fiat;
  }
  final HomePricePrice? price = jsonConvert.convert<HomePricePrice>(
      json['price']);
  if (price != null) {
    homePriceEntity.price = price;
  }
  return homePriceEntity;
}

Map<String, dynamic> $HomePriceEntityToJson(HomePriceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['fiat'] = entity.fiat?.toJson();
  data['price'] = entity.price?.toJson();
  return data;
}

extension HomePriceEntityExtension on HomePriceEntity {
  HomePriceEntity copyWith({
    HomePriceFiat? fiat,
    HomePricePrice? price,
  }) {
    return HomePriceEntity()
      ..fiat = fiat ?? this.fiat
      ..price = price ?? this.price;
  }
}

HomePriceFiat $HomePriceFiatFromJson(Map<String, dynamic> json) {
  final HomePriceFiat homePriceFiat = HomePriceFiat();
  final double? btc = jsonConvert.convert<double>(json['btc']);
  if (btc != null) {
    homePriceFiat.btc = btc;
  }
  final double? cny = jsonConvert.convert<double>(json['cny']);
  if (cny != null) {
    homePriceFiat.cny = cny;
  }
  final double? eur = jsonConvert.convert<double>(json['eur']);
  if (eur != null) {
    homePriceFiat.eur = eur;
  }
  final double? jpy = jsonConvert.convert<double>(json['jpy']);
  if (jpy != null) {
    homePriceFiat.jpy = jpy;
  }
  final double? krw = jsonConvert.convert<double>(json['krw']);
  if (krw != null) {
    homePriceFiat.krw = krw;
  }
  final double? rub = jsonConvert.convert<double>(json['rub']);
  if (rub != null) {
    homePriceFiat.rub = rub;
  }
  final double? sar = jsonConvert.convert<double>(json['sar']);
  if (sar != null) {
    homePriceFiat.sar = sar;
  }
  final int? usd = jsonConvert.convert<int>(json['usd']);
  if (usd != null) {
    homePriceFiat.usd = usd;
  }
  return homePriceFiat;
}

Map<String, dynamic> $HomePriceFiatToJson(HomePriceFiat entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['btc'] = entity.btc;
  data['cny'] = entity.cny;
  data['eur'] = entity.eur;
  data['jpy'] = entity.jpy;
  data['krw'] = entity.krw;
  data['rub'] = entity.rub;
  data['sar'] = entity.sar;
  data['usd'] = entity.usd;
  return data;
}

extension HomePriceFiatExtension on HomePriceFiat {
  HomePriceFiat copyWith({
    double? btc,
    double? cny,
    double? eur,
    double? jpy,
    double? krw,
    double? rub,
    double? sar,
    int? usd,
  }) {
    return HomePriceFiat()
      ..btc = btc ?? this.btc
      ..cny = cny ?? this.cny
      ..eur = eur ?? this.eur
      ..jpy = jpy ?? this.jpy
      ..krw = krw ?? this.krw
      ..rub = rub ?? this.rub
      ..sar = sar ?? this.sar
      ..usd = usd ?? this.usd;
  }
}

HomePricePrice $HomePricePriceFromJson(Map<String, dynamic> json) {
  final HomePricePrice homePricePrice = HomePricePrice();
  final HomePricePriceBel? bel = jsonConvert.convert<HomePricePriceBel>(
      json['bel']);
  if (bel != null) {
    homePricePrice.bel = bel;
  }
  final HomePricePriceDingo? dingo = jsonConvert.convert<HomePricePriceDingo>(
      json['dingo']);
  if (dingo != null) {
    homePricePrice.dingo = dingo;
  }
  final HomePricePriceDoge? doge = jsonConvert.convert<HomePricePriceDoge>(
      json['doge']);
  if (doge != null) {
    homePricePrice.doge = doge;
  }
  final HomePricePriceLky? lky = jsonConvert.convert<HomePricePriceLky>(
      json['lky']);
  if (lky != null) {
    homePricePrice.lky = lky;
  }
  final HomePricePriceLtc? ltc = jsonConvert.convert<HomePricePriceLtc>(
      json['ltc']);
  if (ltc != null) {
    homePricePrice.ltc = ltc;
  }
  final HomePricePricePep? pep = jsonConvert.convert<HomePricePricePep>(
      json['pep']);
  if (pep != null) {
    homePricePrice.pep = pep;
  }
  final HomePricePriceShic? shic = jsonConvert.convert<HomePricePriceShic>(
      json['shic']);
  if (shic != null) {
    homePricePrice.shic = shic;
  }
  final HomePricePriceTrmp? trmp = jsonConvert.convert<HomePricePriceTrmp>(
      json['trmp']);
  if (trmp != null) {
    homePricePrice.trmp = trmp;
  }
  return homePricePrice;
}

Map<String, dynamic> $HomePricePriceToJson(HomePricePrice entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['bel'] = entity.bel?.toJson();
  data['dingo'] = entity.dingo?.toJson();
  data['doge'] = entity.doge?.toJson();
  data['lky'] = entity.lky?.toJson();
  data['ltc'] = entity.ltc?.toJson();
  data['pep'] = entity.pep?.toJson();
  data['shic'] = entity.shic?.toJson();
  data['trmp'] = entity.trmp?.toJson();
  return data;
}

extension HomePricePriceExtension on HomePricePrice {
  HomePricePrice copyWith({
    HomePricePriceBel? bel,
    HomePricePriceDingo? dingo,
    HomePricePriceDoge? doge,
    HomePricePriceLky? lky,
    HomePricePriceLtc? ltc,
    HomePricePricePep? pep,
    HomePricePriceShic? shic,
    HomePricePriceTrmp? trmp,
  }) {
    return HomePricePrice()
      ..bel = bel ?? this.bel
      ..dingo = dingo ?? this.dingo
      ..doge = doge ?? this.doge
      ..lky = lky ?? this.lky
      ..ltc = ltc ?? this.ltc
      ..pep = pep ?? this.pep
      ..shic = shic ?? this.shic
      ..trmp = trmp ?? this.trmp;
  }
}

HomePricePriceBel $HomePricePriceBelFromJson(Map<String, dynamic> json) {
  final HomePricePriceBel homePricePriceBel = HomePricePriceBel();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceBel.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePriceBel.change24h = change24h;
  }
  return homePricePriceBel;
}

Map<String, dynamic> $HomePricePriceBelToJson(HomePricePriceBel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceBelExtension on HomePricePriceBel {
  HomePricePriceBel copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePriceBel()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceDingo $HomePricePriceDingoFromJson(Map<String, dynamic> json) {
  final HomePricePriceDingo homePricePriceDingo = HomePricePriceDingo();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceDingo.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePriceDingo.change24h = change24h;
  }
  return homePricePriceDingo;
}

Map<String, dynamic> $HomePricePriceDingoToJson(HomePricePriceDingo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceDingoExtension on HomePricePriceDingo {
  HomePricePriceDingo copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePriceDingo()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceDoge $HomePricePriceDogeFromJson(Map<String, dynamic> json) {
  final HomePricePriceDoge homePricePriceDoge = HomePricePriceDoge();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceDoge.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePriceDoge.change24h = change24h;
  }
  return homePricePriceDoge;
}

Map<String, dynamic> $HomePricePriceDogeToJson(HomePricePriceDoge entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceDogeExtension on HomePricePriceDoge {
  HomePricePriceDoge copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePriceDoge()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceLky $HomePricePriceLkyFromJson(Map<String, dynamic> json) {
  final HomePricePriceLky homePricePriceLky = HomePricePriceLky();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceLky.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePriceLky.change24h = change24h;
  }
  return homePricePriceLky;
}

Map<String, dynamic> $HomePricePriceLkyToJson(HomePricePriceLky entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceLkyExtension on HomePricePriceLky {
  HomePricePriceLky copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePriceLky()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceLtc $HomePricePriceLtcFromJson(Map<String, dynamic> json) {
  final HomePricePriceLtc homePricePriceLtc = HomePricePriceLtc();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceLtc.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePriceLtc.change24h = change24h;
  }
  return homePricePriceLtc;
}

Map<String, dynamic> $HomePricePriceLtcToJson(HomePricePriceLtc entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceLtcExtension on HomePricePriceLtc {
  HomePricePriceLtc copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePriceLtc()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePricePep $HomePricePricePepFromJson(Map<String, dynamic> json) {
  final HomePricePricePep homePricePricePep = HomePricePricePep();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePricePep.price = price;
  }
  final double? change24h = jsonConvert.convert<double>(json['change_24h']);
  if (change24h != null) {
    homePricePricePep.change24h = change24h;
  }
  return homePricePricePep;
}

Map<String, dynamic> $HomePricePricePepToJson(HomePricePricePep entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePricePepExtension on HomePricePricePep {
  HomePricePricePep copyWith({
    double? price,
    double? change24h,
  }) {
    return HomePricePricePep()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceShic $HomePricePriceShicFromJson(Map<String, dynamic> json) {
  final HomePricePriceShic homePricePriceShic = HomePricePriceShic();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceShic.price = price;
  }
  final int? change24h = jsonConvert.convert<int>(json['change_24h']);
  if (change24h != null) {
    homePricePriceShic.change24h = change24h;
  }
  return homePricePriceShic;
}

Map<String, dynamic> $HomePricePriceShicToJson(HomePricePriceShic entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceShicExtension on HomePricePriceShic {
  HomePricePriceShic copyWith({
    double? price,
    int? change24h,
  }) {
    return HomePricePriceShic()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}

HomePricePriceTrmp $HomePricePriceTrmpFromJson(Map<String, dynamic> json) {
  final HomePricePriceTrmp homePricePriceTrmp = HomePricePriceTrmp();
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    homePricePriceTrmp.price = price;
  }
  final int? change24h = jsonConvert.convert<int>(json['change_24h']);
  if (change24h != null) {
    homePricePriceTrmp.change24h = change24h;
  }
  return homePricePriceTrmp;
}

Map<String, dynamic> $HomePricePriceTrmpToJson(HomePricePriceTrmp entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['price'] = entity.price;
  data['change_24h'] = entity.change24h;
  return data;
}

extension HomePricePriceTrmpExtension on HomePricePriceTrmp {
  HomePricePriceTrmp copyWith({
    double? price,
    int? change24h,
  }) {
    return HomePricePriceTrmp()
      ..price = price ?? this.price
      ..change24h = change24h ?? this.change24h;
  }
}
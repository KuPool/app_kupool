import 'package:Kupool/generated/json/base/json_convert_content.dart';
import 'package:Kupool/my/model/sub_list_with_address_entity.dart';

SubListWithAddressEntity $SubListWithAddressEntityFromJson(
    Map<String, dynamic> json) {
  final SubListWithAddressEntity subListWithAddressEntity = SubListWithAddressEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    subListWithAddressEntity.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    subListWithAddressEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['page_size']);
  if (pageSize != null) {
    subListWithAddressEntity.pageSize = pageSize;
  }
  final List<SubListWithAddressList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<SubListWithAddressList>(e) as SubListWithAddressList)
      .toList();
  if (list != null) {
    subListWithAddressEntity.list = list;
  }
  return subListWithAddressEntity;
}

Map<String, dynamic> $SubListWithAddressEntityToJson(
    SubListWithAddressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension SubListWithAddressEntityExtension on SubListWithAddressEntity {
  SubListWithAddressEntity copyWith({
    int? total,
    int? page,
    int? pageSize,
    List<SubListWithAddressList>? list,
  }) {
    return SubListWithAddressEntity()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..list = list ?? this.list;
  }
}

SubListWithAddressList $SubListWithAddressListFromJson(
    Map<String, dynamic> json) {
  final SubListWithAddressList subListWithAddressList = SubListWithAddressList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    subListWithAddressList.id = id;
  }
  final int? uid = jsonConvert.convert<int>(json['uid']);
  if (uid != null) {
    subListWithAddressList.uid = uid;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    subListWithAddressList.name = name;
  }
  final String? defaultCoin = jsonConvert.convert<String>(json['default_coin']);
  if (defaultCoin != null) {
    subListWithAddressList.defaultCoin = defaultCoin;
  }
  final int? isHidden = jsonConvert.convert<int>(json['is_hidden']);
  if (isHidden != null) {
    subListWithAddressList.isHidden = isHidden;
  }
  final int? isDefault = jsonConvert.convert<int>(json['is_default']);
  if (isDefault != null) {
    subListWithAddressList.isDefault = isDefault;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    subListWithAddressList.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    subListWithAddressList.updatedAt = updatedAt;
  }
  final SubListWithAddressListAddresses? addresses = jsonConvert.convert<
      SubListWithAddressListAddresses>(json['addresses']);
  if (addresses != null) {
    subListWithAddressList.addresses = addresses;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    subListWithAddressList.remark = remark;
  }
  return subListWithAddressList;
}

Map<String, dynamic> $SubListWithAddressListToJson(
    SubListWithAddressList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['uid'] = entity.uid;
  data['name'] = entity.name;
  data['default_coin'] = entity.defaultCoin;
  data['is_hidden'] = entity.isHidden;
  data['is_default'] = entity.isDefault;
  data['created_at'] = entity.createdAt;
  data['updated_at'] = entity.updatedAt;
  data['addresses'] = entity.addresses?.toJson();
  data['remark'] = entity.remark;
  return data;
}

extension SubListWithAddressListExtension on SubListWithAddressList {
  SubListWithAddressList copyWith({
    int? id,
    int? uid,
    String? name,
    String? defaultCoin,
    int? isHidden,
    int? isDefault,
    String? createdAt,
    String? updatedAt,
    SubListWithAddressListAddresses? addresses,
    String? remark,
  }) {
    return SubListWithAddressList()
      ..id = id ?? this.id
      ..uid = uid ?? this.uid
      ..name = name ?? this.name
      ..defaultCoin = defaultCoin ?? this.defaultCoin
      ..isHidden = isHidden ?? this.isHidden
      ..isDefault = isDefault ?? this.isDefault
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..addresses = addresses ?? this.addresses
      ..remark = remark ?? this.remark;
  }
}

SubListWithAddressListAddresses $SubListWithAddressListAddressesFromJson(
    Map<String, dynamic> json) {
  final SubListWithAddressListAddresses subListWithAddressListAddresses = SubListWithAddressListAddresses();
  final dynamic btc = json['btc'];
  if (btc != null) {
    subListWithAddressListAddresses.btc = btc;
  }
  final dynamic doge = json['doge'];
  if (doge != null) {
    subListWithAddressListAddresses.doge = doge;
  }
  final dynamic ltc = json['ltc'];
  if (ltc != null) {
    subListWithAddressListAddresses.ltc = ltc;
  }
  return subListWithAddressListAddresses;
}

Map<String, dynamic> $SubListWithAddressListAddressesToJson(
    SubListWithAddressListAddresses entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['btc'] = entity.btc;
  data['doge'] = entity.doge;
  data['ltc'] = entity.ltc;
  return data;
}

extension SubListWithAddressListAddressesExtension on SubListWithAddressListAddresses {
  SubListWithAddressListAddresses copyWith({
    dynamic btc,
    dynamic doge,
    dynamic ltc,
  }) {
    return SubListWithAddressListAddresses()
      ..btc = btc ?? this.btc
      ..doge = doge ?? this.doge
      ..ltc = ltc ?? this.ltc;
  }
}
import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/generated/json/base/json_convert_content.dart';

SubAccountMiniInfoEntity $SubAccountMiniInfoEntityFromJson(
    Map<String, dynamic> json) {
  final SubAccountMiniInfoEntity subAccountMiniInfoEntity = SubAccountMiniInfoEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    subAccountMiniInfoEntity.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    subAccountMiniInfoEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['page_size']);
  if (pageSize != null) {
    subAccountMiniInfoEntity.pageSize = pageSize;
  }
  final List<SubAccountMiniInfoList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<SubAccountMiniInfoList>(e) as SubAccountMiniInfoList)
      .toList();
  if (list != null) {
    subAccountMiniInfoEntity.list = list;
  }
  return subAccountMiniInfoEntity;
}

Map<String, dynamic> $SubAccountMiniInfoEntityToJson(
    SubAccountMiniInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension SubAccountMiniInfoEntityExtension on SubAccountMiniInfoEntity {
  SubAccountMiniInfoEntity copyWith({
    int? total,
    int? page,
    int? pageSize,
    List<SubAccountMiniInfoList>? list,
  }) {
    return SubAccountMiniInfoEntity()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..list = list ?? this.list;
  }
}

SubAccountMiniInfoList $SubAccountMiniInfoListFromJson(
    Map<String, dynamic> json) {
  final SubAccountMiniInfoList subAccountMiniInfoList = SubAccountMiniInfoList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    subAccountMiniInfoList.id = id;
  }
  final int? uid = jsonConvert.convert<int>(json['uid']);
  if (uid != null) {
    subAccountMiniInfoList.uid = uid;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    subAccountMiniInfoList.name = name;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    subAccountMiniInfoList.remark = remark;
  }
  final String? selectCoin = jsonConvert.convert<String>(json['selectCoin']);
  if (selectCoin != null) {
    subAccountMiniInfoList.selectCoin = selectCoin;
  }
  final String? defaultCoin = jsonConvert.convert<String>(json['default_coin']);
  if (defaultCoin != null) {
    subAccountMiniInfoList.defaultCoin = defaultCoin;
  }
  final int? isHidden = jsonConvert.convert<int>(json['is_hidden']);
  if (isHidden != null) {
    subAccountMiniInfoList.isHidden = isHidden;
  }
  final int? isDefault = jsonConvert.convert<int>(json['is_default']);
  if (isDefault != null) {
    subAccountMiniInfoList.isDefault = isDefault;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    subAccountMiniInfoList.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    subAccountMiniInfoList.updatedAt = updatedAt;
  }
  final SubAccountMiniInfoListMiningInfo? miningInfo = jsonConvert.convert<
      SubAccountMiniInfoListMiningInfo>(json['mining_info']);
  if (miningInfo != null) {
    subAccountMiniInfoList.miningInfo = miningInfo;
  }
  return subAccountMiniInfoList;
}

Map<String, dynamic> $SubAccountMiniInfoListToJson(
    SubAccountMiniInfoList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['uid'] = entity.uid;
  data['name'] = entity.name;
  data['remark'] = entity.remark;
  data['selectCoin'] = entity.selectCoin;
  data['default_coin'] = entity.defaultCoin;
  data['is_hidden'] = entity.isHidden;
  data['is_default'] = entity.isDefault;
  data['created_at'] = entity.createdAt;
  data['updated_at'] = entity.updatedAt;
  data['mining_info'] = entity.miningInfo?.toJson();
  return data;
}

extension SubAccountMiniInfoListExtension on SubAccountMiniInfoList {
  SubAccountMiniInfoList copyWith({
    int? id,
    int? uid,
    String? name,
    String? remark,
    String? selectCoin,
    String? defaultCoin,
    int? isHidden,
    int? isDefault,
    String? createdAt,
    String? updatedAt,
    SubAccountMiniInfoListMiningInfo? miningInfo,
  }) {
    return SubAccountMiniInfoList()
      ..id = id ?? this.id
      ..uid = uid ?? this.uid
      ..name = name ?? this.name
      ..remark = remark ?? this.remark
      ..selectCoin = selectCoin ?? this.selectCoin
      ..defaultCoin = defaultCoin ?? this.defaultCoin
      ..isHidden = isHidden ?? this.isHidden
      ..isDefault = isDefault ?? this.isDefault
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..miningInfo = miningInfo ?? this.miningInfo;
  }
}

SubAccountMiniInfoListMiningInfo $SubAccountMiniInfoListMiningInfoFromJson(
    Map<String, dynamic> json) {
  final SubAccountMiniInfoListMiningInfo subAccountMiniInfoListMiningInfo = SubAccountMiniInfoListMiningInfo();
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    subAccountMiniInfoListMiningInfo.date = date;
  }
  final int? subaccountId = jsonConvert.convert<int>(json['subaccount_id']);
  if (subaccountId != null) {
    subAccountMiniInfoListMiningInfo.subaccountId = subaccountId;
  }
  final String? hashrate = jsonConvert.convert<String>(json['hashrate']);
  if (hashrate != null) {
    subAccountMiniInfoListMiningInfo.hashrate = hashrate;
  }
  final int? activeWorkers = jsonConvert.convert<int>(json['active_workers']);
  if (activeWorkers != null) {
    subAccountMiniInfoListMiningInfo.activeWorkers = activeWorkers;
  }
  final String? coinType = jsonConvert.convert<String>(json['coin_type']);
  if (coinType != null) {
    subAccountMiniInfoListMiningInfo.coinType = coinType;
  }
  final String? earn = jsonConvert.convert<String>(json['earn']);
  if (earn != null) {
    subAccountMiniInfoListMiningInfo.earn = earn;
  }
  return subAccountMiniInfoListMiningInfo;
}

Map<String, dynamic> $SubAccountMiniInfoListMiningInfoToJson(
    SubAccountMiniInfoListMiningInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['date'] = entity.date;
  data['subaccount_id'] = entity.subaccountId;
  data['hashrate'] = entity.hashrate;
  data['active_workers'] = entity.activeWorkers;
  data['coin_type'] = entity.coinType;
  data['earn'] = entity.earn;
  return data;
}

extension SubAccountMiniInfoListMiningInfoExtension on SubAccountMiniInfoListMiningInfo {
  SubAccountMiniInfoListMiningInfo copyWith({
    String? date,
    int? subaccountId,
    String? hashrate,
    int? activeWorkers,
    String? coinType,
    String? earn,
  }) {
    return SubAccountMiniInfoListMiningInfo()
      ..date = date ?? this.date
      ..subaccountId = subaccountId ?? this.subaccountId
      ..hashrate = hashrate ?? this.hashrate
      ..activeWorkers = activeWorkers ?? this.activeWorkers
      ..coinType = coinType ?? this.coinType
      ..earn = earn ?? this.earn;
  }
}
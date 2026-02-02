import 'package:Kupool/earnings/model/earnings_record_entity.dart';
import 'package:Kupool/generated/json/base/json_convert_content.dart';

EarningsRecordEntity $EarningsRecordEntityFromJson(Map<String, dynamic> json) {
  final EarningsRecordEntity earningsRecordEntity = EarningsRecordEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    earningsRecordEntity.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    earningsRecordEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['page_size']);
  if (pageSize != null) {
    earningsRecordEntity.pageSize = pageSize;
  }
  final List<EarningsRecordList>? list = (json['list'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<EarningsRecordList>(e) as EarningsRecordList)
      .toList();
  if (list != null) {
    earningsRecordEntity.list = list;
  }
  return earningsRecordEntity;
}

Map<String, dynamic> $EarningsRecordEntityToJson(EarningsRecordEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['page_size'] = entity.pageSize;
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension EarningsRecordEntityExtension on EarningsRecordEntity {
  EarningsRecordEntity copyWith({
    int? total,
    int? page,
    int? pageSize,
    List<EarningsRecordList>? list,
  }) {
    return EarningsRecordEntity()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..list = list ?? this.list;
  }
}

EarningsRecordList $EarningsRecordListFromJson(Map<String, dynamic> json) {
  final EarningsRecordList earningsRecordList = EarningsRecordList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    earningsRecordList.id = id;
  }
  final int? billNo = jsonConvert.convert<int>(json['bill_no']);
  if (billNo != null) {
    earningsRecordList.billNo = billNo;
  }
  final String? datetime = jsonConvert.convert<String>(json['datetime']);
  if (datetime != null) {
    earningsRecordList.datetime = datetime;
  }
  final int? subaccountId = jsonConvert.convert<int>(json['subaccount_id']);
  if (subaccountId != null) {
    earningsRecordList.subaccountId = subaccountId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    earningsRecordList.name = name;
  }
  final String? direction = jsonConvert.convert<String>(json['direction']);
  if (direction != null) {
    earningsRecordList.direction = direction;
  }
  final String? coin = jsonConvert.convert<String>(json['coin']);
  if (coin != null) {
    earningsRecordList.coin = coin;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    earningsRecordList.address = address;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    earningsRecordList.type = type;
  }
  final String? amount = jsonConvert.convert<String>(json['amount']);
  if (amount != null) {
    earningsRecordList.amount = amount;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    earningsRecordList.status = status;
  }
  final String? hashrate = jsonConvert.convert<String>(json['hashrate']);
  if (hashrate != null) {
    earningsRecordList.hashrate = hashrate;
  }
  final String? hashUnit = jsonConvert.convert<String>(json['hash_unit']);
  if (hashUnit != null) {
    earningsRecordList.hashUnit = hashUnit;
  }
  final String? feeType = jsonConvert.convert<String>(json['fee_type']);
  if (feeType != null) {
    earningsRecordList.feeType = feeType;
  }
  final String? txHash = jsonConvert.convert<String>(json['tx_hash']);
  if (txHash != null) {
    earningsRecordList.txHash = txHash;
  }
  final String? createdAt = jsonConvert.convert<String>(json['created_at']);
  if (createdAt != null) {
    earningsRecordList.createdAt = createdAt;
  }
  final String? updatedAt = jsonConvert.convert<String>(json['updated_at']);
  if (updatedAt != null) {
    earningsRecordList.updatedAt = updatedAt;
  }
  return earningsRecordList;
}

Map<String, dynamic> $EarningsRecordListToJson(EarningsRecordList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['bill_no'] = entity.billNo;
  data['datetime'] = entity.datetime;
  data['subaccount_id'] = entity.subaccountId;
  data['name'] = entity.name;
  data['direction'] = entity.direction;
  data['coin'] = entity.coin;
  data['address'] = entity.address;
  data['type'] = entity.type;
  data['amount'] = entity.amount;
  data['status'] = entity.status;
  data['hashrate'] = entity.hashrate;
  data['hash_unit'] = entity.hashUnit;
  data['fee_type'] = entity.feeType;
  data['tx_hash'] = entity.txHash;
  data['created_at'] = entity.createdAt;
  data['updated_at'] = entity.updatedAt;
  return data;
}

extension EarningsRecordListExtension on EarningsRecordList {
  EarningsRecordList copyWith({
    int? id,
    int? billNo,
    String? datetime,
    int? subaccountId,
    String? name,
    String? direction,
    String? coin,
    String? address,
    int? type,
    String? amount,
    int? status,
    String? hashrate,
    String? hashUnit,
    String? feeType,
    String? txHash,
    String? createdAt,
    String? updatedAt,
  }) {
    return EarningsRecordList()
      ..id = id ?? this.id
      ..billNo = billNo ?? this.billNo
      ..datetime = datetime ?? this.datetime
      ..subaccountId = subaccountId ?? this.subaccountId
      ..name = name ?? this.name
      ..direction = direction ?? this.direction
      ..coin = coin ?? this.coin
      ..address = address ?? this.address
      ..type = type ?? this.type
      ..amount = amount ?? this.amount
      ..status = status ?? this.status
      ..hashrate = hashrate ?? this.hashrate
      ..hashUnit = hashUnit ?? this.hashUnit
      ..feeType = feeType ?? this.feeType
      ..txHash = txHash ?? this.txHash
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt;
  }
}
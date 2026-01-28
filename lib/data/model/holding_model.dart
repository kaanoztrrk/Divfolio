import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

@HiveType(typeId: HiveTypeIds.holding)
class HoldingModel {
  HoldingModel({
    required this.id,
    required this.portfolioId,
    required this.companyId,
    required this.shares,
    this.avgCost,
    this.currencyCode,
    required this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String portfolioId;

  @HiveField(2)
  final String companyId;

  @HiveField(3)
  final double shares;

  @HiveField(4)
  final double? avgCost;

  @HiveField(5)
  final String? currencyCode;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;
}

class HoldingModelAdapter extends TypeAdapter<HoldingModel> {
  @override
  final int typeId = HiveTypeIds.holding;

  @override
  HoldingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HoldingModel(
      id: fields[0] as String,
      portfolioId: fields[1] as String,
      companyId: fields[2] as String,
      shares: (fields[3] as num).toDouble(),
      avgCost: fields[4] == null ? null : (fields[4] as num).toDouble(),
      currencyCode: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HoldingModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.portfolioId)
      ..writeByte(2)
      ..write(obj.companyId)
      ..writeByte(3)
      ..write(obj.shares)
      ..writeByte(4)
      ..write(obj.avgCost)
      ..writeByte(5)
      ..write(obj.currencyCode)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }
}

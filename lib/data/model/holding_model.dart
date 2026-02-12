import 'package:hive/hive.dart';
import 'hive_type_ids.dart';
import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

const _sentinel = Object();

@HiveType(typeId: HiveTypeIds.holding)
class HoldingModel {
  HoldingModel({
    required this.id,
    required this.portfolioId,
    required this.companyId,
    required this.companyName,
    required this.shares,
    required this.createdAt,
    this.avgCost,
    this.currencyCode,
    this.payDate,
    this.updatedAt,
  });

  /// Hive key ile birebir
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String portfolioId;

  @HiveField(2)
  final String companyId;

  @HiveField(3)
  final String companyName;

  @HiveField(4)
  final double shares;

  @HiveField(5)
  final double? avgCost;

  @HiveField(6)
  final String? currencyCode;

  @HiveField(7)
  final DateTime? payDate;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  HoldingModel copyWith({
    String? portfolioId,
    String? companyId,
    String? companyName,
    double? shares,
    Object? avgCost = _sentinel,
    Object? currencyCode = _sentinel,
    Object? payDate = _sentinel,
    DateTime? updatedAt,
  }) {
    return HoldingModel(
      id: id,
      portfolioId: portfolioId ?? this.portfolioId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      shares: shares ?? this.shares,
      avgCost: avgCost == _sentinel ? this.avgCost : avgCost as double?,
      currencyCode: currencyCode == _sentinel
          ? this.currencyCode
          : currencyCode as String?,
      payDate: payDate == _sentinel ? this.payDate : payDate as DateTime?,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
      companyName: fields[3] as String,
      shares: (fields[4] as num).toDouble(),
      avgCost: fields[5] == null ? null : (fields[5] as num).toDouble(),
      currencyCode: fields[6] as String?,
      payDate: fields[7] as DateTime?,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HoldingModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.portfolioId)
      ..writeByte(2)
      ..write(obj.companyId)
      ..writeByte(3)
      ..write(obj.companyName)
      ..writeByte(4)
      ..write(obj.shares)
      ..writeByte(5)
      ..write(obj.avgCost)
      ..writeByte(6)
      ..write(obj.currencyCode)
      ..writeByte(7)
      ..write(obj.payDate)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }
}

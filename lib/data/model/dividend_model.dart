import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

@HiveType(typeId: HiveTypeIds.dividend)
class DividendModel {
  DividendModel({
    required this.id,
    required this.portfolioId,
    required this.companyId,
    required this.payDate,
    required this.sharesAtPayDate,
    required this.dividendPerShare,
    required this.currencyCode,
    this.taxRate,
    this.netOverride,
    this.notes,
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
  final DateTime payDate;

  @HiveField(4)
  final double sharesAtPayDate;

  @HiveField(5)
  final double dividendPerShare;

  @HiveField(6)
  final String currencyCode;

  @HiveField(7)
  final double? taxRate;

  @HiveField(8)
  final double? netOverride;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime? updatedAt;

  double get grossAmount => sharesAtPayDate * dividendPerShare;

  double get netAmount {
    if (netOverride != null) return netOverride!;
    final rate = taxRate ?? 0.0;
    return grossAmount * (1 - rate);
  }
}

class DividendModelAdapter extends TypeAdapter<DividendModel> {
  @override
  final int typeId = HiveTypeIds.dividend;

  @override
  DividendModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return DividendModel(
      id: fields[0] as String,
      portfolioId: fields[1] as String,
      companyId: fields[2] as String,
      payDate: fields[3] as DateTime,
      sharesAtPayDate: (fields[4] as num).toDouble(),
      dividendPerShare: (fields[5] as num).toDouble(),
      currencyCode: fields[6] as String,
      taxRate: fields[7] == null ? null : (fields[7] as num).toDouble(),
      netOverride: fields[8] == null ? null : (fields[8] as num).toDouble(),
      notes: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DividendModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.portfolioId)
      ..writeByte(2)
      ..write(obj.companyId)
      ..writeByte(3)
      ..write(obj.payDate)
      ..writeByte(4)
      ..write(obj.sharesAtPayDate)
      ..writeByte(5)
      ..write(obj.dividendPerShare)
      ..writeByte(6)
      ..write(obj.currencyCode)
      ..writeByte(7)
      ..write(obj.taxRate)
      ..writeByte(8)
      ..write(obj.netOverride)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }
}

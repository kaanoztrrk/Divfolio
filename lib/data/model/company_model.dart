import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

@HiveType(typeId: HiveTypeIds.company)
class CompanyModel {
  CompanyModel({
    required this.id,
    required this.ticker,
    required this.name,
    required this.exchange,
    required this.currencyCode,
    this.countryCode,
    this.sector,
    this.logoUrl,
    this.lastSyncedAt,
    required this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ticker;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String exchange;

  @HiveField(4)
  final String currencyCode;

  @HiveField(5)
  final String? countryCode;

  @HiveField(6)
  final String? sector;

  @HiveField(7)
  final String? logoUrl;

  @HiveField(8)
  final DateTime? lastSyncedAt;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? updatedAt;
}

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = HiveTypeIds.company;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CompanyModel(
      id: fields[0] as String,
      ticker: fields[1] as String,
      name: fields[2] as String,
      exchange: fields[3] as String,
      currencyCode: fields[4] as String,
      countryCode: fields[5] as String?,
      sector: fields[6] as String?,
      logoUrl: fields[7] as String?,
      lastSyncedAt: fields[8] as DateTime?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ticker)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.exchange)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.countryCode)
      ..writeByte(6)
      ..write(obj.sector)
      ..writeByte(7)
      ..write(obj.logoUrl)
      ..writeByte(8)
      ..write(obj.lastSyncedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }
}

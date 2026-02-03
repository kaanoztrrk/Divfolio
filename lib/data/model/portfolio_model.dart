import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

@HiveType(typeId: HiveTypeIds.portfolio)
class PortfolioModel {
  PortfolioModel({
    required this.id,
    required this.name,
    required this.baseCurrencyCode,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String baseCurrencyCode;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final String? notes;

  /// 🔹 Immutable update helper
  PortfolioModel copyWith({
    String? id,
    String? name,
    String? baseCurrencyCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    bool clearNotes = false,
  }) {
    return PortfolioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }
}

class PortfolioModelAdapter extends TypeAdapter<PortfolioModel> {
  @override
  final int typeId = HiveTypeIds.portfolio;

  @override
  PortfolioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PortfolioModel(
      id: fields[0] as String,
      name: fields[1] as String,
      baseCurrencyCode: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime?,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PortfolioModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.baseCurrencyCode)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.notes);
  }
}

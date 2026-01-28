import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

@HiveType(typeId: HiveTypeIds.currency)
class CurrencyModel {
  CurrencyModel({
    required this.code,
    required this.symbol,
    required this.decimals,
    this.name,
  });

  @HiveField(0)
  final String code;

  @HiveField(1)
  final String symbol;

  @HiveField(2)
  final int decimals;

  @HiveField(3)
  final String? name;
}

class CurrencyModelAdapter extends TypeAdapter<CurrencyModel> {
  @override
  final int typeId = HiveTypeIds.currency;
  @override
  CurrencyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CurrencyModel(
      code: fields[0] as String,
      symbol: fields[1] as String,
      decimals: fields[2] as int,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.decimals)
      ..writeByte(3)
      ..write(obj.name);
  }
}

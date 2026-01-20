import 'package:meta/meta.dart';

@immutable
class Currency {
  const Currency({
    required this.code, // "USD", "TRY"
    required this.symbol, // "$", "₺"
    required this.decimals, // 2
    this.name, // "US Dollar"
  });

  final String code;
  final String symbol;
  final int decimals;
  final String? name;

  Currency copyWith({
    String? code,
    String? symbol,
    int? decimals,
    String? name,
  }) {
    return Currency(
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'symbol': symbol,
    'decimals': decimals,
    'name': name,
  };

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      decimals: (json['decimals'] as num).toInt(),
      name: json['name'] as String?,
    );
  }

  @override
  String toString() => 'Currency($code)';
}

import 'package:meta/meta.dart';

@immutable
class Company {
  const Company({
    required this.id, // unique (uuid/ulid) OR stable key like "NASDAQ:AAPL"
    required this.ticker, // "AAPL", "TUPRS.IS"
    required this.name, // "Apple Inc."
    required this.exchange, // "NASDAQ", "BIST"
    required this.currencyCode, // price/dividend currency (default)
    this.countryCode, // "US", "TR"
    this.sector,
    this.logoUrl,
    this.lastSyncedAt, // API sync timestamp
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String ticker;
  final String name;
  final String exchange;
  final String currencyCode;

  final String? countryCode;
  final String? sector;
  final String? logoUrl;

  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Company copyWith({
    String? id,
    String? ticker,
    String? name,
    String? exchange,
    String? currencyCode,
    String? countryCode,
    String? sector,
    String? logoUrl,
    DateTime? lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      ticker: ticker ?? this.ticker,
      name: name ?? this.name,
      exchange: exchange ?? this.exchange,
      currencyCode: currencyCode ?? this.currencyCode,
      countryCode: countryCode ?? this.countryCode,
      sector: sector ?? this.sector,
      logoUrl: logoUrl ?? this.logoUrl,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ticker': ticker,
    'name': name,
    'exchange': exchange,
    'currencyCode': currencyCode,
    'countryCode': countryCode,
    'sector': sector,
    'logoUrl': logoUrl,
    'lastSyncedAt': lastSyncedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      ticker: json['ticker'] as String,
      name: json['name'] as String,
      exchange: json['exchange'] as String,
      currencyCode: json['currencyCode'] as String,
      countryCode: json['countryCode'] as String?,
      sector: json['sector'] as String?,
      logoUrl: json['logoUrl'] as String?,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() => 'Company($exchange:$ticker)';
}

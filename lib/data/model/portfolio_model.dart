import 'package:meta/meta.dart';

@immutable
class Portfolio {
  const Portfolio({
    required this.id,
    required this.name,
    required this.baseCurrencyCode, // "USD" - dashboard totals default
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  final String id;
  final String name;

  /// Dashboard toplamlarını hangi para biriminde göstereceksin?
  /// (MVP’de conversion yoksa sadece label olarak kalsın.)
  final String baseCurrencyCode;

  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;

  Portfolio copyWith({
    String? id,
    String? name,
    String? baseCurrencyCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Portfolio(
      id: id ?? this.id,
      name: name ?? this.name,
      baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'baseCurrencyCode': baseCurrencyCode,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'notes': notes,
  };

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] as String,
      name: json['name'] as String,
      baseCurrencyCode: json['baseCurrencyCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() => 'Portfolio($name, $baseCurrencyCode)';
}

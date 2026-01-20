import 'package:meta/meta.dart';

@immutable
class Holding {
  const Holding({
    required this.id,
    required this.portfolioId,
    required this.companyId, // Company.id reference
    required this.shares, // kullanıcı pozisyonu
    this.avgCost, // optional: ileride ROI vs
    this.currencyCode, // optional: cost currency; yoksa company currency
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String portfolioId;
  final String companyId;

  final double shares;

  /// Ortalama maliyet (isteğe bağlı). MVP’de kullanmak zorunda değilsin.
  final double? avgCost;

  /// Maliyet para birimi. (Çoklu para birimi işine girersen lazım.)
  final String? currencyCode;

  final DateTime createdAt;
  final DateTime? updatedAt;

  Holding copyWith({
    String? id,
    String? portfolioId,
    String? companyId,
    double? shares,
    double? avgCost,
    String? currencyCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Holding(
      id: id ?? this.id,
      portfolioId: portfolioId ?? this.portfolioId,
      companyId: companyId ?? this.companyId,
      shares: shares ?? this.shares,
      avgCost: avgCost ?? this.avgCost,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'portfolioId': portfolioId,
    'companyId': companyId,
    'shares': shares,
    'avgCost': avgCost,
    'currencyCode': currencyCode,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      companyId: json['companyId'] as String,
      shares: (json['shares'] as num).toDouble(),
      avgCost: json['avgCost'] == null
          ? null
          : (json['avgCost'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() => 'Holding(companyId: $companyId, shares: $shares)';
}

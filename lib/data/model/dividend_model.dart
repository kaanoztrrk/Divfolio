import 'package:meta/meta.dart';

@immutable
class Dividend {
  const Dividend({
    required this.id,
    required this.portfolioId,
    required this.companyId,
    required this.payDate,

    /// Bu kayıt oluşturulurken elde tutulan lot.
    /// (Holding sonradan değişse bile geçmiş kayıt bozulmasın.)
    required this.sharesAtPayDate,

    /// Hisse başı brüt temettü
    required this.dividendPerShare,

    /// Ödeme para birimi (genelde company currency)
    required this.currencyCode,

    /// 0.15 = %15 (opsiyonel)
    this.taxRate,

    /// Eğer broker net tutar veriyorsa doğrudan net de girebilirsin (opsiyonel).
    /// Verilirse hesaplamalarda net tercih edilebilir.
    this.netOverride,

    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String portfolioId;
  final String companyId;

  final DateTime payDate;

  final double sharesAtPayDate;
  final double dividendPerShare;
  final String currencyCode;

  final double? taxRate;
  final double? netOverride;

  final String? notes;

  final DateTime createdAt;
  final DateTime? updatedAt;

  double get grossAmount => sharesAtPayDate * dividendPerShare;

  double get netAmount {
    if (netOverride != null) return netOverride!;
    final rate = taxRate ?? 0.0;
    return grossAmount * (1 - rate);
  }

  Dividend copyWith({
    String? id,
    String? portfolioId,
    String? companyId,
    DateTime? payDate,
    double? sharesAtPayDate,
    double? dividendPerShare,
    String? currencyCode,
    double? taxRate,
    double? netOverride,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dividend(
      id: id ?? this.id,
      portfolioId: portfolioId ?? this.portfolioId,
      companyId: companyId ?? this.companyId,
      payDate: payDate ?? this.payDate,
      sharesAtPayDate: sharesAtPayDate ?? this.sharesAtPayDate,
      dividendPerShare: dividendPerShare ?? this.dividendPerShare,
      currencyCode: currencyCode ?? this.currencyCode,
      taxRate: taxRate ?? this.taxRate,
      netOverride: netOverride ?? this.netOverride,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'portfolioId': portfolioId,
    'companyId': companyId,
    'payDate': payDate.toIso8601String(),
    'sharesAtPayDate': sharesAtPayDate,
    'dividendPerShare': dividendPerShare,
    'currencyCode': currencyCode,
    'taxRate': taxRate,
    'netOverride': netOverride,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Dividend.fromJson(Map<String, dynamic> json) {
    return Dividend(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      companyId: json['companyId'] as String,
      payDate: DateTime.parse(json['payDate'] as String),
      sharesAtPayDate: (json['sharesAtPayDate'] as num).toDouble(),
      dividendPerShare: (json['dividendPerShare'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      taxRate: json['taxRate'] == null
          ? null
          : (json['taxRate'] as num).toDouble(),
      netOverride: json['netOverride'] == null
          ? null
          : (json['netOverride'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() =>
      'Dividend(companyId: $companyId, date: $payDate, net: $netAmount $currencyCode)';
}

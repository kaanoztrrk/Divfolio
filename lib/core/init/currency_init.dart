import '../../data/model/currency_model.dart';

class CurrencyDefaults {
  CurrencyDefaults._();

  static List<CurrencyModel> list = [
    CurrencyModel(code: 'USD', symbol: '\$', decimals: 2, name: 'US Dollar'),
    CurrencyModel(code: 'EUR', symbol: '€', decimals: 2, name: 'Euro'),
    CurrencyModel(code: 'TRY', symbol: '₺', decimals: 2, name: 'Turkish Lira'),
  ];
}

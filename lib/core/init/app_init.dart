import '../../data/model/company_model.dart';
import '../../data/model/currency_model.dart';
import '../../data/model/dividend_model.dart';
import '../../data/model/holding_model.dart';
import '../../data/model/portfolio_model.dart';
import '../../service/hive_manager.dart';
import '../enum/hive_box_enum.dart';

class AppInit {
  AppInit._();

  static Future<void> initHive() async {
    await HiveManager().init(
      adapters: [
        PortfolioModelAdapter(),
        HoldingModelAdapter(),
        DividendModelAdapter(),
        CompanyModelAdapter(),
        CurrencyModelAdapter(),
      ],
      boxes: HiveBoxKey.values.map((e) => e.name).toList(),
    );
  }
}

import 'package:ecinema_mobile/models/production.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';

class ProductionProvider extends BaseProvider<Production> {
  ProductionProvider() : super("Production");

  @override
  Production fromJson(data) {
    return Production.fromJson(data);
  }
}

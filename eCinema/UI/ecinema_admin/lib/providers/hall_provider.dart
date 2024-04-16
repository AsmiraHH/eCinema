import 'package:ecinema_admin/models/hall.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class HallProvider extends BaseProvider<Hall> {
  HallProvider() : super("Hall");

  @override
  Hall fromJson(data) {
    return Hall.fromJson(data);
  }
}

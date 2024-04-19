import 'package:ecinema_admin/models/show.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class ShowProvider extends BaseProvider<Show> {
  ShowProvider() : super("Show");

  @override
  Show fromJson(data) {
    return Show.fromJson(data);
  }
}

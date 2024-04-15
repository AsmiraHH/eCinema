import 'package:ecinema_admin/models/actor.dart';
import 'package:ecinema_admin/providers/base_provider.dart';

class ActorProvider extends BaseProvider<Actor> {
  ActorProvider() : super("Actor");

  @override
  Actor fromJson(data) {
    return Actor.fromJson(data);
  }
}

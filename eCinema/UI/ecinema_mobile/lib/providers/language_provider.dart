import 'package:ecinema_mobile/models/language.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';

class LanguageProvider extends BaseProvider<Language> {
  LanguageProvider() : super("Language");

  @override
  Language fromJson(data) {
    return Language.fromJson(data);
  }
}

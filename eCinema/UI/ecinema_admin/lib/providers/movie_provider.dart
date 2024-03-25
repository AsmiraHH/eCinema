import 'package:ecinema_admin/providers/base_provider.dart';
import '../models/movie.dart';

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super("Movie");

  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }
}

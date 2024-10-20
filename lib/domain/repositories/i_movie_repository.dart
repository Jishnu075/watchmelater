import 'package:watchmelater/data/models/movie_model.dart';

abstract class IMovieRepository {
  Future<void> addMovieToList({required Movie movie});

  Future<void> removeMovieFromList();
  Future<List<Movie>> getMovies();
}

import 'package:watchmelater/data/models/movie_model.dart';

abstract class IMovieRepository {
  Future<void> addMovieToList({required MovieStorage movie});

  Future<void> removeMovieFromList();
  Future<List<MovieStorage>> getMovies();

  String getMoviePosterUrl({required String posterPath});

  Future searchMoviesFromTMDB({required String movieName});
}

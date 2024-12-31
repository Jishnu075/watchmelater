import 'package:watchmelater/data/models/movie_model.dart';

abstract class IMovieRepository {
  Future<void> addMovieToList({required MovieStorage movie});

  Future<void> removeMovieFromList({required String movieId});
  Future<List<MovieStorage>> getMovies();

  String getMoviePosterUrl({required String posterPath});

  Future searchMoviesFromTMDB({required String movieName});

  Future<void> updateMovieStatus(
      {required String movieId, required bool watched});
}

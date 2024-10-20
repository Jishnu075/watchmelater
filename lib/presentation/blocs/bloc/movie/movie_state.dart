part of 'movie_bloc.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;
  MoviesLoaded(this.movies);
}

class MoviesLoadError extends MovieState {
  final String message;
  MoviesLoadError(this.message);
}

class MovieAdded extends MovieState {}

class MovieAddedFailure extends MovieState {
  final String message;
  MovieAddedFailure(this.message);
}

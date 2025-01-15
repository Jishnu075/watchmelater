part of 'movie_bloc.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MoviesLoaded extends MovieState {
  final List<MovieStorage> movies;
  MoviesLoaded(this.movies);
}

class MoviesLoadError extends MovieState {
  final ErrorType errorType;

  MoviesLoadError(this.errorType);
}

class MovieAdded extends MovieState {}

class MovieAddedFailure extends MovieState {
  final ErrorType errorType;
  String get message => errorType.message;
  IconData get icon => errorType.icon;
  Color get color => errorType.color;
  MovieAddedFailure(this.errorType);
}

class MovieRemoved extends MovieState {}

class MovieRemovalError extends MovieState {
  final ErrorType errorType;

  MovieRemovalError(this.errorType);
}

class MovieStatusUpdateError extends MovieState {
  final ErrorType errorType;

  MovieStatusUpdateError(this.errorType);
}

class MovieStatusUpdateSuccess extends MovieState {}

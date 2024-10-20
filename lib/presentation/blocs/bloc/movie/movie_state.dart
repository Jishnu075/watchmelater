part of 'movie_bloc.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MoviesLoading extends MovieState {}

class MoviesLoaded extends MovieState {}

class MoviesLoadError extends MovieState {
  final String errorMsg;
  MoviesLoadError(this.errorMsg);
}

class MovieAddedSuccess extends MovieState {}

class MovieAddedFailure extends MovieState {
  final String errorMsg;
  MovieAddedFailure(this.errorMsg);
}

part of 'search_bloc.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchingMovieLoading extends SearchState {}

class SearchingMovieCompleted extends SearchState {
  final List<MovieTMDB> movies;
  SearchingMovieCompleted(this.movies);
}

class SearchingMovieError extends SearchState {}

part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchMovieOnTMDB extends SearchEvent {
  final String movieName;

  SearchMovieOnTMDB({required this.movieName});
}

class ResetSearchBlocState extends SearchEvent {}

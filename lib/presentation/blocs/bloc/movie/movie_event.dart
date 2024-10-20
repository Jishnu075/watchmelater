part of 'movie_bloc.dart';

abstract class MovieEvent {}

class LoadMovies extends MovieEvent {}

class AddMovie extends MovieEvent {
  final Movie movie;

  AddMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

part of 'movie_bloc.dart';

abstract class MovieEvent {}

class LoadMoviesFromFirebase extends MovieEvent {}

class AddMovie extends MovieEvent {
  final MovieStorage movie;

  AddMovie(this.movie);

  @override
  List<Object> get props => [movie];
}

class UpdateMovieWatchStatus extends MovieEvent {
  final bool watched;
  final String id;
  UpdateMovieWatchStatus({required this.id, required this.watched});
}

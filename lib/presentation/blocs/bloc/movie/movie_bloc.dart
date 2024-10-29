import 'package:bloc/bloc.dart';
import 'package:watchmelater/data/models/movie_model.dart';
import 'package:watchmelater/data/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<AddMovie>((event, emit) async {
      emit(MovieLoading());
      try {
        await movieRepository.addMovieToList(movie: event.movie);
        emit(MovieAdded());
      } catch (e) {
        emit(MovieAddedFailure('Failed to add movie: ${e.toString()}'));
      }
    });

    on<LoadMoviesFromFirebase>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await movieRepository.getMovies();
        emit(MoviesLoaded(movies));
      } catch (e) {
        emit(MoviesLoadError('Failed to load movies: ${e.toString()}'));
      }
    });
  }
}

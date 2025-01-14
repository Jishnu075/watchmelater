import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/data/models/movie_tmdb_model.dart';
import 'package:watchmelater/data/repositories/movie_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository movieRepository;

  SearchBloc({required this.movieRepository}) : super(SearchInitial()) {
    on<SearchMovieOnTMDB>((event, emit) async {
      emit(SearchingMovieLoading());
      try {
        final List<MovieTMDB> moviesLoadedFromTMDB = await movieRepository
            .searchMoviesFromTMDB(movieName: event.movieName);
        emit(SearchingMovieCompleted(moviesLoadedFromTMDB));
      } catch (e) {
        emit(SearchingMovieError());
      }
    });

    on<ResetSearchBlocState>((event, emit) {
      emit(SearchInitial());
    });
  }
}

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:watchmelater/core/errors/error_types.dart';
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
        if (e is SocketException) {
          emit(MovieAddedFailure(ErrorType.network));
        } else if (e is TimeoutException) {
          emit(MovieAddedFailure(ErrorType.server));
        } else {
          emit(MovieAddedFailure(ErrorType.unknown));
        }
      }
    });

    on<LoadMoviesFromFirebase>((event, emit) async {
      emit(MovieLoading());
      try {
        final movies = await movieRepository.getMovies();
        emit(MoviesLoaded(movies));
      } catch (e) {
        if (e is SocketException) {
          emit(MoviesLoadError(ErrorType.network));
        } else if (e is TimeoutException) {
          emit(MoviesLoadError(ErrorType.server));
        } else {
          MoviesLoadError(ErrorType.unknown);
        }
      }
    });

    on<RemoveMovie>(
      (event, emit) async {
        emit(MovieLoading());
        try {
          await movieRepository.removeMovieFromList(movieId: event.id);
          emit(MovieRemoved());
        } catch (e) {
          if (e is SocketException) {
            emit(MovieRemovalError(ErrorType.network));
          } else if (e is TimeoutException) {
            emit(MovieRemovalError(ErrorType.server));
          } else {
            emit(MovieRemovalError(ErrorType.unknown));
          }
        }
      },
    );

    //TODO emit states better
    on<UpdateMovieWatchStatus>((event, emit) async {
      try {
        await movieRepository.updateMovieStatus(
            movieId: event.id, watched: event.watched);
        emit(MovieStatusUpdateSuccess());
      } catch (e) {
        if (e is SocketException) {
          emit(MovieStatusUpdateError(ErrorType.network));
        } else if (e is TimeoutException) {
          emit(MovieStatusUpdateError(ErrorType.server));
        } else {
          emit(MovieStatusUpdateError(ErrorType.unknown));
        }
      }
    });

    on<ResetMovieBloc>((event, emit) {
      emit(MovieInitial());
    });
  }
}

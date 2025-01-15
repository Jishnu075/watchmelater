import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:watchmelater/presentation/blocs/bloc/movie/movie_bloc.dart';
import 'package:watchmelater/presentation/common/error_view.dart';
import 'package:watchmelater/presentation/pages/watch_screen.dart';

class WatchedScreen extends StatelessWidget {
  const WatchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is MoviesLoaded) {
            final watchedMovies =
                state.movies.where((movie) => movie.isWatched == true);
            return watchedMovies.isEmpty
                ? const Center(child: Text('No watched movies yet!'))
                : RefreshIndicator.adaptive(
                    onRefresh: () async {
                      context.read<MovieBloc>().add(LoadMoviesFromFirebase());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        dragStartBehavior: DragStartBehavior.start,
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 2.8,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: watchedMovies.toList().reversed.map((movie) {
                          return MovieCard(
                            movie: movie,
                          );
                        }).toList(),
                      ),
                    ),
                  );
          } else if (state is MoviesLoadError) {
            return ErrorView(
                onRetry: () {
                  context.read<MovieBloc>().add(LoadMoviesFromFirebase());
                },
                icon: state.errorType.icon,
                iconColor: state.errorType.color,
                message: state.errorType.message);
          }
          return const Center(child: Text('No watched movies yet!'));
        },
      ),
    );
  }
}

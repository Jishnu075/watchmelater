import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:watchmelater/presentation/blocs/bloc/movie/movie_bloc.dart';
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
            return state.movies.isEmpty
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
                        children: state.movies
                            .where((movie) => movie.isWatched == true)
                            .toList()
                            .reversed
                            .map((movie) {
                          return MovieCard(
                            movie: movie,
                          );
                        }).toList(),
                      ),
                    ),
                  );
          } else if (state is MoviesLoadError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MovieBloc>().add(LoadMoviesFromFirebase()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No watched movies yet!'));
        },
      ),
    );
  }
}

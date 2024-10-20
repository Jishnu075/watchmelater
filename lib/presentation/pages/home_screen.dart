import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/data/models/movie_model.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/blocs/bloc/movie/movie_bloc.dart';
import 'package:watchmelater/presentation/pages/login_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                String movieName = '';
                return AlertDialog(
                  title: const Text('Add Movie'),
                  content: TextField(
                    onChanged: (value) {
                      movieName = value;
                    },
                    decoration:
                        const InputDecoration(hintText: "Enter movie name"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Add'),
                      onPressed: () {
                        if (movieName.isNotEmpty) {
                          context.read<MovieBloc>().add(AddMovie(Movie(
                              name: movieName,
                              isWatched: false,
                              movieImage: 'testURL')));
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(CupertinoIcons.add),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child:
              // Center(
              //   child: Text(user.displayName ?? "no name available"),
              // ),
              BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is MoviesLoaded) {
                return state.movies.isEmpty
                    ? Center(child: Text('No movies found. Add some!'))
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<MovieBloc>().add(LoadMovies());
                        },
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 2.8,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: state.movies
                              .map((movie) => MovieTile(
                                    name: movie.name,
                                    imageUrl: movie.movieImage,
                                  ))
                              .toList(),
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
                            context.read<MovieBloc>().add(LoadMovies()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is MovieAdded) {
                // Trigger a reload of movies after successful addition
                context.read<MovieBloc>().add(LoadMovies());
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              // Handle initial state
              return const Center(child: Text('Start by adding some movies!'));
            },
          ),
        ));
  }
}

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.name,
    required this.imageUrl,
  });
  final String name;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(name),
          ],
        ));
  }
}

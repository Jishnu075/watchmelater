import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchmelater/data/models/movie_model.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_event.dart';
import 'package:watchmelater/presentation/blocs/bloc/auth/auth_state.dart';
import 'package:watchmelater/presentation/blocs/bloc/movie/movie_bloc.dart';
import 'package:watchmelater/presentation/blocs/bloc/search/search_bloc.dart';
import 'package:watchmelater/presentation/pages/login_screen.dart';
import 'package:watchmelater/data/repositories/movie_repository.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen({super.key, required this.user});

  final TextEditingController searchMovieTextEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("WatchMeLater"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: const Text('logout'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMovieDialog(context: context);
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
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is MoviesLoaded) {
              return state.movies.isEmpty
                  ? Center(child: Text('No movies found. Add some!'))
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
                            children: state.movies.reversed
                                .map((movie) => MovieCard(
                                      name: movie.name,
                                      imageUrl: movie.movieImage ?? "",
                                    ))
                                .toList()),
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
                      onPressed: () => context
                          .read<MovieBloc>()
                          .add(LoadMoviesFromFirebase()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is MovieAdded) {
              // Trigger a reload of movies after successful addition
              context.read<MovieBloc>().add(LoadMoviesFromFirebase());
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            // Handle initial state
            return const Center(child: Text('Start by adding some movies!'));
          },
        ),
      ),
    );
  }

  void _showAddMovieDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String movieName = '';
        return AlertDialog(
          title: const Text('Add Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchMovieTextEC,
                onChanged: (value) {
                  _onSearchChanged(context, value);
                  movieName = value;
                },
                decoration: InputDecoration(
                  hintText: "Enter movie name",
                  // focusedBorder:
                  //     OutlineInputBorder(borderSide: BorderSide(width: 0.1)),
                  border:
                      OutlineInputBorder(borderSide: BorderSide(width: 0.1)),
                  suffixIcon: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchingMovieLoading) {
                        return const CircularProgressIndicator.adaptive();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchingMovieCompleted) {
                    if (state.movies.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    if (searchMovieTextEC.text.isNotEmpty) {
                                      if (movieName.isNotEmpty) {
                                        context
                                            .read<MovieBloc>()
                                            .add(AddMovie(MovieStorage(
                                              name: state.movies[index].title,
                                              isWatched: false,
                                              movieImage: state
                                                  .movies[index].posterPath!,
                                              releaseDate: state
                                                  .movies[index].releaseDate!,
                                            )));
                                        _resetMovieDialogState(context);
                                      }
                                    }
                                  },
                                  child: TMDBMovieTile(
                                    movieTitle: state.movies[index].title,
                                    movieThumbnailURL:
                                        state.movies[index].posterPath,
                                    yearOfRelease: getYearOfRelease(
                                        state.movies[index].releaseDate ?? ''),
                                  ));
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: state.movies.length,
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _resetMovieDialogState(context);
                }),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (movieName.isNotEmpty) {
                  context.read<MovieBloc>().add(AddMovie(MovieStorage(
                        name: movieName,
                        isWatched: false,
                        movieImage: null,
                        releaseDate: null,
                      )));
                  _resetMovieDialogState(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _resetMovieDialogState(BuildContext context) {
    searchMovieTextEC.clear();
    context.read<SearchBloc>().add(ResetMovieBlocState());
    Navigator.of(context).pop();
  }

  String getYearOfRelease(String releaseDate) {
    return releaseDate.split('-')[0];
  }

  String _searchQuery = '';
  Timer? _debounce;

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _searchQuery = query;
      // Use SearchBloc instead of MovieBloc
      context
          .read<SearchBloc>()
          .add(SearchMovieOnTMDB(movieName: _searchQuery));
    });
  }
}

//TODO rftr
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.name,
    required this.imageUrl,
  });
  final String name;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(20),
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl!,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/poster-not-available.jpg');
                            },
                          )
                        : Image.asset('assets/poster-not-available.jpg'))),
            Text(name),
          ],
        ));
  }
}

//TODO rftr
class TMDBMovieTile extends StatelessWidget {
  const TMDBMovieTile(
      {super.key,
      required this.movieThumbnailURL,
      required this.movieTitle,
      required this.yearOfRelease});

  final String? movieThumbnailURL;
  final String movieTitle;
  final String yearOfRelease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(203, 246, 236, 255),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
      width: MediaQuery.sizeOf(context).width * 0.75,
      height: MediaQuery.sizeOf(context).height * 0.0855,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.height * 0.0855,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: movieThumbnailURL != null
                              ? NetworkImage(
                                  movieThumbnailURL!,
                                )
                              : const AssetImage(
                                  'assets/poster-not-available.jpg')))),
            ),
          ),
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.calendar, size: 14),
                      const SizedBox(width: 5),
                      Text(yearOfRelease, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

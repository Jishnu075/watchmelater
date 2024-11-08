import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class WatchScreen extends StatelessWidget {
  // final User user;
  WatchScreen({
    super.key,
    // required this.user,
  });

  final TextEditingController searchMovieTextEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            print(state);
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is MoviesLoaded) {
              final toWatchMovies =
                  state.movies.where((movie) => movie.isWatched == false);
              return toWatchMovies.isEmpty
                  ? const Center(child: Text('No movies found. Add some!'))
                  : RefreshIndicator.adaptive(
                      onRefresh: () async {
                        if (shouldFetchMovies()) {
                          context
                              .read<MovieBloc>()
                              .add(LoadMoviesFromFirebase());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                            dragStartBehavior: DragStartBehavior.start,
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 2.8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children:
                                toWatchMovies.toList().reversed.map((movie) {
                              return MovieCard(
                                movie: movie,
                              );
                            }).toList()),
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
            } else if (state is MovieStatusUpdateSuccess) {
              context.read<MovieBloc>().add(LoadMoviesFromFirebase());
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is MovieStatusUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('something went wrong, try moving it later')));
            }
            // Handle initial state
            return const Center(child: Text('Start by adding some movies!'));
          },
        ),
      ),
    );
  }

  bool shouldFetchMovies() {
    // implement logic to determine if a fetch is necessary
    // For example, check if the last fetch was more than X minutes ago
    return true; // Placeholder
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
                                              id: '',
                                              name: state.movies[index].title,
                                              isWatched: false,
                                              movieImage: state
                                                  .movies[index].posterPath!,
                                              releaseDate: state
                                                  .movies[index].releaseDate!,
                                              addedOn: Timestamp.now(),
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
                        id: '',
                        addedOn: Timestamp.now(),
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

enum LongPressMenuItemValue { markAsWatched, moveToWatchlist, remove }

//TODO rftr
class MovieCard extends StatelessWidget {
  MovieCard(
      {super.key,
      // required this.name,
      // required this.imageUrl,
      required this.movie});

  // final String name;
  // final String? imageUrl;
  final MovieStorage movie;
  final TextEditingController editMovieNameEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) {
              //TODO add movie detail
              //rating, desc, title, sa
              return Container(
                height: 300,
                color: Colors.green,
              );
            });
      },
      onLongPressStart: (details) {
        //TODO: enable small haptic on longpress
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            details.globalPosition,
            details.globalPosition,
          ),
          Offset.zero & overlay.size,
        );
        showMenu(context: context, position: position, items: [
          PopupMenuItem(
              value: movie.isWatched
                  ? LongPressMenuItemValue.moveToWatchlist
                  : LongPressMenuItemValue.markAsWatched,
              child: ListTile(
                  title: movie.isWatched
                      ? Text("move to watchlist")
                      : Text('mark as watched'),
                  leading: movie.isWatched
                      ? Icon(Icons.keyboard_arrow_left)
                      : Icon(Icons.star_border))),
          const PopupMenuItem(
            value: LongPressMenuItemValue.remove,
            child: ListTile(
                title: Text("remove"),
                leading: Icon(Icons.delete_forever_outlined)),
          ),
        ]).then((value) async {
          print(value);
          if (value == LongPressMenuItemValue.markAsWatched) {
            context
                .read<MovieBloc>()
                .add(UpdateMovieWatchStatus(watched: true, id: movie.id));
          } else if (value == LongPressMenuItemValue.moveToWatchlist) {
            print('entered');
            context
                .read<MovieBloc>()
                .add(UpdateMovieWatchStatus(watched: false, id: movie.id));
          }
          // TODO : maybe edit stuff can be implemented later?
          // editMovieNameEC.text = movie.name;
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(title: Text("Edit"), actions: [
          //         TextField(
          //           controller: editMovieNameEC,
          //         ),
          //         TextButton(onPressed: () {}, child: const Text('save'))
          //       ]);
          //     });
          else if (value == LongPressMenuItemValue.remove) {
            //TODO fix async gap
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Are you sure?"),
                actions: [
                  TextButton(
                      child: Text('cancel'),
                      onPressed: () => Navigator.pop(context)),
                  TextButton(
                      child: Text('remove'),
                      onPressed: () {
                        //call firebase call to delete
                        // while delete process show progress if needed
                        // if firebase deletion success, delete the movie from the list as well.

                        //TODO: add removal sound effect later
                      }),
                ],
              ),
            );
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: movie.movieImage != null
                      ? Image.network(movie.movieImage!,
                          errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/poster-not-available.jpg');
                        })
                      : Image.asset('assets/poster-not-available.jpg'))),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.26,
            child: Text(
              movie.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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

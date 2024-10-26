import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watchmelater/data/datasources/movie_apiclient.dart';
import 'package:watchmelater/data/models/movie_model.dart';
import 'package:watchmelater/data/models/movie_tmdb_model.dart';
import 'package:watchmelater/domain/repositories/i_movie_repository.dart';

class MovieRepository implements IMovieRepository {
  final FirebaseFirestore firestore;

  MovieRepository({required this.firestore});

  @override
  Future<void> removeMovieFromList() {
    // TODO: implement removeMovieFromList
    throw UnimplementedError();
  }

  @override
  Future<void> addMovieToList({required MovieStorage movie}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'movies': FieldValue.arrayUnion([movie.toMap()])
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<List<MovieStorage>> getMovies() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await firestore.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      if (data != null && data['movies'] != null) {
        return (data['movies'] as List)
            .map((m) => MovieStorage.fromMap(m))
            .toList();
      }
    }
    return [];
  }

  @override
  String getMoviePosterUrl({required String posterPath}) {
    const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
    return imageBaseUrl + posterPath;
  }

  @override
  Future<List<MovieTMDB>> searchMoviesFromTMDB(
      {required String movieName}) async {
    try {
      final response = await MovieApiClient().searchMovies(movieName);
      final List<MovieTMDB> movies = response.map((movie) {
        return MovieTMDB(
          id: movie.id,
          title: movie.title,
          posterPath: movie.posterPath != null
              ? getMoviePosterUrl(posterPath: movie.posterPath!)
              : null,
          overview: movie.overview,
          releaseDate: movie.releaseDate,
        );
      }).toList();
      return movies;
    } catch (e) {
      return [];
    }
  }
}

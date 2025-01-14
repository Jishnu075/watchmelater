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
  Future<void> removeMovieFromList({required movieId}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef = firestore
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .doc(movieId);

        await docRef.delete();
      }
    } catch (e) {
      print("remove errror, $e");
    }
  }

  @override
  Future<void> addMovieToList({required MovieStorage movie}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference movieDocRef = firestore
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .doc();

        Map<String, dynamic> movieData = {
          'id': movieDocRef.id,
          ...movie.toMap()
        };

        await movieDocRef.set(movieData);
      }
    } catch (e) {
      // TODO: ahem fix it man
      print(e);
    }
  }

  @override
  Future<List<MovieStorage>> getMovies() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await firestore
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .orderBy('addedOn', descending: false)
            .get();

        return snapshot.docs.map((doc) {
          return MovieStorage.fromMap(doc.data());
        }).toList();

        // if (data != null && data['movies'] != null) {
        //   return (data['movies'] as List).map((m) {
        //     return MovieStorage.fromMap(m)..id = m['id'];
        //   }).toList();
        // }
      }
      return [];
    } catch (e) {
      rethrow;
    }
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

  @override
  Future<void> updateMovieStatus(
      {required String movieId, required bool watched}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("id - $movieId");
        final docRef = firestore
            .collection('users')
            .doc(user.uid)
            .collection('movies')
            .doc(movieId);

        await docRef.update({'isWatched': watched});
      }
    } catch (e) {
      print("object, $e");
    }
  }
}

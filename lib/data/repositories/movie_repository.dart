import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watchmelater/data/models/movie_model.dart';
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
  Future<void> addMovieToList({required Movie movie}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'movies': FieldValue.arrayUnion([movie.toMap()])
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<List<Movie>> getMovies() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await firestore.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      if (data != null && data['movies'] != null) {
        return (data['movies'] as List).map((m) => Movie.fromMap(m)).toList();
      }
    }
    return [];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MovieStorage {
  String id;
  String name;
  bool isWatched;
  String? movieImage;
  String? releaseDate;
  Timestamp addedOn;
  String? overview;
  MovieStorage({
    required this.id,
    required this.name,
    required this.isWatched,
    required this.movieImage,
    required this.releaseDate,
    required this.addedOn,
    required this.overview,
  });

  // Convert a Movie object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isWatched': isWatched,
      'movieImage': movieImage,
      'releaseDate': releaseDate,
      'addedOn': addedOn,
      'overview': overview,
    };
  }

  // Create a Movie object from a Firestore document
  factory MovieStorage.fromMap(Map<String, dynamic> map) {
    return MovieStorage(
      id: map['id'],
      name: map['name'],
      isWatched: map['isWatched'],
      movieImage: map['movieImage'],
      releaseDate: map['releaseDate'],
      addedOn: map['addedOn'],
      overview: map['overview'],
    );
  }
}

class MovieStorage {
  String name;
  bool isWatched;
  String? movieImage;
  String? releaseDate;
  MovieStorage({
    required this.name,
    required this.isWatched,
    required this.movieImage,
    required this.releaseDate,
  });

  // Convert a Movie object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isWatched': isWatched,
      'movieImage': movieImage,
      'releaseDate': releaseDate,
    };
  }

  // Create a Movie object from a Firestore document
  factory MovieStorage.fromMap(Map<String, dynamic> map) {
    return MovieStorage(
      name: map['name'],
      isWatched: map['isWatched'],
      movieImage: map['movieImage'],
      releaseDate: map['releaseDate'],
    );
  }
}

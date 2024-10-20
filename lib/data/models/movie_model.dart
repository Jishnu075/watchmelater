class Movie {
  String name;
  bool isWatched;
  String movieImage;

  Movie({
    required this.name,
    required this.isWatched,
    required this.movieImage,
  });

  // Convert a Movie object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isWatched': isWatched,
      'movieImage': movieImage,
    };
  }

  // Create a Movie object from a Firestore document
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      name: map['name'],
      isWatched: map['isWatched'],
      movieImage: map['movieImage'],
    );
  }
}

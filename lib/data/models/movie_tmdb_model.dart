class MovieTMDB {
  final int id;
  final String title;
  final String? posterPath;
  final String? overview;

  MovieTMDB({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
  });

  factory MovieTMDB.fromJson(Map<String, dynamic> json) {
    return MovieTMDB(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
    );
  }
}

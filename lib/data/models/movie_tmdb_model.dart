class MovieTMDB {
  final int id;
  final String title;
  final String? posterPath;
  final String? overview;
  final String? releaseDate;

  MovieTMDB({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
  });

  factory MovieTMDB.fromJson(Map<String, dynamic> json) {
    return MovieTMDB(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['release_date'],
    );
  }
}

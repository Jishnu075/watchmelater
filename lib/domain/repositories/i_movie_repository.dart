abstract class IMovieRepository {
  Future<void> addMovieToList();

  Future<void> removeMovieFromList();
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watchmelater/data/models/movie_tmdb_model.dart';

class MovieApiClient {
  static const baseTMDBUrl = "https://api.themoviedb.org/3";
  static var apiKEY = dotenv.env['TMDB_API_KEY'] ?? '';

  final Dio _dio;
  MovieApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: baseTMDBUrl,
          queryParameters: {'api_key': apiKEY},
          connectTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  Future<List<MovieTMDB>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'include_adult': false,
          'language': 'en-US',
          'page': 1,
        },
      );

      final results = List<Map<String, dynamic>>.from(response.data['results']);
      return results.map((json) => MovieTMDB.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}

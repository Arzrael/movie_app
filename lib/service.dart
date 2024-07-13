import 'package:dio/dio.dart';
import 'package:movie_app/model.dart';

class TMDBService {
  final String apiKey = '3a4cf77f1172796469c7cbfa15221b55';
  final String baseUrl = 'https://api.themoviedb.org/3/discover/movie';
  final String baseUrlFavMovies =
      'https://api.themoviedb.org/3/movie/top_rated';
  final Dio _dio = Dio();

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'api_key': apiKey,
      });

      if (response.statusCode == 200) {
        List<Movie> movies = (response.data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final response = await _dio.get(baseUrlFavMovies, queryParameters: {
        'api_key': apiKey,
      });

      if (response.statusCode == 200) {
        List<Movie> movies = (response.data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<List<Movie>> fetchMovieByGenre(id) async {
    try {
      final response = await _dio.get(
          "https://api.themoviedb.org/3/discover/movie?api_key=3a4cf77f1172796469c7cbfa15221b55&with_genres=$id");

      if (response.statusCode == 200) {
           List<Movie> movies = (response.data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}

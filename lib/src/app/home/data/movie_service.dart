import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = '1198fa26ce8e040bebfd86f3d5a7e37f'; // Replace with your API key
  final String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch movies for a specific page
  Future<List<dynamic>> getMovies(int page) async {
    final url = Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fetch cast details for a specific movie by movie ID
  Future<List<dynamic>> getCast(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Failed to load cast information');
    }
  }
  Future<List<dynamic>> searchMovies(String query, int page) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch search results');
    }
  }
}

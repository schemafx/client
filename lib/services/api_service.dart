import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://localhost:3000/api';

  Future<dynamic> _query(Future<http.Response> query) async {
    try {
      //return [];
      final response = await query;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed perform query. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle network errors or parsing errors
      throw Exception('Failed to perform query: $e');
    }
  }

  Future<dynamic> post(String path, Object body) => _query(
    http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ),
  );

  Future<dynamic> get(String path) => _query(
    http.get(
      Uri.parse('$_baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schemafx/services/secure_storage_service.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3000/api';
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _secureStorageService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _query(Future<http.Response> query) async {
    try {
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

  Future<dynamic> post(String path, Object body) async => _query(
    http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    ),
  );

  Future<dynamic> get(String path) async => _query(
    http.get(Uri.parse('$_baseUrl/$path'), headers: await _getHeaders()),
  );
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schemafx/services/secure_storage_service.dart';

class ApiService {
  final String _baseUrl = 'localhost:3000';
  final String _baseUrlPath = '/api';
  final String _baseUrlSchema = 'http';
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
          'Failed perform query. Status code: ${response.statusCode}. ${response.body}',
        );
      }
    } catch (e) {
      // Handle network errors or parsing errors
      throw Exception('Failed to perform query: $e');
    }
  }

  Future<dynamic> post(String path, Object body) async => _query(
    http.post(
      Uri.parse('$_baseUrlSchema://$_baseUrl$_baseUrlPath/$path'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    ),
  );

  Future<dynamic> get(String path, {Map<String, String>? query}) async =>
      _query(
        http.get(
          _baseUrlSchema == 'http'
              ? Uri.http(_baseUrl, '$_baseUrlPath/$path', query)
              : Uri.https(_baseUrl, '$_baseUrlPath/$path', query),
          headers: await _getHeaders(),
        ),
      );
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
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
        return _parseJson(response.body);
      } else {
        // Sanitize error messages to avoid leaking server internals
        String errorMessage =
            'Request failed with status: ${response.statusCode}';

        try {
          final errorData = await _parseJson(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
        } catch (_) {
          // If body isn't JSON or doesn't have a message, use the generic status message
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception && !e.toString().contains('XMLHttpRequest')) {
        rethrow;
      }
      throw Exception('A network error occurred. Please try again later.');
    }
  }

  /// Decodes JSON on a background isolate if the payload is large (>10KB)
  /// to prevent UI jank.
  Future<dynamic> _parseJson(String body) async {
    if (body.length > 10000) {
      return compute(jsonDecode, body);
    }
    return jsonDecode(body);
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

  Future<List<Map<String, dynamic>>> getConnectors() async =>
      List<Map<String, dynamic>>.from(await get('connectors'));

  Future<List<Map<String, dynamic>>> queryConnector(
    String connectorId,
    List<String> path, {
    String? connectionId,
  }) async => List<Map<String, dynamic>>.from(
    await post('connectors/$connectorId/query', {
      'path': path,
      if (connectionId != null) 'connectionId': connectionId,
    }),
  );

  Future<dynamic> addTable(
    String connectorName,
    List<String> path,
    String? appId, {
    String? connectionId,
  }) => post('connectors/$connectorName/table', {
    'path': path,
    if (appId != null) 'appId': appId,
    if (connectionId != null) 'connectionId': connectionId,
  });

  String getAuthUrl(String connectorName) =>
      '$_baseUrlSchema://$_baseUrl$_baseUrlPath/connectors/$connectorName/auth';
}

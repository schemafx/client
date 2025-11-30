import 'package:schemafx/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<String> login(String username, String password) async {
    final response = await _apiService.post('login', {
      'username': username,
      'password': password,
    });

    if (response != null && response['token'] != null) {
      return response['token'];
    } else {
      throw Exception('Invalid username or password');
    }
  }
}

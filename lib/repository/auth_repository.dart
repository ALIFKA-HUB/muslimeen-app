import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class AuthRepository {
  // Gunakan 'localhost' untuk Web/Windows, atau '10.0.2.2' jika pakai Emulator Android
  static const String _baseUrl = 'http://localhost:3000/api';

  /// Registers a new user. Returns the created [UserModel].
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
      }),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      return UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }
    throw Exception(json['message'] ?? 'Registration failed');
  }

  /// Logs in a user. Returns [UserModel] on success.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }
    throw Exception(json['message'] ?? 'Login failed');
  }
}

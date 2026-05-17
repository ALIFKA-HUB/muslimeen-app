import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../model/doa.dart';

class DoaRepository {
  static const String _baseUrl = 'https://doa-doa-api-ahmadramadhan.fly.dev/api';
  static const String _proxyUrl = 'http://localhost:3000/api/doa';

  /// Fetches all duas from the API.
  /// On web, routes through the local backend proxy to avoid CORS issues.
  Future<List<Doa>> fetchAllDoa() async {
    final url = kIsWeb ? _proxyUrl : _baseUrl;

    final uri = Uri.parse(url);
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Doa.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch duas: ${response.statusCode}');
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/surah.dart';

class QuranRepository {
  static const String _baseUrl = 'https://equran.id/api/v2';

  /// Fetches the list of all 114 surahs.
  Future<List<Surah>> fetchSurahList() async {
    final uri = Uri.parse('$_baseUrl/surat');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] == 200) {
        final data = json['data'] as List;
        return data
            .map((e) => Surah.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('API error: ${json['message']}');
    }
    throw Exception('Failed to fetch surah list: ${response.statusCode}');
  }

  /// Fetches the detail of a specific surah including its ayat.
  Future<SurahDetail> fetchSurahDetail(int nomorSurah) async {
    final uri = Uri.parse('$_baseUrl/surat/$nomorSurah');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['code'] == 200) {
        final data = json['data'] as Map<String, dynamic>;
        final surah = Surah.fromJson(data);
        final ayatList = (data['ayat'] as List?)
                ?.map((e) => Ayat.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return SurahDetail(surah: surah, ayat: ayatList);
      }
      throw Exception('API error: ${json['message']}');
    }
    throw Exception('Failed to fetch surah detail: ${response.statusCode}');
  }
}

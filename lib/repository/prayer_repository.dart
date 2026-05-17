import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/prayer_schedule.dart';

class PrayerRepository {
  static const String _baseUrl =
      'https://api.myquran.com/v2/sholat/jadwal/1206';

  /// Fetches monthly prayer schedule. [year] and [month] are optional,
  /// defaulting to the current date.
  Future<PrayerInfo> fetchMonthlySchedule({int? year, int? month}) async {
    final now = DateTime.now();
    final y = year ?? now.year;
    final m = month ?? now.month;

    final uri = Uri.parse('$_baseUrl/$y/$m');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] == true) {
        return PrayerInfo.fromJson(json);
      }
      throw Exception('API returned status false');
    }
    throw Exception(
        'Failed to fetch prayer schedule: ${response.statusCode}');
  }

  /// Convenience — gets today's prayer times from the monthly list.
  Future<DailyPrayer?> fetchTodayPrayer() async {
    final info = await fetchMonthlySchedule();
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    try {
      return info.jadwal.firstWhere((d) => d.date == todayStr);
    } catch (_) {
      return info.jadwal.isNotEmpty ? info.jadwal.first : null;
    }
  }
}

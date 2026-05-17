class PrayerInfo {
  final String lokasi;
  final String daerah;
  final List<DailyPrayer> jadwal;

  const PrayerInfo({
    required this.lokasi,
    required this.daerah,
    required this.jadwal,
  });

  factory PrayerInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PrayerInfo(
      lokasi: data['lokasi'] as String,
      daerah: data['daerah'] as String,
      jadwal: (data['jadwal'] as List)
          .map((e) => DailyPrayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DailyPrayer {
  final String tanggal;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String date;

  const DailyPrayer({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.date,
  });

  factory DailyPrayer.fromJson(Map<String, dynamic> json) {
    return DailyPrayer(
      tanggal: json['tanggal'] as String,
      imsak: json['imsak'] as String,
      subuh: json['subuh'] as String,
      terbit: json['terbit'] as String,
      dhuha: json['dhuha'] as String,
      dzuhur: json['dzuhur'] as String,
      ashar: json['ashar'] as String,
      maghrib: json['maghrib'] as String,
      isya: json['isya'] as String,
      date: json['date'] as String,
    );
  }

  /// Returns a map of prayer name → time (excluding imsak, terbit, dhuha)
  Map<String, String> get prayers => {
        'Subuh': subuh,
        'Dzuhur': dzuhur,
        'Ashar': ashar,
        'Maghrib': maghrib,
        'Isya': isya,
      };
}

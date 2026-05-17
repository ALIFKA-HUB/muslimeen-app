class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final AudioSurah? audio;

  const Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    this.audio,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String,
      audio: json['audioFull'] != null
          ? AudioSurah.fromJson(json['audioFull'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AudioSurah {
  final String? kemenag;
  final String? misyari;

  const AudioSurah({this.kemenag, this.misyari});

  factory AudioSurah.fromJson(Map<String, dynamic> json) {
    return AudioSurah(
      kemenag: json['01'] as String?,
      misyari: json['02'] as String?,
    );
  }
}

class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  const Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
    );
  }
}

class SurahDetail {
  final Surah surah;
  final List<Ayat> ayat;

  const SurahDetail({required this.surah, required this.ayat});
}

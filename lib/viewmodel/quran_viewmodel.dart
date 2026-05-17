import 'package:flutter/foundation.dart';
import '../model/surah.dart';
import '../repository/quran_repository.dart';

enum QuranState { initial, loading, loaded, error }

class QuranViewModel extends ChangeNotifier {
  final QuranRepository _repository;

  QuranViewModel({QuranRepository? repository})
      : _repository = repository ?? QuranRepository();

  QuranState _state = QuranState.initial;
  List<Surah> _surahList = [];
  SurahDetail? _selectedSurahDetail;
  String _searchQuery = '';
  String? _errorMessage;

  QuranState get state => _state;
  List<Surah> get surahList => _surahList;
  SurahDetail? get selectedSurahDetail => _selectedSurahDetail;
  String? get errorMessage => _errorMessage;

  List<Surah> get filteredSurahList {
    if (_searchQuery.isEmpty) return _surahList;
    final q = _searchQuery.toLowerCase();
    return _surahList
        .where((s) =>
            s.namaLatin.toLowerCase().contains(q) ||
            s.arti.toLowerCase().contains(q) ||
            s.nomor.toString().contains(q))
        .toList();
  }

  Future<void> loadSurahList() async {
    if (_surahList.isNotEmpty) return; // already loaded
    _state = QuranState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _surahList = await _repository.fetchSurahList();
      _state = QuranState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = QuranState.error;
    }
    notifyListeners();
  }

  Future<void> loadSurahDetail(int nomor) async {
    _selectedSurahDetail = null;
    _state = QuranState.loading;
    notifyListeners();

    try {
      _selectedSurahDetail = await _repository.fetchSurahDetail(nomor);
      _state = QuranState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = QuranState.error;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

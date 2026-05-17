import 'package:flutter/foundation.dart';
import '../model/doa.dart';
import '../repository/doa_repository.dart';

enum DoaState { initial, loading, loaded, error }

class DoaViewModel extends ChangeNotifier {
  final DoaRepository _repository;

  DoaViewModel({DoaRepository? repository})
      : _repository = repository ?? DoaRepository();

  DoaState _state = DoaState.initial;
  List<Doa> _doaList = [];
  String _searchQuery = '';
  String? _errorMessage;

  DoaState get state => _state;
  String? get errorMessage => _errorMessage;

  List<Doa> get filteredDoaList {
    if (_searchQuery.isEmpty) return _doaList;
    final q = _searchQuery.toLowerCase();
    return _doaList
        .where((d) =>
            d.doa.toLowerCase().contains(q) ||
            d.artinya.toLowerCase().contains(q))
        .toList();
  }

  Future<void> loadDoa() async {
    if (_doaList.isNotEmpty) return;
    _state = DoaState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _doaList = await _repository.fetchAllDoa();
      _state = DoaState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = DoaState.error;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

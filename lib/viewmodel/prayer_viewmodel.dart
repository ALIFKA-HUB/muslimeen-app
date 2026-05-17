import 'package:flutter/foundation.dart';
import '../model/prayer_schedule.dart';
import '../repository/prayer_repository.dart';

enum PrayerState { initial, loading, loaded, error }

class PrayerViewModel extends ChangeNotifier {
  final PrayerRepository _repository;

  PrayerViewModel({PrayerRepository? repository})
      : _repository = repository ?? PrayerRepository();

  PrayerState _state = PrayerState.initial;
  PrayerInfo? _prayerInfo;
  DailyPrayer? _todayPrayer;
  String? _errorMessage;

  PrayerState get state => _state;
  PrayerInfo? get prayerInfo => _prayerInfo;
  DailyPrayer? get todayPrayer => _todayPrayer;
  String? get errorMessage => _errorMessage;

  Future<void> loadTodayPrayer() async {
    _state = PrayerState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final info = await _repository.fetchMonthlySchedule();
      _prayerInfo = info;
      _todayPrayer = await _repository.fetchTodayPrayer();
      _state = PrayerState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = PrayerState.error;
    }
    notifyListeners();
  }
}

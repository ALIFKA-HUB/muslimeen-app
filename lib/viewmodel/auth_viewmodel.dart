import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/user.dart';
import '../repository/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  /// Load persisted user session on app start
  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>);
      _state = AuthState.authenticated;
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      await _saveSession(user);
      _currentUser = user;
      _state = AuthState.authenticated;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = AuthState.error;
    }
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(email: email, password: password);
      await _saveSession(user);
      _currentUser = user;
      _state = AuthState.authenticated;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = AuthState.error;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    _currentUser = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));
  }
}

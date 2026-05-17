import 'package:flutter/foundation.dart';
import '../services/gemini_service.dart';

enum ChatState { idle, thinking, error }

class ChatViewModel extends ChangeNotifier {
  final GeminiService _geminiService;

  ChatViewModel({GeminiService? geminiService})
      : _geminiService = geminiService ?? GeminiService();

  final List<ChatMessage> _messages = [];
  ChatState _state = ChatState.idle;
  String? _errorMessage;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  ChatState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isThinking => _state == ChatState.thinking;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _state = ChatState.thinking;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _geminiService.sendMessage(text.trim());
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _state = ChatState.idle;
    } catch (e) {
      _errorMessage = 'Gagal: ${e.toString()}';
      _messages.add(ChatMessage(
        text: '⚠️ Maaf, terjadi kesalahan:\n$_errorMessage',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _state = ChatState.error;
    }
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _geminiService.resetChat();
    _state = ChatState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}

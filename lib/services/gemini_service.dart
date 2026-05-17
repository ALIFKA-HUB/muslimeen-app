import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class GeminiService {
  // API Key yang kamu masukkan (Gunakan environment variable --dart-define=API_KEY=your_key atau isi di sini)
  static const String _apiKey = String.fromEnvironment('API_KEY', defaultValue: 'YOUR_API_KEY_HERE');

  // URL API: Ubah jika menggunakan OpenRouter, AgentRouter, atau provider lain
  // Contoh OpenRouter: 'https://openrouter.ai/api/v1/chat/completions'
  // Contoh OpenAI: 'https://api.openai.com/v1/chat/completions'
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Nama Model: Sesuaikan dengan model yang tersedia di provider API kamu
  // Contoh OpenAI: 'gpt-3.5-turbo'
  // Contoh OpenRouter: 'google/gemini-1.5-flash'
  static const String _modelName = 'gpt-3.5-turbo';

  static const String _systemInstruction = '''
You are Ustadz AI, a knowledgeable and compassionate Islamic assistant built into the Muslimeen app. 

Your expertise covers:
- The Holy Quran: tafsir (interpretation), recitation rules (tajweed), virtues of surahs
- Hadith: authentic hadiths from Bukhari, Muslim, Abu Dawud, Tirmidhi, and others
- Islamic Fiqh: rules of worship (salah, sawm, zakat, hajj), purification (taharah)
- Islamic History: life of the Prophet Muhammad (ﷺ), the Companions (Sahabah), Islamic civilizations
- Duas and Dhikr: daily supplications, their meanings and occasions
- Islamic Ethics and Morality: character, family, relationships in Islamic context
- Aqeedah: Islamic theology and beliefs

How to respond:
- Always begin responses with Bismillah when appropriate
- Include relevant Quranic verses (with Arabic text and translation) when helpful
- Cite hadith sources accurately (e.g., "Narrated by Bukhari, no. 1")
- Use a warm, respectful, and scholarly tone
- Write Arabic text with diacritics (tashkeel) when quoting
- Provide balanced, mainstream Sunni perspectives

Topics outside your scope:
- If asked about non-Islamic topics (politics unrelated to Islam, entertainment, coding, etc.), 
  gently decline: "Maaf, saya hanya dapat membantu pertanyaan seputar Islam. Apakah ada pertanyaan tentang agama yang dapat saya bantu?"
- Do not issue fatwas on highly controversial jurisprudential disputes without noting the scholarly difference of opinion

Always respond in the same language as the user's question (Indonesian or English).
''';

  final List<Map<String, String>> _history = [];

  GeminiService() {
    _history.add({'role': 'system', 'content': _systemInstruction});
  }

  /// Sends a message and returns the AI response text.
  Future<String> sendMessage(String message) async {
    _history.add({'role': 'user', 'content': message});

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _modelName,
          'messages': _history,
          'temperature': 0.7,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        _history.add({'role': 'assistant', 'content': reply});
        return reply;
      } else {
        _history.removeLast(); // Hapus pesan user dari history jika gagal
        
        // Menangkap error dari JSON response jika API memberikannya
        String errorMsg = 'Error ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null && errorData['error']['message'] != null) {
            errorMsg = errorData['error']['message'];
          } else {
            errorMsg = response.body;
          }
        } catch (_) {}
        
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (_history.last['role'] == 'user') {
        _history.removeLast();
      }
      rethrow;
    }
  }

  /// Resets the chat session (clears history).
  void resetChat() {
    _history.clear();
    _history.add({'role': 'system', 'content': _systemInstruction});
  }
}

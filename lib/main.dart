import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'viewmodel/prayer_viewmodel.dart';
import 'viewmodel/quran_viewmodel.dart';
import 'viewmodel/doa_viewmodel.dart';
import 'viewmodel/chat_viewmodel.dart';
import 'view/login_screen.dart';
import 'view/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuslimeenApp());
}

class MuslimeenApp extends StatelessWidget {
  const MuslimeenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PrayerViewModel()),
        ChangeNotifierProvider(create: (_) => QuranViewModel()),
        ChangeNotifierProvider(create: (_) => DoaViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: MaterialApp(
        title: 'Muslimeen',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _SplashGate(),
      ),
    );
  }
}

/// Determines whether to show Login or Home based on persisted session
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await context.read<AuthViewModel>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthViewModel>().state;

    return switch (authState) {
      AuthState.initial || AuthState.loading => _SplashScreen(),
      AuthState.authenticated => const HomeScreen(),
      _ => const LoginScreen(),
    };
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: const Center(
                child: Text('☪', style: TextStyle(fontSize: 52, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Text('Muslimeen', style: AppTheme.headlineLg),
            const SizedBox(height: 8),
            Text(
              'Your Complete Islamic Companion',
              style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

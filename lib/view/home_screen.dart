import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/prayer_viewmodel.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'quran_list_screen.dart';
import 'doa_screen.dart';
import 'chat_screen.dart';
import 'tasbih_screen.dart';
import 'hifz_tracker_screen.dart';
import 'qibla_screen.dart';
import 'profile_screen.dart';
import 'donation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    _HomeContent(),
    QuranListScreen(),
    DoaScreen(),
    ChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerViewModel>().loadTodayPrayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          border: const Border(top: BorderSide(color: AppTheme.outlineVariant, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB57E42).withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.outline,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Al-Quran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined),
              activeIcon: Icon(Icons.auto_stories),
              label: 'Doa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'AI Chat',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home Content Widget ──────────────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final prayerVM = context.watch<PrayerViewModel>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.pageMargin),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppTheme.radiusXl),
                  bottomRight: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assalamu\'alaikum,',
                            style: AppTheme.bodyMd.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.fullName ?? 'Saudara',
                            style: AppTheme.headlineMd.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        radius: 24,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  // Today's Date
                  _buildDateCard(),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingLg)),

          // Prayer Times Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.pageMargin),
              child: _PrayerTimesCard(prayerVM: prayerVM),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingLg)),

          // Quick Access Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.pageMargin),
              child: Text('Akses Cepat', style: AppTheme.headlineSm),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingMd)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.pageMargin),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.spacingMd,
              crossAxisSpacing: AppTheme.spacingMd,
              childAspectRatio: 1.4,
              children: [
                _QuickAccessCard(
                  icon: Icons.explore_outlined,
                  title: 'Arah Kiblat',
                  color: const Color(0xFF6B9E6E),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QiblaScreen())),
                ),
                _QuickAccessCard(
                  icon: Icons.fingerprint,
                  title: 'Tasbih',
                  color: const Color(0xFF9B6B9B),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TasbihScreen())),
                ),
                _QuickAccessCard(
                  icon: Icons.track_changes,
                  title: 'Hifz Tracker',
                  color: const Color(0xFF9B8B6B),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HifzTrackerScreen())),
                ),
                _QuickAccessCard(
                  icon: Icons.volunteer_activism_outlined,
                  title: 'Donasi',
                  color: const Color(0xFF6B8B9B),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DonationScreen())),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingXl)),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    final now = DateTime.now();
    final days = ['Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'];
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Ags','Sep','Okt','Nov','Des'];
    final dayName = days[now.weekday - 1];
    final dateStr = '$dayName, ${now.day} ${months[now.month - 1]} ${now.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(dateStr,
              style: AppTheme.bodyMd.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _PrayerTimesCard extends StatelessWidget {
  final PrayerViewModel prayerVM;
  const _PrayerTimesCard({required this.prayerVM});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jadwal Shalat Hari Ini', style: AppTheme.headlineSm),
              if (prayerVM.state == PrayerState.loading)
                const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
                ),
            ],
          ),
          if (prayerVM.prayerInfo != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                prayerVM.prayerInfo!.lokasi,
                style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant),
              ),
            ),
          const SizedBox(height: AppTheme.spacingMd),
          if (prayerVM.state == PrayerState.error)
            Center(child: Text(
              'Gagal memuat jadwal shalat',
              style: AppTheme.bodyMd.copyWith(color: AppTheme.error),
            ))
          else if (prayerVM.todayPrayer != null)
            ...prayerVM.todayPrayer!.prayers.entries.map(
              (e) => _PrayerRow(name: e.key, time: e.value),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  const _PrayerRow({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(name, style: AppTheme.bodyMd),
          ]),
          Text(time,
              style: AppTheme.labelLg.copyWith(color: AppTheme.primary)),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title,
                style: AppTheme.labelMd.copyWith(color: color),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

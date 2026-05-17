import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/quran_viewmodel.dart';
import '../model/surah.dart';
import 'quran_reading_screen.dart';

class QuranListScreen extends StatefulWidget {
  const QuranListScreen({super.key});

  @override
  State<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends State<QuranListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().loadSurahList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Al-Quran'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => context.read<QuranViewModel>().setSearchQuery(v),
              decoration: InputDecoration(
                hintText: 'Cari surah...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<QuranViewModel>().setSearchQuery('');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
      ),
      body: switch (vm.state) {
        QuranState.loading => const Center(
            child: CircularProgressIndicator(color: AppTheme.primary)),
        QuranState.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                const SizedBox(height: 16),
                Text('Gagal memuat data Al-Quran',
                    style: AppTheme.bodyLg.copyWith(color: AppTheme.error)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<QuranViewModel>().loadSurahList(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        _ => ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vm.filteredSurahList.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1, indent: 72, endIndent: 16,
              color: AppTheme.outlineVariant,
            ),
            itemBuilder: (_, i) => _SurahTile(surah: vm.filteredSurahList[i]),
          ),
      },
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Surah surah;
  const _SurahTile({required this.surah});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Center(
          child: Text(
            surah.nomor.toString(),
            style: AppTheme.labelLg.copyWith(color: AppTheme.primary),
          ),
        ),
      ),
      title: Text(surah.namaLatin, style: AppTheme.labelLg),
      subtitle: Text(
        '${surah.tempatTurun} • ${surah.jumlahAyat} Ayat',
        style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant),
      ),
      trailing: Text(
        surah.nama,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'serif',
          color: AppTheme.primary,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranReadingScreen(surah: surah),
        ),
      ),
    );
  }
}

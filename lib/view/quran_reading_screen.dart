import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/quran_viewmodel.dart';
import '../model/surah.dart';

class QuranReadingScreen extends StatefulWidget {
  final Surah surah;
  const QuranReadingScreen({super.key, required this.surah});

  @override
  State<QuranReadingScreen> createState() => _QuranReadingScreenState();
}

class _QuranReadingScreenState extends State<QuranReadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().loadSurahDetail(widget.surah.nomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.surah.namaLatin),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showSurahInfo(context, widget.surah),
          ),
        ],
      ),
      body: switch (vm.state) {
        QuranState.loading => const Center(
            child: CircularProgressIndicator(color: AppTheme.primary)),
        QuranState.error => Center(
            child: Text('Gagal memuat surah',
                style: AppTheme.bodyLg.copyWith(color: AppTheme.error))),
        _ => vm.selectedSurahDetail == null
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : ListView.builder(
                padding: const EdgeInsets.all(AppTheme.pageMargin),
                itemCount: vm.selectedSurahDetail!.ayat.length + 1,
                itemBuilder: (_, i) {
                  if (i == 0) return _buildBismillah();
                  final ayat = vm.selectedSurahDetail!.ayat[i - 1];
                  return _AyatCard(ayat: ayat);
                },
              ),
      },
    );
  }

  Widget _buildBismillah() {
    // Al-Fatihah (1) and At-Taubah (9) don't show Bismillah separately
    if (widget.surah.nomor == 9) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: const Center(
        child: Text(
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'serif',
            color: AppTheme.primary,
            height: 2,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  void _showSurahInfo(BuildContext context, Surah s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      backgroundColor: AppTheme.surfaceContainerLowest,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppTheme.pageMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(s.namaLatin, style: AppTheme.headlineMd),
            const SizedBox(height: 4),
            Text('${s.nama} — ${s.arti}',
                style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(
              '${s.tempatTurun} • ${s.jumlahAyat} Ayat',
              style: AppTheme.labelMd.copyWith(color: AppTheme.primary),
            ),
            const SizedBox(height: 12),
            Text(s.deskripsi.replaceAll(RegExp(r'<[^>]*>'), ''),
                style: AppTheme.bodyMd),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AyatCard extends StatelessWidget {
  final Ayat ayat;
  const _AyatCard({required this.ayat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayat number badge
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    ayat.nomorAyat.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // Arabic text
          Text(
            ayat.teksArab,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'serif',
              height: 2.2,
              color: AppTheme.onSurface,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: 8),

          // Latin transliteration
          Text(
            ayat.teksLatin,
            style: AppTheme.bodyMd.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),

          // Translation
          Text(
            ayat.teksIndonesia,
            style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurface),
          ),
        ],
      ),
    );
  }
}

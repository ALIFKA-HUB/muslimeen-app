import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class HifzTrackerScreen extends StatefulWidget {
  const HifzTrackerScreen({super.key});

  @override
  State<HifzTrackerScreen> createState() => _HifzTrackerScreenState();
}

class _HifzTrackerScreenState extends State<HifzTrackerScreen> {
  // Simple local state for demo — replace with backend integration
  final List<Map<String, dynamic>> _progress = [
    {'surah': 'Al-Fatihah', 'ayat': 7, 'memorized': 7},
    {'surah': 'Al-Ikhlas', 'ayat': 4, 'memorized': 4},
    {'surah': 'Al-Falaq', 'ayat': 5, 'memorized': 5},
    {'surah': 'An-Nas', 'ayat': 6, 'memorized': 3},
    {'surah': 'Al-Kafirun', 'ayat': 6, 'memorized': 2},
    {'surah': 'Al-Mulk', 'ayat': 30, 'memorized': 10},
  ];

  void _showAddDialog() {
    final surahCtrl = TextEditingController();
    final ayatCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
        title: const Text('Tambah Surah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: surahCtrl,
              decoration: const InputDecoration(labelText: 'Nama Surah'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ayatCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Ayat Total'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final ayat = int.tryParse(ayatCtrl.text) ?? 0;
              if (surahCtrl.text.isNotEmpty && ayat > 0) {
                setState(() {
                  _progress.add({
                    'surah': surahCtrl.text,
                    'ayat': ayat,
                    'memorized': 0,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMemorized = _progress.fold<int>(
        0, (sum, s) => sum + (s['memorized'] as int));
    final totalAyat = _progress.fold<int>(
        0, (sum, s) => sum + (s['ayat'] as int));

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Hifz Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Surah'),
      ),
      body: CustomScrollView(
        slivers: [
          // Summary card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.pageMargin),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Progress Hafalan',
                              style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          Text(
                            '$totalMemorized / $totalAyat Ayat',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: totalAyat > 0 ? totalMemorized / totalAyat : 0,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text(
                          '${_progress.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text('Surah',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Surah list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.pageMargin),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _SurahProgressCard(
                  data: _progress[i],
                  onUpdate: (memorized) {
                    setState(() => _progress[i]['memorized'] = memorized);
                  },
                ),
                childCount: _progress.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _SurahProgressCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final ValueChanged<int> onUpdate;

  const _SurahProgressCard({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final memorized = data['memorized'] as int;
    final total = data['ayat'] as int;
    final pct = total > 0 ? memorized / total : 0.0;
    final completed = memorized >= total;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
        border: completed
            ? Border.all(color: AppTheme.primary.withOpacity(0.4))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['surah'] as String, style: AppTheme.labelLg),
                    Text('$memorized / $total ayat dihapal',
                        style: AppTheme.labelMd
                            .copyWith(color: AppTheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (completed)
                const Icon(Icons.verified, color: AppTheme.primary)
              else
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppTheme.primary),
                  onPressed: memorized < total
                      ? () => onUpdate(memorized + 1)
                      : null,
                  tooltip: 'Tambah ayat',
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.outlineVariant,
              valueColor: AlwaysStoppedAnimation(
                  completed ? AppTheme.primary : AppTheme.primaryContainer),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text('${(pct * 100).toStringAsFixed(0)}% selesai',
              style: AppTheme.labelMd.copyWith(
                  color: completed ? AppTheme.primary : AppTheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

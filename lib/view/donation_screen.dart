import 'package:flutter/material.dart';
import '../core/theme.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  static const List<Map<String, dynamic>> _charities = [
    {
      'name': 'Zakat Fitrah',
      'desc': 'Wajib bagi setiap Muslim saat Ramadan',
      'icon': Icons.volunteer_activism,
      'target': 50000000,
      'collected': 32000000,
    },
    {
      'name': 'Sedekah Jariyah',
      'desc': 'Infak untuk pembangunan masjid dan pesantren',
      'icon': Icons.mosque_outlined,
      'target': 200000000,
      'collected': 87500000,
    },
    {
      'name': 'Wakaf Al-Quran',
      'desc': 'Menyediakan mushaf untuk yang membutuhkan',
      'icon': Icons.menu_book_outlined,
      'target': 30000000,
      'collected': 28000000,
    },
    {
      'name': 'Bantuan Yatim',
      'desc': 'Santunan untuk anak yatim piatu',
      'icon': Icons.child_care_outlined,
      'target': 100000000,
      'collected': 45000000,
    },
  ];

  String _formatRp(int amount) {
    final str = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Donasi & Amal')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.pageMargin),
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '﴾ وَمَا تُنفِقُوا مِنْ خَيْرٍ فَلِأَنفُسِكُمْ ﴿',
                  style: TextStyle(
                    fontSize: 18, color: Colors.white,
                    fontFamily: 'serif', height: 1.8,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Text(
                  '"Dan apa yang kamu infakkan adalah untuk kebaikan dirimu sendiri."',
                  style: AppTheme.bodyMd.copyWith(
                      color: Colors.white70, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 4),
                Text('— QS. Al-Baqarah: 272',
                    style: AppTheme.labelMd.copyWith(color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text('Program Amal', style: AppTheme.headlineSm),
          const SizedBox(height: AppTheme.spacingMd),

          ..._charities.map((c) => _CharityCard(
            data: c,
            formatRp: _formatRp,
          )),
        ],
      ),
    );
  }
}

class _CharityCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String Function(int) formatRp;

  const _CharityCard({required this.data, required this.formatRp});

  @override
  Widget build(BuildContext context) {
    final collected = data['collected'] as int;
    final target = data['target'] as int;
    final pct = collected / target;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
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
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(data['icon'] as IconData, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name'] as String, style: AppTheme.labelLg),
                    Text(data['desc'] as String,
                        style: AppTheme.labelMd
                            .copyWith(color: AppTheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatRp(collected),
                  style: AppTheme.labelLg.copyWith(color: AppTheme.primary)),
              Text('${(pct * 100).toStringAsFixed(0)}%',
                  style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.outlineVariant,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text('Target: ${formatRp(target)}',
              style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fitur donasi segera hadir! JazakAllahu khairan 🌙'),
                  backgroundColor: AppTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              child: const Text('Donasi Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}

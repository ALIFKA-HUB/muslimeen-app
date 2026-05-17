import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final user = vm.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.pageMargin),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                ),
                shape: BoxShape.circle,
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Center(
                child: Text(
                  user?.fullName.isNotEmpty == true
                      ? user!.fullName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.fullName ?? 'Pengguna', style: AppTheme.headlineMd),
            Text(
              user?.email ?? '',
              style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),

            // Info card
            _InfoCard(
              title: 'Informasi Akun',
              items: [
                _InfoItem(icon: Icons.person_outline, label: 'Nama', value: user?.fullName ?? '-'),
                _InfoItem(icon: Icons.email_outlined, label: 'Email', value: user?.email ?? '-'),
                _InfoItem(icon: Icons.shield_outlined, label: 'Peran', value: user?.role ?? '-'),
              ],
            ),
            const SizedBox(height: 16),

            _InfoCard(
              title: 'Tentang Aplikasi',
              items: [
                _InfoItem(icon: Icons.info_outline, label: 'Versi', value: '1.0.0'),
                _InfoItem(icon: Icons.code, label: 'Developer', value: 'Muslimeen Team'),
                _InfoItem(icon: Icons.api, label: 'AI Model', value: 'Gemini 1.5 Flash'),
              ],
            ),
            const SizedBox(height: 32),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthViewModel>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: AppTheme.error),
                label: const Text('Keluar', style: TextStyle(color: AppTheme.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.headlineSm),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(item.icon, color: AppTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(item.label,
                    style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant))),
                Text(item.value, style: AppTheme.labelLg),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.label, required this.value});
}

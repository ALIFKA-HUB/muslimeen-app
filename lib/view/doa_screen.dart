import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/doa_viewmodel.dart';
import '../model/doa.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaViewModel>().loadDoa();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Doa Sehari-hari'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => context.read<DoaViewModel>().setSearchQuery(v),
              decoration: InputDecoration(
                hintText: 'Cari doa...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<DoaViewModel>().setSearchQuery('');
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
        DoaState.loading => const Center(
            child: CircularProgressIndicator(color: AppTheme.primary)),
        DoaState.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                const SizedBox(height: 16),
                Text('Gagal memuat doa',
                    style: AppTheme.bodyLg.copyWith(color: AppTheme.error)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DoaViewModel>().loadDoa(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        _ => vm.filteredDoaList.isEmpty
            ? Center(
                child: Text('Tidak ada hasil untuk pencarian Anda',
                    style: AppTheme.bodyMd
                        .copyWith(color: AppTheme.onSurfaceVariant)))
            : ListView.builder(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                itemCount: vm.filteredDoaList.length,
                itemBuilder: (_, i) => _DoaCard(doa: vm.filteredDoaList[i]),
              ),
      },
    );
  }
}

class _DoaCard extends StatefulWidget {
  final Doa doa;
  const _DoaCard({required this.doa});

  @override
  State<_DoaCard> createState() => _DoaCardState();
}

class _DoaCardState extends State<_DoaCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Center(
              child: Text(
                widget.doa.id,
                style: AppTheme.labelMd.copyWith(color: AppTheme.primary),
              ),
            ),
          ),
          title: Text(widget.doa.doa, style: AppTheme.labelLg),
          children: [
            // Arabic
            Text(
              widget.doa.ayat,
              style: const TextStyle(
                fontSize: 22, fontFamily: 'serif',
                height: 2, color: AppTheme.primary,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            // Latin
            Text(widget.doa.latin,
                style: AppTheme.bodyMd.copyWith(fontStyle: FontStyle.italic,
                    color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            // Meaning
            Text(widget.doa.artinya, style: AppTheme.bodyMd),
          ],
        ),
      ),
    );
  }
}

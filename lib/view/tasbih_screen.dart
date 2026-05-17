import 'package:flutter/material.dart';
import '../core/theme.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _target = 33;
  int _round = 1;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  final List<Map<String, String>> _dhikrList = [
    {'arabic': 'سُبْحَانَ اللَّهِ', 'latin': 'Subhanallah', 'meaning': 'Maha Suci Allah'},
    {'arabic': 'الْحَمْدُ لِلَّهِ', 'latin': 'Alhamdulillah', 'meaning': 'Segala Puji bagi Allah'},
    {'arabic': 'اللَّهُ أَكْبَرُ', 'latin': 'Allahu Akbar', 'meaning': 'Allah Maha Besar'},
    {'arabic': 'لَا إِلَهَ إِلَّا اللَّهُ', 'latin': 'Laa ilaaha illallah', 'meaning': 'Tiada Tuhan selain Allah'},
  ];

  int _selectedDhikr = 0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _increment() {
    _animCtrl.forward().then((_) => _animCtrl.reverse());
    setState(() {
      _count++;
      if (_count >= _target) {
        _round++;
        _count = 0;
        _showRoundComplete();
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _round = 1;
    });
  }

  void _showRoundComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'MasyaAllah! Putaran ${_round - 1} selesai 🌙',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = _dhikrList[_selectedDhikr];
    final progress = _count / _target;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tasbih Digital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          // Dhikr selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dhikrList.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_dhikrList[i]['latin']!),
                  selected: _selectedDhikr == i,
                  onSelected: (_) => setState(() {
                    _selectedDhikr = i;
                    _count = 0;
                    _round = 1;
                  }),
                  selectedColor: AppTheme.primary,
                  labelStyle: AppTheme.labelMd.copyWith(
                    color: _selectedDhikr == i
                        ? Colors.white
                        : AppTheme.onSurface,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Arabic text
                Text(
                  dhikr['arabic']!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontFamily: 'serif',
                    color: AppTheme.primary,
                    height: 1.8,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                Text(
                  dhikr['latin']!,
                  style: AppTheme.headlineSm.copyWith(
                      color: AppTheme.onSurfaceVariant),
                ),
                Text(dhikr['meaning']!,
                    style: AppTheme.bodyMd
                        .copyWith(color: AppTheme.onSurfaceVariant)),

                const SizedBox(height: 48),

                // Progress ring + counter button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220, height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: AppTheme.outlineVariant,
                        color: AppTheme.primary,
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: GestureDetector(
                        onTap: _increment,
                        child: Container(
                          width: 180, height: 180,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppTheme.primary, AppTheme.primaryContainer],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _count.toString(),
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'dari $_target',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Text(
                  'Putaran ke-$_round',
                  style: AppTheme.bodyMd
                      .copyWith(color: AppTheme.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // Target selector
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Target: ', style: AppTheme.bodyMd),
                ...[33, 99, 100].map((t) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ActionChip(
                    label: Text('$t'),
                    backgroundColor: _target == t
                        ? AppTheme.primary.withOpacity(0.15)
                        : null,
                    side: BorderSide(
                        color: _target == t
                            ? AppTheme.primary
                            : AppTheme.outlineVariant),
                    labelStyle: AppTheme.labelMd.copyWith(
                        color: _target == t
                            ? AppTheme.primary
                            : AppTheme.onSurface),
                    onPressed: () => setState(() {
                      _target = t;
                      _count = 0;
                    }),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import '../core/theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  // Approximate Qibla direction for Indonesia (West-Northwest)
  static const double _qiblaBearing = 295.0;

  // Animation controller for demo mode (no sensor)
  late AnimationController _demoController;
  late Animation<double> _demoAnimation;

  @override
  void initState() {
    super.initState();
    // Slow continuous rotation for demo mode
    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _demoAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_demoController);
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Arah Kiblat')),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildDemoCompass(
              errorMsg: 'Terjadi kesalahan sensor kompas',
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildDemoCompass();
          }

          final double? direction = snapshot.data?.heading;

          // No sensor — show animated demo compass
          if (direction == null) {
            return _buildDemoCompass();
          }

          // Real sensor available
          return _buildRealCompass(direction);
        },
      ),
    );
  }

  // ── Demo mode: animated spinning compass ────────────────────────────────────
  Widget _buildDemoCompass({String? errorMsg}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Demo badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mode Tampilan — kompas berputar karena tidak ada sensor di perangkat ini.',
                    style: AppTheme.bodyMd
                        .copyWith(color: AppTheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Animated compass
          AnimatedBuilder(
            animation: _demoAnimation,
            builder: (context, child) {
              return _buildCompassWidget(
                compassAngle: _demoAnimation.value,
                qiblaAngle: _qiblaBearing * (math.pi / 180),
                isDemo: true,
              );
            },
          ),

          const SizedBox(height: 40),
          Text('Ka\'bah, Makkah', style: AppTheme.headlineSm),
          const SizedBox(height: 8),
          Text(
            'Arah Kiblat: ${_qiblaBearing.toStringAsFixed(0)}° dari Utara',
            style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Demo label
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.motion_photos_on,
                    color: Colors.orange, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Mode Demo — Kompas Berputar',
                  style:
                      AppTheme.labelMd.copyWith(color: Colors.orange),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _buildSensorNote(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Real sensor mode ────────────────────────────────────────────────────────
  Widget _buildRealCompass(double direction) {
    final compassAngle = -(direction * math.pi / 180);
    final qiblaAngle = (_qiblaBearing - direction) * (math.pi / 180);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pegang HP secara mendatar. Jauhkan dari benda logam atau magnet untuk akurasi terbaik.',
                    style: AppTheme.bodyMd
                        .copyWith(color: AppTheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          _buildCompassWidget(
            compassAngle: compassAngle,
            qiblaAngle: qiblaAngle,
            isDemo: false,
          ),

          const SizedBox(height: 40),
          Text('Ka\'bah, Makkah', style: AppTheme.headlineSm),
          const SizedBox(height: 8),
          Text(
            'Arah: ${_qiblaBearing.toStringAsFixed(0)}° (dari Utara)',
            style:
                AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore, color: AppTheme.primary, size: 16),
                const SizedBox(width: 6),
                Text('Sensor Aktif',
                    style:
                        AppTheme.labelMd.copyWith(color: AppTheme.primary)),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _buildSensorNote(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Shared compass widget ────────────────────────────────────────────────────
  Widget _buildCompassWidget({
    required double compassAngle,
    required double qiblaAngle,
    required bool isDemo,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Compass rose
        Transform.rotate(
          angle: compassAngle,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceContainerLowest,
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: CustomPaint(painter: _CompassRosePainter()),
          ),
        ),

        // Qibla pointer
        Transform.rotate(
          angle: qiblaAngle,
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(painter: _QiblaPointerPainter()),
          ),
        ),

        // Center dot
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // ── Bottom notice about sensor & calibration ─────────────────────────────────
  Widget _buildSensorNote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.sensors, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Informasi Sensor Kompas',
                style: AppTheme.labelLg
                    .copyWith(color: AppTheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '• Fitur arah kiblat berfungsi optimal pada perangkat yang memiliki sensor kompas (magnetometer), seperti smartphone.\n\n'
            '• Laptop dan komputer umumnya tidak memiliki sensor kompas, sehingga kompas berputar secara demo.\n\n'
            '• Jika menggunakan smartphone, lakukan kalibrasi kompas terlebih dahulu dengan menggerakkan perangkat membentuk angka 8 di udara sebelum menggunakan fitur ini.',
            style: AppTheme.bodyMd
                .copyWith(color: AppTheme.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 10;
    final paint = Paint()
      ..color = AppTheme.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(cx, cy), r, paint);

    for (int i = 0; i < 360; i += 5) {
      final rad = i * math.pi / 180;
      final bool isMajor = i % 30 == 0;
      final bool isCardinal = i % 90 == 0;
      final inner = isCardinal ? r - 25 : (isMajor ? r - 15 : r - 8);

      canvas.drawLine(
        Offset(cx + inner * math.sin(rad), cy - inner * math.cos(rad)),
        Offset(cx + r * math.sin(rad), cy - r * math.cos(rad)),
        paint..strokeWidth = isCardinal ? 3 : (isMajor ? 1.5 : 0.8),
      );
    }

    const dirs = ['U', 'T', 'S', 'B'];
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 4; i++) {
      final rad = i * math.pi / 2;
      tp.text = TextSpan(
        text: dirs[i],
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: i == 0 ? AppTheme.primary : AppTheme.onSurfaceVariant,
        ),
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          cx + (r - 45) * math.sin(rad) - tp.width / 2,
          cy - (r - 45) * math.cos(rad) - tp.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QiblaPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 30;

    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final tip = Offset(cx, cy - r);
    final left = Offset(cx - 15, cy - r + 35);
    final right = Offset(cx + 15, cy - r + 35);

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(tip, 6, Paint()..color = AppTheme.primary);
  }

  @override
  bool shouldRepaint(_) => false;
}

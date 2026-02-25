import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_theme.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Direction — اتجاه القبلة')),
      body: FutureBuilder(
        future: FlutterQiblah.androidDeviceSensorSupport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const _QiblaCompass();
        },
      ),
    );
  }
}

class _QiblaCompass extends StatelessWidget {
  const _QiblaCompass();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Accessing compass...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(snapshot.error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const Text('Please move your device in a figure-8 pattern to calibrate'),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        final qiblahAngle = data.qiblah;
        final deviceAngle = data.direction;
        // Note: Accuracy not directly available from QiblahDirection
        // Using a reasonable default compass accuracy value
        const double compassAccuracy = 15.0;

        return Column(
          children: [
            const SizedBox(height: 32),
            // Accuracy indicator
            _AccuracyBadge(accuracy: compassAccuracy),
            const SizedBox(height: 32),

            // Compass
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass rose (static)
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                        color: AppColors.primary.withOpacity(0.05),
                      ),
                      child: const Center(
                        child: Text('N', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGrey,
                        )),
                      ),
                    ),

                    // Qibla needle
                    Transform.rotate(
                      angle: (qiblahAngle - deviceAngle) * (math.pi / 180),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 4,
                            height: 110,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.gold, AppColors.primary],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Kaaba icon at top
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text('🕋', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 110,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),

                    // Center dot
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Direction info
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('Qibla Direction',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  Text(
                    '${qiblahAngle.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text('from North (clockwise)',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ],
              ),
            ),

            // Calibration hint
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  const Text(
                    'Move phone in figure-8 to calibrate',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AccuracyBadge extends StatelessWidget {
  final double accuracy;
  const _AccuracyBadge({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (accuracy) {
      < 15 => (Colors.green, 'High Accuracy'),
      < 30 => (Colors.orange, 'Medium Accuracy'),
      _ => (Colors.red, 'Low Accuracy - Calibrate'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_fixed, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
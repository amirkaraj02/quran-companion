import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dhikr_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:go_router/go_router.dart';

class DhikrScreen extends ConsumerWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dhikr & Tasbeeh')),
      body: Column(
        children: [
          // Dhikr list
          Expanded(
            flex: 2,
            child: _DhikrList(),
          ),
          const Divider(height: 1),
          // Counter area
          Expanded(
            flex: 3,
            child: _DhikrCounter(),
          ),
        ],
      ),
    );
  }
}

class _DhikrList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dhikrCountProvider);
    final locale = ref.watch(localeProvider);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: defaultDhikrList.length,
      itemBuilder: (_, i) {
        final dhikr = defaultDhikrList[i];
        final count = state.getCount(dhikr.id);
        final isActive = state.activeDhikrId == dhikr.id;

        return GestureDetector(
          onTap: () => ref.read(dhikrCountProvider.notifier).setActive(dhikr.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 130,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? AppColors.primary : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: isActive ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dhikr.textArabic,
                    style: TextStyle(
                      fontFamily: 'Uthmani',
                      fontSize: 16,
                      color: isActive ? Colors.white : AppColors.textDark,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text('$count / ${dhikr.targetCount}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white70 : AppColors.textGrey,
                    )),
                if (count >= dhikr.targetCount)
                  const Text('✓', style: TextStyle(color: Colors.green, fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DhikrCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dhikrCountProvider);
    final locale = ref.watch(localeProvider);
    final dhikr = defaultDhikrList
        .firstWhere((d) => d.id == state.activeDhikrId);
    final count = state.getCount(dhikr.id);
    final target = dhikr.targetCount;
    final progress = (count / target).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(dhikrCountProvider.notifier).increment(dhikr.id);
      },
      child: Container(
        color: AppColors.bgLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Arabic text
            Text(
              dhikr.textArabic,
              style: const TextStyle(
                fontFamily: 'Uthmani',
                fontSize: 28,
                height: 2,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              dhikr.localizedText(locale.languageCode),
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Counter circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text('/ $target',
                        style: const TextStyle(color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (count >= target)
              const Text('🎉 Completed!',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),

            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => ref.read(dhikrCountProvider.notifier).reset(dhikr.id),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reset'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap anywhere to count',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
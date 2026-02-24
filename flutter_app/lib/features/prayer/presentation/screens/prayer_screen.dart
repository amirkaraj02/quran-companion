import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/prayer_provider.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final times = ref.watch(prayerTimesProvider);
    final settings = ref.watch(prayerSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.cityName),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => ref.read(prayerSettingsProvider.notifier).detectLocation(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context, ref),
          ),
        ],
      ),
      body: times == null
          ? const Center(child: Text('Could not calculate prayer times'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _NextPrayerBanner(times: times),
                  _DateHeader(),
                  ...times.all.map((p) => _PrayerTimeTile(
                    entry: p,
                    isNext: p.name == times.nextPrayerName,
                  )),
                  _CalibrationMethod(method: settings.calculationMethod),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/qibla'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.explore, color: Colors.white),
        label: const Text('Qibla', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PrayerSettingsSheet(),
    );
  }
}

class _NextPrayerBanner extends StatefulWidget {
  final PrayerTimesEntity times;
  const _NextPrayerBanner({required this.times});

  @override
  State<_NextPrayerBanner> createState() => _NextPrayerBannerState();
}

class _NextPrayerBannerState extends State<_NextPrayerBanner> {
  late Stream<Duration?> _countdownStream;

  @override
  void initState() {
    super.initState();
    _countdownStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) => widget.times.timeToNextPrayer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4A27), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next Prayer',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(widget.times.nextPrayerName ?? 'Fajr Tomorrow',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              if (widget.times.nextPrayerTime != null)
                Text(
                  DateFormat('HH:mm').format(widget.times.nextPrayerTime!),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<Duration?>(
            stream: _countdownStream,
            builder: (_, snap) {
              final dur = snap.data ?? widget.times.timeToNextPrayer;
              if (dur == null) return const SizedBox.shrink();
              final h = dur.inHours.toString().padLeft(2, '0');
              final m = (dur.inMinutes % 60).toString().padLeft(2, '0');
              final s = (dur.inSeconds % 60).toString().padLeft(2, '0');
              return Text('$h:$m:$s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          // TODO: Add Hijri date
          const Text('', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PrayerTimeTile extends StatelessWidget {
  final PrayerEntry entry;
  final bool isNext;

  const _PrayerTimeTile({required this.entry, this.isNext = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext
            ? AppColors.primary.withOpacity(0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(entry.nameArabic,
              style: TextStyle(
                fontFamily: 'Uthmani',
                fontSize: 18,
                color: isNext ? AppColors.primary : AppColors.textGrey,
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name,
              style: TextStyle(
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
                color: isNext ? AppColors.primary : null,
              ),
            ),
          ),
          if (isNext)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('Next',
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          Text(
            DateFormat('HH:mm').format(entry.time),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isNext ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalibrationMethod extends StatelessWidget {
  final String method;
  const _CalibrationMethod({required this.method});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 14, color: AppColors.textGrey),
          const SizedBox(width: 4),
          Text('Calculation: $method',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PrayerSettingsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(prayerSettingsProvider);
    final notifier = ref.read(prayerSettingsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Prayer Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Calculation Method'),
          ...['Diyanet', 'MWL', 'UmmAlQura', 'Egyptian'].map((m) => RadioListTile<String>(
            title: Text(m),
            value: m,
            groupValue: settings.calculationMethod,
            activeColor: AppColors.primary,
            onChanged: (v) { if (v != null) notifier.updateMethod(v); },
          )),
          const Divider(),
          const Text('Notifications',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'].map((p) => SwitchListTile(
            title: Text(p[0].toUpperCase() + p.substring(1)),
            value: switch(p) {
              'fajr' => settings.fajrNotificationEnabled,
              'dhuhr' => settings.dhuhrNotificationEnabled,
              'asr' => settings.asrNotificationEnabled,
              'maghrib' => settings.maghribNotificationEnabled,
              _ => settings.ishaNotificationEnabled,
            },
            activeColor: AppColors.primary,
            onChanged: (v) => notifier.toggleNotification(p, v),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
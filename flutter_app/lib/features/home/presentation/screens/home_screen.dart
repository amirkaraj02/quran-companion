import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../../../quran/presentation/providers/quran_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/locale_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimes = ref.watch(prayerTimesProvider);
    final activeGoal = ref.watch(activeGoalProvider);
    final lastPos = ref.watch(lastPositionProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with greeting
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('EEEE, d MMMM').format(DateTime.now()),
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                      style: TextStyle(
                        fontFamily: 'Uthmani',
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Next Prayer Card
                if (prayerTimes != null) _NextPrayerCard(times: prayerTimes),
                const SizedBox(height: 16),

                // Continue Reading
                lastPos.when(
                  data: (pos) => pos != null
                      ? _ContinueReadingCard(pos: pos)
                      : _StartReadingCard(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => _StartReadingCard(),
                ),
                const SizedBox(height: 16),

                // Goal progress
                activeGoal.when(
                  data: (goal) => goal != null
                      ? _GoalProgressCard(goal: goal)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),

                // Quick actions
                const Text('Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _QuickActions(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'السلام عليكم 🌙';
    if (hour < 17) return 'السلام عليكم ☀️';
    return 'السلام عليكم 🌆';
  }
}

class _NextPrayerCard extends StatelessWidget {
  final dynamic times;
  const _NextPrayerCard({required this.times});

  @override
  Widget build(BuildContext context) {
    final next = times.nextPrayerName;
    final nextTime = times.nextPrayerTime;
    if (next == null || nextTime == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => context.go('/prayer'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next Prayer', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  Text(next, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            Text(
              DateFormat('HH:mm').format(nextTime),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final dynamic pos;
  const _ContinueReadingCard({required this.pos});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/quran/reader', extra: {'page': pos.pageNumber}),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B6B3A), Color(0xFF2E8B57)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, color: Colors.white, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Continue Reading', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Page ${pos.pageNumber}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _StartReadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/quran'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B6B3A), Color(0xFF2E8B57)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.menu_book, color: Colors.white, size: 32),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Reading', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Open the Quran',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  final dynamic goal;
  const _GoalProgressCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/progress'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(goal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${(goal.completionPercentage * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal.completionPercentage,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${goal.totalPagesRead} pages read',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                Text('${goal.daysRemaining} days left',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      _Action('Qibla', Icons.explore, () => context.push('/qibla')),
      _Action('Dhikr', Icons.fingerprint, () => context.push('/dhikr')),
      _Action('Bookmarks', Icons.bookmark, () => context.push('/quran')),
      _Action('Settings', Icons.settings, () {}),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: actions.map((a) => _ActionButton(action: a)).toList(),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _Action(this.label, this.icon, this.onTap);
}

class _ActionButton extends StatelessWidget {
  final _Action action;
  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, color: AppColors.primary, size: 26),
            const SizedBox(height: 4),
            Text(action.label,
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
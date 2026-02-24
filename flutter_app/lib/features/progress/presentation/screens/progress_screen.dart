import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/progress_provider.dart';
import '../../domain/entities/reading_goal_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoalAsync = ref.watch(activeGoalProvider);
    final weeklyAsync = ref.watch(weeklyStatsProvider);
    final todayAsync = ref.watch(todayPagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGoalDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's progress card
            todayAsync.when(
              data: (pages) => _TodayCard(pagesRead: pages),
              loading: () => const LoadingWidget(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Active goal
            activeGoalAsync.when(
              data: (goal) => goal != null
                  ? _ActiveGoalCard(goal: goal)
                  : _NoGoalCard(onCreateGoal: () => _showCreateGoalDialog(context, ref)),
              loading: () => const LoadingWidget(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Weekly chart
            const Text('This Week', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            weeklyAsync.when(
              data: (stats) => _WeeklyChart(stats: stats),
              loading: () => const LoadingWidget(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Streak card
            _StreakCard(),
          ],
        ),
      ),
    );
  }

  void _showCreateGoalDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CreateGoalSheet(),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final int pagesRead;
  const _TodayCard({required this.pagesRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, color: Colors.amber, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today's Reading",
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text('$pagesRead pages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveGoalCard extends StatelessWidget {
  final ReadingGoalEntity goal;
  const _ActiveGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(goal.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: goal.isOnTrack ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    goal.isOnTrack ? '✓ On Track' : '⚠ Behind',
                    style: TextStyle(
                      fontSize: 11,
                      color: goal.isOnTrack ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              lineHeight: 12,
              percent: goal.completionPercentage,
              backgroundColor: Colors.grey.shade200,
              progressColor: AppColors.primary,
              barRadius: const Radius.circular(6),
              leading: const Text('0'),
              trailing: const Text('604'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(label: 'Read', value: '${goal.totalPagesRead} pages'),
                _StatItem(label: 'Remaining', value: '${goal.remainingPages} pages'),
                _StatItem(label: 'Days left', value: '${goal.daysRemaining}'),
                _StatItem(label: 'Target/day', value: '${goal.targetPagesPerDay}p'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
      ],
    );
  }
}

class _NoGoalCard extends StatelessWidget {
  final VoidCallback onCreateGoal;
  const _NoGoalCard({required this.onCreateGoal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.book_outlined, size: 48, color: AppColors.textGrey),
            const SizedBox(height: 12),
            const Text('No active reading goal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Set a Hatim goal to track your Quran reading',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateGoal,
              icon: const Icon(Icons.add),
              label: const Text('Create Goal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final Map<String, int> stats;
  const _WeeklyChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.entries.toList();
    if (entries.isEmpty) {
      return const SizedBox(height: 120,
          child: Center(child: Text('No data yet', style: TextStyle(color: AppColors.textGrey))));
    }

    return Container(
      height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (stats.values.fold(0, (a, b) => a > b ? a : b) + 2).toDouble(),
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) => Text(
                  entries[v.toInt()].key.split('-').last,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(entries.length, (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entries[i].value.toDouble(),
                color: AppColors.primary,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class _StreakCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(activeGoalProvider);

    return goalAsync.when(
      data: (goal) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${goal?.currentStreak ?? 0} Day Streak',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Best: ${goal?.longestStreak ?? 0} days',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _CreateGoalSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends ConsumerState<_CreateGoalSheet> {
  GoalType _type = GoalType.hatim;
  int _days = 30;
  int _pagesPerDay = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Reading Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<GoalType>(
            value: _type,
            decoration: const InputDecoration(labelText: 'Goal Type'),
            items: GoalType.values.map((t) => DropdownMenuItem(
              value: t,
              child: Text(switch(t) {
                GoalType.hatim => '📖 Hatim (Full Quran)',
                GoalType.dailyReading => '📅 Daily Reading',
                GoalType.memorization => '🧠 Memorization (Hifdh)',
                GoalType.learning => '📚 Learning / Study',
              }),
            )).toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 12),
          if (_type == GoalType.hatim) ...[
            const Text('Complete in how many days?'),
            Slider(
              value: _days.toDouble(),
              min: 10, max: 365,
              divisions: 35,
              label: '$_days days (${(604 / _days).ceil()} pages/day)',
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _days = v.round()),
            ),
            Text('≈ ${(604 / _days).ceil()} pages per day',
                style: const TextStyle(color: AppColors.textGrey)),
          ] else ...[
            const Text('Pages per day'),
            Slider(
              value: _pagesPerDay.toDouble(),
              min: 1, max: 60,
              divisions: 59,
              label: '$_pagesPerDay pages/day',
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _pagesPerDay = v.round()),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(goalCreationProvider.notifier);
                if (_type == GoalType.hatim) {
                  await notifier.createHatimGoal(days: _days);
                } else {
                  await notifier.createDailyGoal(pagesPerDay: _pagesPerDay);
                }
                ref.invalidate(activeGoalProvider);
                ref.invalidate(allGoalsProvider);
                Navigator.pop(context);
              },
              child: const Text('Start Goal'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
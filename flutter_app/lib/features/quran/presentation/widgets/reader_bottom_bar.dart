import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ReaderBottomBar extends ConsumerWidget {
  final int pageNumber;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const ReaderBottomBar({
    super.key,
    required this.pageNumber,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reciter = ref.watch(selectedReciterProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: 16,
        right: 16,
        top: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.black.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: pageNumber > 1 ? () => onPageChanged(pageNumber - 1) : null,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$pageNumber / $totalPages',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Slider(
                  value: pageNumber.toDouble(),
                  min: 1,
                  max: totalPages.toDouble(),
                  activeColor: AppColors.accent,
                  inactiveColor: Colors.white30,
                  onChanged: (v) => onPageChanged(v.round()),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: pageNumber < totalPages ? () => onPageChanged(pageNumber + 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, color: Colors.white),
            onPressed: () {
              // TODO: trigger audio playback
            },
          ),
        ],
      ),
    );
  }
}
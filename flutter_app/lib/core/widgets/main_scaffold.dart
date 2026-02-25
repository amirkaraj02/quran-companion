import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../generated/app_localizations.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/quran')) return 1;
    if (location.startsWith('/progress')) return 2;
    if (location.startsWith('/prayer')) return 3;
    if (location.startsWith('/more') || location.startsWith('/dhikr')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _locationToIndex(location),
        onTap: (i) {
          switch (i) {
            case 0: context.go('/'); break;
            case 1: context.go('/quran'); break;
            case 2: context.go('/progress'); break;
            case 3: context.go('/prayer'); break;
            case 4: context.go('/more'); break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: l.navHome),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book_outlined), activeIcon: const Icon(Icons.menu_book), label: l.navQuran),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart_outlined), activeIcon: const Icon(Icons.bar_chart), label: l.navProgress),
          BottomNavigationBarItem(icon: const Icon(Icons.access_time_outlined), activeIcon: const Icon(Icons.access_time), label: l.navPrayer),
          BottomNavigationBarItem(icon: const Icon(Icons.more_horiz), activeIcon: const Icon(Icons.more_horiz), label: l.navMore),
        ],
      ),
    );
  }
}
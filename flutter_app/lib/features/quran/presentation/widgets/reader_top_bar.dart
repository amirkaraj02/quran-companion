import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ReaderTopBar extends StatelessWidget {
  final int pageNumber;
  final VoidCallback onBack;
  final VoidCallback onJumpTo;
  final VoidCallback onBookmark;

  const ReaderTopBar({
    super.key,
    required this.pageNumber,
    required this.onBack,
    required this.onJumpTo,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.black.withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onBack,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Page $pageNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: onBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.navigation, color: Colors.white),
            onPressed: onJumpTo,
          ),
        ],
      ),
    );
  }
}
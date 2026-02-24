import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quran_provider.dart';
import '../widgets/quran_page_view.dart';
import '../widgets/reader_top_bar.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/jump_to_dialog.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class QuranReaderScreen extends ConsumerStatefulWidget {
  final int initialPage;
  final int? initialSurah;
  final int? initialAyah;

  const QuranReaderScreen({
    super.key,
    this.initialPage = 1,
    this.initialSurah,
    this.initialAyah,
  });

  @override
  ConsumerState<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends ConsumerState<QuranReaderScreen> {
  late PageController _pageController;
  bool _showBars = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final startPage = widget.initialPage.clamp(1, AppConstants.totalPages);
    _pageController = PageController(initialPage: startPage - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentPageProvider.notifier).state = startPage;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  void _toggleBars() {
    setState(() => _showBars = !_showBars);
    if (_showBars) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main page view
          GestureDetector(
            onTap: _toggleBars,
            child: PageView.builder(
              controller: _pageController,
              reverse: true, // Arabic RTL reading
              itemCount: AppConstants.totalPages,
              onPageChanged: (index) {
                final page = index + 1;
                ref.read(currentPageProvider.notifier).state = page;
                _savePosition(page);
              },
              itemBuilder: (context, index) {
                return QuranPageView(pageNumber: index + 1);
              },
            ),
          ),
          // Top bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showBars ? 0 : -120,
            left: 0,
            right: 0,
            child: ReaderTopBar(
              pageNumber: currentPage,
              onBack: () => context.pop(),
              onJumpTo: () => _showJumpToDialog(context),
              onBookmark: () => _bookmarkCurrentPage(),
            ),
          ),
          // Bottom bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showBars ? 0 : -100,
            left: 0,
            right: 0,
            child: ReaderBottomBar(
              pageNumber: currentPage,
              totalPages: AppConstants.totalPages,
              onPageChanged: (p) {
                _pageController.animateToPage(
                  p - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _savePosition(int page) {
    // Save last reading position
    ref.read(quranRepositoryProvider).saveLastPosition(
      ReadingPositionEntity(
        pageNumber: page,
        surahNumber: 1, // TODO: derive from page data
        ayahNumber: 1,
        lastRead: DateTime.now(),
      ),
    );
  }

  void _bookmarkCurrentPage() {
    // TODO: implement bookmark
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark added ✓')),
    );
  }

  void _showJumpToDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => JumpToDialog(
        onJumpToPage: (page) {
          _pageController.animateToPage(
            page - 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
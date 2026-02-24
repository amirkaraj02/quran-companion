import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class JumpToDialog extends StatefulWidget {
  final ValueChanged<int> onJumpToPage;
  const JumpToDialog({super.key, required this.onJumpToPage});

  @override
  State<JumpToDialog> createState() => _JumpToDialogState();
}

class _JumpToDialogState extends State<JumpToDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _pageController = TextEditingController();
  int _selectedJuz = 1;

  // Juz start pages (approximate)
  static const juzStartPages = [
    1, 22, 42, 62, 82, 102, 121, 142, 162, 182, 201, 221, 242, 262, 282,
    302, 322, 342, 362, 382, 402, 422, 442, 462, 482, 502, 522, 542, 562, 582
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Jump To', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              tabs: const [Tab(text: 'Page'), Tab(text: 'Juz'), Tab(text: 'Surah')],
            ),
            SizedBox(
              height: 140,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Page tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _pageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Page (1–604)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            final p = int.tryParse(_pageController.text);
                            if (p != null && p >= 1 && p <= 604) {
                              widget.onJumpToPage(p);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Go'),
                        ),
                      ],
                    ),
                  ),
                  // Juz tab
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        DropdownButton<int>(
                          value: _selectedJuz,
                          isExpanded: true,
                          items: List.generate(30, (i) => DropdownMenuItem(
                            value: i + 1,
                            child: Text('Juz ${i + 1}'),
                          )),
                          onChanged: (v) => setState(() => _selectedJuz = v!),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.onJumpToPage(juzStartPages[_selectedJuz - 1]);
                            Navigator.pop(context);
                          },
                          child: const Text('Go to Juz'),
                        ),
                      ],
                    ),
                  ),
                  // Surah tab
                  const Center(child: Text('Select surah from Quran screen', style: TextStyle(color: AppColors.textGrey))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
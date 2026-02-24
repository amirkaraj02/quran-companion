import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ayah_entity.dart';
import '../providers/quran_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/locale_provider.dart';

class AyahWidget extends ConsumerWidget {
  final AyahEntity ayah;
  const AyahWidget({super.key, required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(arabicFontSizeProvider);
    final fontFamily = ref.watch(arabicFontProvider);
    final showTranslation = ref.watch(showTranslationProvider);
    final tajweedEnabled = ref.watch(tajweedEnabledProvider);
    final locale = ref.watch(localeProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic text
          GestureDetector(
            onLongPress: () => _showAyahOptions(context, ref),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: tajweedEnabled && ayah.tajweedSegments.isNotEmpty
                    ? _TajweedText(ayah: ayah, fontSize: fontSize, fontFamily: fontFamily)
                    : Text(
                        '${ayah.textUthmani} ﴿${ayah.ayahNumber}﴾',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: fontSize,
                          height: 2.0,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                        textAlign: TextAlign.justify,
                      ),
              ),
            ),
          ),
          // Translation
          if (showTranslation && ayah.translation(locale.languageCode).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border(
                  left: BorderSide(color: AppColors.accent, width: 3),
                ),
              ),
              child: Text(
                '${ayah.ayahNumber}. ${ayah.translation(locale.languageCode)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  height: 1.6,
                ),
              ),
            ),
          // Sajdah indicator
          if (ayah.isSajdah)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('۩ Sajdah',
                    style: TextStyle(fontSize: 11, color: AppColors.gold)),
              ),
            ),
          const Divider(height: 1, color: Color(0xFFE8E0D0), thickness: 0.3),
        ],
      ),
    );
  }

  void _showAyahOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AyahOptionsSheet(ayah: ayah),
    );
  }
}

class _TajweedText extends StatelessWidget {
  final AyahEntity ayah;
  final double fontSize;
  final String fontFamily;

  const _TajweedText({
    required this.ayah,
    required this.fontSize,
    required this.fontFamily,
  });

  Color _ruleColor(TajweedRule rule) {
    switch (rule) {
      case TajweedRule.ghunna: return AppColors.tajweedGhunna;
      case TajweedRule.madd: return AppColors.tajweedMadd;
      case TajweedRule.qalqalah: return AppColors.tajweedQalqalah;
      case TajweedRule.ikhfa: return AppColors.tajweedIkhfa;
      case TajweedRule.idgham: return AppColors.tajweedIdgham;
      case TajweedRule.iqlab: return AppColors.tajweedIqlab;
      default: return AppColors.textDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: ayah.tajweedSegments.map((seg) {
          return TextSpan(
            text: ayah.textUthmani.substring(
              seg.start.clamp(0, ayah.textUthmani.length),
              seg.end.clamp(0, ayah.textUthmani.length),
            ),
            style: TextStyle(color: _ruleColor(seg.rule)),
          );
        }).toList(),
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: 2.0,
        ),
      ),
    );
  }
}

class _AyahOptionsSheet extends StatelessWidget {
  final AyahEntity ayah;
  const _AyahOptionsSheet({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Surah ${ayah.surahNumber}: Ayah ${ayah.ayahNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.bookmark_border, color: AppColors.primary),
            title: const Text('Bookmark this Ayah'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            leading: const Icon(Icons.highlight, color: AppColors.gold),
            title: const Text('Highlight'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: AppColors.textGrey),
            title: const Text('Share'),
            onTap: () { Navigator.pop(context); },
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline, color: AppColors.primary),
            title: const Text('Play Audio from here'),
            onTap: () { Navigator.pop(context); },
          ),
        ],
      ),
    );
  }
}
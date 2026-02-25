// AUTO-GENERATED from ARB files via flutter gen-l10n
// Run: flutter gen-l10n

import 'package:flutter/widgets.dart';

// This file is generated. To regenerate, run:
// flutter pub get && flutter gen-l10n

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('sq'),
    Locale('en'),
    Locale('tr'),
  ];

  String get appName;
  String get navHome;
  String get navQuran;
  String get navProgress;
  String get navPrayer;
  String get navMore;
  String get continueReading;
  String get startReading;
  String get nextPrayer;
  String get today;
  String get streak;
  String get days;
  String get pages;
  String get quranReader;
  String get surahList;
  String get bookmark;
  String get highlight;
  String get translation;
  String get tajweed;
  String get nightMode;
  String get settings;
  String get language;
  String get search;
  String get noResults;
  String get loading;
  String get retry;
  String get login;
  String get register;
  String get continueAsGuest;
  String get email;
  String get password;
  String get name;
  String get logout;
  String get goal;
  String get hatim;
  String get completed;
  String get daysLeft;
  String get pagesRead;
  String get qibla;
  String get dhikr;
  String get prayerTimes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['sq', 'en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'tr': return _AppLocalizationsTr();
      case 'en': return _AppLocalizationsEn();
      default: return _AppLocalizationsSq();
    }
  }

  @override
  bool shouldReload(_) => false;
}

class _AppLocalizationsSq extends AppLocalizations {
  @override String get appName => 'Shoqëruesi i Kuranit';
  @override String get navHome => 'Kryefaqja';
  @override String get navQuran => 'Kurani';
  @override String get navProgress => 'Progresi';
  @override String get navPrayer => 'Namazi';
  @override String get navMore => 'Më shumë';
  @override String get continueReading => 'Vazhdo leximin';
  @override String get startReading => 'Fillo leximin';
  @override String get nextPrayer => 'Namazi i ardhshëm';
  @override String get today => 'Sot';
  @override String get streak => 'Vazhdimësi';
  @override String get days => 'ditë';
  @override String get pages => 'faqe';
  @override String get quranReader => 'Lexues i Kuranit';
  @override String get surahList => 'Lista e Sureve';
  @override String get bookmark => 'Shëno';
  @override String get highlight => 'Theksimi';
  @override String get translation => 'Përkthimi';
  @override String get tajweed => 'Texhvidi';
  @override String get nightMode => 'Mënyra e natës';
  @override String get settings => 'Cilësimet';
  @override String get language => 'Gjuha';
  @override String get search => 'Kërko';
  @override String get noResults => 'Nuk u gjetën rezultate';
  @override String get loading => 'Duke ngarkuar...';
  @override String get retry => 'Riprovo';
  @override String get login => 'Hyrja';
  @override String get register => 'Regjistrohu';
  @override String get continueAsGuest => 'Vazhdo si mysafir';
  @override String get email => 'Email';
  @override String get password => 'Fjalëkalimi';
  @override String get name => 'Emri';
  @override String get logout => 'Dilni';
  @override String get goal => 'Qëllimi';
  @override String get hatim => 'Hatmi';
  @override String get completed => 'Përfunduar';
  @override String get daysLeft => 'Ditë mbetur';
  @override String get pagesRead => 'Faqe të lexuara';
  @override String get qibla => 'Kibla';
  @override String get dhikr => 'Dhikri';
  @override String get prayerTimes => 'Kohët e Namazit';
}

class _AppLocalizationsEn extends AppLocalizations {
  @override String get appName => 'Quran Companion';
  @override String get navHome => 'Home';
  @override String get navQuran => 'Quran';
  @override String get navProgress => 'Progress';
  @override String get navPrayer => 'Prayer';
  @override String get navMore => 'More';
  @override String get continueReading => 'Continue Reading';
  @override String get startReading => 'Start Reading';
  @override String get nextPrayer => 'Next Prayer';
  @override String get today => 'Today';
  @override String get streak => 'Streak';
  @override String get days => 'days';
  @override String get pages => 'pages';
  @override String get quranReader => 'Quran Reader';
  @override String get surahList => 'Surah List';
  @override String get bookmark => 'Bookmark';
  @override String get highlight => 'Highlight';
  @override String get translation => 'Translation';
  @override String get tajweed => 'Tajweed';
  @override String get nightMode => 'Night Mode';
  @override String get settings => 'Settings';
  @override String get language => 'Language';
  @override String get search => 'Search';
  @override String get noResults => 'No results found';
  @override String get loading => 'Loading...';
  @override String get retry => 'Retry';
  @override String get login => 'Login';
  @override String get register => 'Register';
  @override String get continueAsGuest => 'Continue as Guest';
  @override String get email => 'Email';
  @override String get password => 'Password';
  @override String get name => 'Name';
  @override String get logout => 'Logout';
  @override String get goal => 'Goal';
  @override String get hatim => 'Hatim';
  @override String get completed => 'Completed';
  @override String get daysLeft => 'Days left';
  @override String get pagesRead => 'Pages read';
  @override String get qibla => 'Qibla';
  @override String get dhikr => 'Dhikr';
  @override String get prayerTimes => 'Prayer Times';
}

class _AppLocalizationsTr extends AppLocalizations {
  @override String get appName => 'Kuran Arkadaşı';
  @override String get navHome => 'Ana Sayfa';
  @override String get navQuran => 'Kuran';
  @override String get navProgress => 'İlerleme';
  @override String get navPrayer => 'Namaz';
  @override String get navMore => 'Daha Fazla';
  @override String get continueReading => 'Okumaya Devam Et';
  @override String get startReading => 'Okumaya Başla';
  @override String get nextPrayer => 'Sonraki Namaz';
  @override String get today => 'Bugün';
  @override String get streak => 'Seri';
  @override String get days => 'gün';
  @override String get pages => 'sayfa';
  @override String get quranReader => 'Kuran Okuyucu';
  @override String get surahList => 'Sure Listesi';
  @override String get bookmark => 'Yer İmi';
  @override String get highlight => 'Vurgula';
  @override String get translation => 'Tercüme';
  @override String get tajweed => 'Tecvid';
  @override String get nightMode => 'Gece Modu';
  @override String get settings => 'Ayarlar';
  @override String get language => 'Dil';
  @override String get search => 'Ara';
  @override String get noResults => 'Sonuç bulunamadı';
  @override String get loading => 'Yükleniyor...';
  @override String get retry => 'Tekrar Dene';
  @override String get login => 'Giriş';
  @override String get register => 'Kayıt Ol';
  @override String get continueAsGuest => 'Misafir olarak devam et';
  @override String get email => 'E-posta';
  @override String get password => 'Şifre';
  @override String get name => 'İsim';
  @override String get logout => 'Çıkış';
  @override String get goal => 'Hedef';
  @override String get hatim => 'Hatim';
  @override String get completed => 'Tamamlandı';
  @override String get daysLeft => 'Kalan gün';
  @override String get pagesRead => 'Okunan sayfa';
  @override String get qibla => 'Kıble';
  @override String get dhikr => 'Zikir';
  @override String get prayerTimes => 'Namaz Vakitleri';
}
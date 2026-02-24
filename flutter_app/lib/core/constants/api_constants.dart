class ApiConstants {
  static const baseUrl = 'https://your-api-domain.com/api';
  static const timeout = Duration(seconds: 30);

  // Quran API (offline-first, fallback to online)
  static const quranApiBase = 'https://api.alquran.cloud/v1';
  static const audioBase = 'https://cdn.islamic.network/quran/audio';

  // Endpoints
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const refreshToken = '/auth/refresh';
  static const syncProgress = '/sync/progress';
  static const syncBookmarks = '/sync/bookmarks';
  static const userProfile = '/user/profile';
  static const readingGoals = '/goals';
  static const readingSessions = '/sessions';
}
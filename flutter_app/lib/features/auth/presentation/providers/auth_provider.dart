import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({AuthStatus? status, UserEntity? user, String? error}) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error ?? this.error,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final DioClient _dioClient;

  AuthNotifier(this._dioClient) : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      // TODO: verify token with backend
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _dioClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'] as String;
      await SecureStorage.setToken(token);
      final userData = response.data['user'] as Map<String, dynamic>;
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserEntity(
          id: userData['id'] as String,
          email: userData['email'] as String,
          name: userData['name'] as String,
          isEmailVerified: userData['isEmailVerified'] as bool? ?? false,
          createdAt: DateTime.parse(userData['createdAt'] as String),
        ),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Login failed. Please check your credentials.',
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _dioClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      await loginWithEmail(email, password);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Registration failed.',
      );
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearToken();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void continueAsGuest() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(dioClientProvider));
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
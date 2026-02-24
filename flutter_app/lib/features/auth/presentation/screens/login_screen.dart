import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (_, state) {
      if (state.isAuthenticated) context.go('/');
      if (state.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error ?? 'Login failed'), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                const Center(
                  child: Column(
                    children: [
                      Text('🕌', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 8),
                      Text(
                        'Quran Companion',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'صَاحِبُ الْقُرْآنِ',
                        style: TextStyle(
                          fontFamily: 'Uthmani',
                          fontSize: 18,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text('Welcome Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Sign in to sync your reading progress',
                    style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) =>
                    v != null && v.contains('@') ? null : 'Enter valid email',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Min 6 characters',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() == true) {
                            ref.read(authProvider.notifier).loginWithEmail(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          }
                        },
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.push('/auth/register'),
                  child: const Text('Don\'t have an account? Register'),
                ),
                const SizedBox(height: 12),
                const Row(children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or', style: TextStyle(color: AppColors.textGrey)),
                  ),
                  Expanded(child: Divider()),
                ]),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).continueAsGuest(),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Continue as Guest'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
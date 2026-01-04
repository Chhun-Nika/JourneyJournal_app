import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/preferences/user_preferences.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_button.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

import '../../data/repository/user_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // void login
  void onLogin() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final user = await _userRepository.login(email, password);

    if (!mounted) return;

    if (user != null) {
      // Save the logged-in user
      UserPreference.saveUser(user);
      context.go('/trips');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } else {
      // Invalid email/password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.primaryGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Text(
                    "Journey Journal!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight
                          .bold, // this color is required but ignored by shader
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Welcome back!",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 40),
                AppTextField(
                  label: "email",
                  controller: _emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: "password",
                  controller: _passwordController,
                  validator: Validators.password,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                AppButton(text: "Log in", onPressed: onLogin),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account yet? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/register'); // GoRouter navigation
                      },
                      child: Text(
                        "Sign up",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

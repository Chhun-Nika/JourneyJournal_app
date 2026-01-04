import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_button.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';

import '../../data/repository/user_repo.dart';
import '../../model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  void onSignUp() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final user = User(name: name, email: email, password: password);

      final isCreated = await _userRepository.createUser(user);

      if (!mounted) return;
      if (isCreated) {
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already registered.')),
        );
      }
      // go to login after success
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
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
                "Create an Account",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 40),
              AppTextField(
                label: "Name",
                controller: _nameController,
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: "Email",
                controller: _emailController,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: "Password",
                controller: _passwordController,
                validator: Validators.password,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: "Confirm Password",
                controller: _confirmController,
                validator: _confirmPasswordValidator,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              AppButton(text: "Sign up", onPressed: onSignUp),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/login'); // GoRouter navigation
                    },
                    child: Text(
                      "Log in",
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
    );
  }
}

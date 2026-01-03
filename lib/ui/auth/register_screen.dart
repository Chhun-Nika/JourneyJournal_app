import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:journey_journal_app/ui/auth/login_screen.dart';
import 'package:journey_journal_app/ui/shared/app_button.dart';
import 'package:journey_journal_app/ui/shared/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
  }

  // sign up function
  void onSignUp() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text; 

      // bug 
      debugPrint('$name register with $email / $password');
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Journey Journal!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              AppTextField(
                hint: "name",
                controller: _nameController,
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: "email",
                controller: _emailController,
                validator: Validators.email,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: "password",
                controller: _passwordController,
                validator: Validators.password,
                obscureText: true,
              ),

              const SizedBox(height: 10),
              AppTextField(
                hint: "comfirm password",
                controller: _confirmController,
                validator: _confirmPasswordValidator,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              AppButton(
                text: "Sign up", 
                onPressed: onSignUp
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Already have an account?",
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

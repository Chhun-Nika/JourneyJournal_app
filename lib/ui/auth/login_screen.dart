import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:journey_journal_app/ui/auth/register_screen.dart';
import 'package:journey_journal_app/ui/shared/app_button.dart';
import 'package:journey_journal_app/ui/shared/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose ();
    _passwordController.dispose();
    _emailController.dispose();
  
  } 

  // void login 
  void onLogin () {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // bug
      debugPrint('Login with $email / $password');
    }
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
              Text("Welcome back to Journey Journal!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
              const SizedBox(height: 40,),
              AppTextField(
                hint: "email", 
                controller: _emailController, 
                validator: Validators.email, 
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10,),
              AppTextField(
                hint: "password", 
                controller: _passwordController, 
                validator: Validators.password, 
                obscureText: true,
              ),
              const SizedBox(height: 30,),
              AppButton(
                text: "login", 
                onPressed: onLogin
              ),
              const SizedBox(height: 12,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Didn’t have an account yet? ",
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),  
      ),
    );
  }
}

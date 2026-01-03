import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:journey_journal_app/ui/auth/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose ();
    _nameController.dispose();
    _emailController.dispose();
  
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back to Journey Journal!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            const SizedBox(height: 40,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                label: Text(
                  "name", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
              ),       
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                label: Text(
                  "email", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
              ),       
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
      
              onPressed: () => {}, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff89A4F1),
                elevation: 4,
                shadowColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Log in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ) ,
      
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
    );
  }
}

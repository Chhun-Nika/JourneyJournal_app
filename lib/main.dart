import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itinerary Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('Itinerary Test')),
        body: const Center(child: Text('Check console for DB output')),
      ),
    );
  }
}
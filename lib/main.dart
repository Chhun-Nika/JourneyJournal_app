import 'package:flutter/material.dart';
import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';
import 'router/app_router.dart' ; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Failed to initialize database: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Journey Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter, 
    );
  }
}
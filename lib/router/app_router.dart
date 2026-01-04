import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/ui/trip/trip_page.dart';

import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/welcome/welcome_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    /// Welcome Screen
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    /// Login Screen
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Register Screen
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Home Screen (after login/register)
    GoRoute(
      path: '/trips',
      name: 'trips',
      builder: (context, state) => const TripPage(),
    ),
  ],

  /// Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.toString()}'),
    ),
  ),
);
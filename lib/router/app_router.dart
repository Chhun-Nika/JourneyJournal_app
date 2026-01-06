import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/expense_repo.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/checklist_item.dart';
import 'package:journey_journal_app/ui/checklist/add_checklist.dart';
import 'package:journey_journal_app/ui/checklist/checklist_screen.dart';
import 'package:journey_journal_app/ui/checklist/edit_checklist.dart';
import 'package:journey_journal_app/ui/expense/add_expense_screen.dart';
import 'package:journey_journal_app/ui/expense/expense_list_screen.dart';
import 'package:journey_journal_app/ui/trip/trip_tab_screen.dart';
import '../model/trip.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/dbInspector/db_inspector.dart';
import '../ui/home_screen.dart';
import '../ui/trip/itinerary_activity_screen.dart';
import '../ui/trip/trip_form.dart';
import '../ui/welcome/welcome_screen.dart';

final ExpenseRepository expenseRepository = ExpenseRepository();

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

    // Home Screen
    // GoRoute(
    //   path: '/trips',
    //   name: 'trips',
    //   builder: (context, state) => const TripListScreen(),
    // ),
    GoRoute(
      path: '/trips',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'create', // full path: /trips/create
          builder: (context, state) => const TripForm(),
        ),
      ],
    ),
    GoRoute(
      path: '/trips/details',
      builder: (context, state) {
        final Trip trip = state.extra as Trip; // get the trip from extra
        return TripTabsScreen(trip: trip);
      },
    ),
    GoRoute(
      path: '/trips/:tripId/agenda',
      builder: (context, state) {
        final trip = (state.extra as Map)['trip'] as Trip;
        final dayIndex = (state.extra as Map)['dayIndex'] as int;
        final dayDate = (state.extra as Map)['dayDate'] as DateTime;

        return AgendaScreen(trip: trip, dayIndex: dayIndex, dayDate: dayDate);
      },
    ),

    // Expense List Screen with tripId param in path
    GoRoute(
      path: '/expenses',
      name: 'expense_list',
      builder: (context, state) {
        // Expecting the full Trip object as extra
        final trip = state.extra as Trip;

        return ExpenseListScreen(trip: trip);
      },
    ),

    GoRoute(
      path: '/expenses/add',
      name: 'add_expense',
      builder: (context, state) {
        // Expecting state.extra to be a Map<String, dynamic>
        final extra = state.extra as Map<String, dynamic>?;

        final tripId = extra?['tripId'] as String? ?? '';
        final categories = extra?['categories'] as List<Category>? ?? [];

        return AddExpenseScreen(tripId: tripId, categories: categories);
      },
    ),

    GoRoute(
      path: '/checklist',
      name: 'checklist_list',
      builder: (context, state) {
        // Expecting full Trip object as extra
        final trip = state.extra as Trip;
        return ChecklistListScreen(trip: trip);
      },
    ),

    GoRoute(
      path: '/checklist/add',
      name: 'add_checklist_item',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final tripId = extra?['tripId'] as String? ?? '';
        final categories = extra?['categories'] as List<Category>? ?? [];

        return AddChecklistItemScreen(tripId: tripId, categories: categories);
      },
    ),

    GoRoute(
      path: '/checklist/edit',
      builder: (context, state) {
        final tripId = state.extra is Map<String, dynamic> ? (state.extra as Map<String, dynamic>)['tripId'] as String : '';
        final categories = state.extra is Map<String, dynamic> ? (state.extra as Map<String, dynamic>)['categories'] as List<Category> : <Category>[];
        final existingItem = state.extra is Map<String, dynamic> ? (state.extra as Map<String, dynamic>)['existingItem'] as ChecklistItem? : null;

        if (tripId == null || categories.isEmpty) {
          return const Scaffold(body: Center(child: Text('Missing parameters')));
        }

        return EditChecklistItemScreen(
          tripId: tripId,
          categories: categories,
          existingItem: existingItem,
        );
      },
    ),

    GoRoute(
      path: '/db-inspector',
      builder: (context, state) => const DbInspectorScreen(),
    ),

    
  ],

  /// Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri.toString()}')),
  ),
);

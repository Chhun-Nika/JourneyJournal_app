import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/expense_repo.dart';
import 'package:journey_journal_app/model/category.dart';
import 'package:journey_journal_app/model/checklist_item.dart';
import 'package:journey_journal_app/ui/checklist/add_checklist.dart';
import 'package:journey_journal_app/ui/checklist/checklist_screen.dart';
import 'package:journey_journal_app/ui/expense/add_expense_screen.dart';
import 'package:journey_journal_app/ui/expense/expense_list_screen.dart';
import 'package:journey_journal_app/ui/trip/trip_tab_screen.dart';
import '../model/trip.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/dbInspector/db_inspector.dart';
import '../ui/home_screen.dart';
import '../ui/itinerary/add_itinerary.dart';
import '../ui/itinerary/itinerary_activity_screen.dart';
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
        final extra = state.extra;
        if (extra is Map &&
            extra['trip'] is Trip &&
            extra['dayIndex'] is int &&
            extra['dayDate'] is DateTime) {
          return AgendaScreen(
            trip: extra['trip'] as Trip,
            dayIndex: extra['dayIndex'] as int,
            dayDate: extra['dayDate'] as DateTime,
          );
        }

        final tripId = state.pathParameters['tripId'];
        final dateParam = state.uri.queryParameters['date'];
        final parsedDate =
            dateParam != null ? DateTime.tryParse(dateParam) : null;

        if (tripId != null && parsedDate != null) {
          return AgendaRouteLoader(
            tripId: tripId,
            dayDate: parsedDate,
          );
        }

        return const Scaffold(
          body: Center(child: Text('Invalid itinerary link')),
        );
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
      path: '/itinerary/add',
      name: 'add_itinerary',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return AddItineraryActivityScreen(
          trip: data['trip'],
          dayDate: data['date'],
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
        final extra = state.extra as Map;
        final tripId = extra['tripId'] as String;
        final categories = extra['categories'] as List<Category>;
        final existingItem = extra['existingItem'] as ChecklistItem;
        return AddChecklistItemScreen(
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

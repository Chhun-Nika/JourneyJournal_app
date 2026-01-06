import 'package:flutter/material.dart';
import 'package:journey_journal_app/ui/checklist/checklist_screen.dart';
import 'package:journey_journal_app/ui/trip/trip_details_screen.dart';
import '../../model/trip.dart';
import '../expense/expense_list_screen.dart';
import '../shared/theme/app_theme.dart';

class TripTabsScreen extends StatefulWidget {
  final Trip trip;

  const TripTabsScreen({super.key, required this.trip});

  @override
  State<TripTabsScreen> createState() => _TripTabsScreenState();
}

class _TripTabsScreenState extends State<TripTabsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TripDetailsScreen(trip: widget.trip), // previously the TripDetailsScreen body
      ExpenseListScreen(trip: widget.trip,),
      ChecklistListScreen(trip: widget.trip)
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Checklist'),
        ],
      ),
    );
  }
}
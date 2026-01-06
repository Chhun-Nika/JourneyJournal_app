import 'package:flutter/material.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_bottom_bar.dart';
import 'profile/profile.dart';
import 'trip/trip_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavScaffold(
      screens: const [
        TripListScreen(),
        Profile(),
      ],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Trips'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
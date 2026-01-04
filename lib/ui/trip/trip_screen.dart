import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/model/trip.dart';
import 'package:journey_journal_app/model/user.dart';
import 'package:journey_journal_app/data/repository/trip.repo.dart';
import 'package:journey_journal_app/data/preferences/user_preferences.dart';
import 'package:journey_journal_app/ui/profile/profile.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_bottom_bar.dart';
import 'package:journey_journal_app/ui/shared/widgets/create_button.dart';
import '../shared/widgets/home_app_drawer.dart';
import 'trip_tile_widget.dart';
import '../shared/theme/app_theme.dart'; // your reusable AppDrawer

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  List<Trip> trips = [];
  bool isLoading = true;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCurrentUser();
    if (currentUser != null) {
      await _loadTrips();
    } else {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadCurrentUser() async {
    final user = await UserPreference.getUser();
    if (!mounted) return;
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _loadTrips() async {
    if (currentUser == null) return;
    final loadedTrips = await TripRepository().getUserTrips(
      currentUser!.userId,
    );
    if (!mounted) return;
    setState(() {
      trips = loadedTrips;
      isLoading = false;
    });
  }

  Future<void> _navigateToCreateTrip() async {
    if (currentUser == null) return;
    final createdTrip = await context.push<Trip>('/trips/create');
    if (createdTrip != null) {
      setState(() => trips.add(createdTrip));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      drawer: const AppDrawer(), // Add your reusable drawer here
      appBar: AppBar(
        toolbarHeight: 75,
        titleSpacing: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        // elevation: 3,
        title: GestureDetector(
          onTap: () {
            // Navigate to Profile page
            context.push('/profile');
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.secondaryColor,
                  child: Text(
                    currentUser != null && currentUser!.name.isNotEmpty
                        ? currentUser!.name.substring(0, 1).toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.name ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {
                // You can navigate to a notifications page here
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CreateButton(
        onPressed: _navigateToCreateTrip,
        tooltip: 'Create New Trip',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Your trips await. Tap to explore.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : trips.isEmpty
                  ? Center(
                      child: Text(
                        'No trips found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return TripTileWidget(
                          tripName: trip.title,
                          startDate: trip.startDate,
                          endDate: trip.endDate,
                          onTap: () {
                            // You can add navigation to trip details here
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/model/trip.dart';
import 'package:journey_journal_app/model/user.dart';
import 'package:journey_journal_app/data/repository/trip.repo.dart';
import 'package:journey_journal_app/data/preferences/user_preferences.dart';
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
  final TripRepository _tripRepository = TripRepository();

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
    final loadedTrips = await _tripRepository.getUserTrips(
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

  Future<bool> _confirmDeleteTrip(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete trip?'),
            content: const Text('This will remove the trip permanently.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteTrip(Trip trip, int index) async {
    setState(() {
      trips.removeAt(index);
    });

    try {
      await _tripRepository.deleteTrip(trip.tripId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trip deleted')));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        trips.insert(index, trip);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete trip')));
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
            Text("Tap to explore.", style: TextStyle(color: Colors.grey[600]),),
            const SizedBox(height: 10,),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return AppTheme.primaryGradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                );
              },
              child: Text(
                "Your trips await!",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                        return Dismissible(
                          key: ValueKey(trip.tripId),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmDeleteTrip(context),
                          onDismissed: (_) => _deleteTrip(trip, index),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.tileHorizontalPadding,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                AppTheme.tileBorderRadius,
                              ),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: TripTileWidget(
                            tripName: trip.title,
                            startDate: trip.startDate,
                            endDate: trip.endDate,
                            onTap: () {
                              context.push('/trips/details', extra: trip);
                            },
                          ),
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

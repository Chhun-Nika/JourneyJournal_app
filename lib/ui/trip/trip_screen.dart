import 'package:flutter/material.dart';
import 'package:journey_journal_app/model/trip.dart';
import 'package:journey_journal_app/data/repository/trip.repo.dart';
import 'package:journey_journal_app/ui/shared/create_button.dart';
import 'package:journey_journal_app/ui/trip/trip_form.dart';
import 'trip_tile_widget.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final String dummyUserId = 'test_user_123';
  List<Trip> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final loadedTrips = await TripRepository().getUserTrips(dummyUserId);
    setState(() {
      trips = loadedTrips;
      isLoading = false;
    });
  }

  Future<void> _navigateToCreateTrip() async {
    // Push TripForm and wait for result (true if created)
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const TripForm()),
    );

    if (created == true) {
      _loadTrips(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: CreateButton(
        onPressed: _navigateToCreateTrip,
        tooltip: 'Create New Trip',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Subtitle text
              const Text(
                "Your trips await. Tap to explore.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8CA9FF),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : trips.isEmpty
                    ? const Center(child: Text('No trips found'))
                    : ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return TripTileWidget(
                            tripName: trip.title,
                            startDate: trip.startDate,
                            endDate: trip.endDate,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

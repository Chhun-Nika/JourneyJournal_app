import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';
import 'day_tile_widget.dart';
import 'trip_details_header.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  /// Generate a list of day labels: Day 1, Day 2, ...
  List<String> _generateDayLabels() {
    return List.generate(trip.totalDays, (index) => "Day ${index + 1}");
  }

  @override
  Widget build(BuildContext context) {
    final dayLabels = _generateDayLabels();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          trip.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 30,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with destination, dates, total days
            TripDetailsHeader(trip: trip),

            const SizedBox(height: 16),

            // List of days
            Expanded(
              child: ListView.builder(
                itemCount: dayLabels.length,
                itemBuilder: (context, index) {
                  // Compute the date for each day
                  final dayDate = trip.startDate.add(Duration(days: index));

                  return DayTileWidget(
                    dayCount: dayLabels[index],
                    dayDate: dayDate,
                    onTap: () {
                      context.push(
                        '/trips/${trip.tripId}/agenda',
                        extra: {
                          'trip': trip,
                          'dayIndex': index,
                          'dayDate': dayDate,
                        },
                      );
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

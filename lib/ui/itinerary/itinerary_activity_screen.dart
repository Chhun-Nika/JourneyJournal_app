import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/repository/itinerary_activity_repo.dart';
import '../../data/repository/trip.repo.dart';
import '../../model/itinerary_activity.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/create_button.dart';
import 'itinerary_tile.dart';

class AgendaScreen extends StatefulWidget {
  final Trip trip;
  final int dayIndex;
  final DateTime dayDate;

  const AgendaScreen({
    super.key,
    required this.trip,
    required this.dayIndex,
    required this.dayDate,
  });

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class AgendaRouteLoader extends StatelessWidget {
  final String tripId;
  final DateTime dayDate;

  const AgendaRouteLoader({
    super.key,
    required this.tripId,
    required this.dayDate,
  });

  @override
  Widget build(BuildContext context) {
    final tripRepository = TripRepository();

    return FutureBuilder<Trip?>(
      future: tripRepository.getTrip(tripId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final trip = snapshot.data;
        if (trip == null) {
          return const Scaffold(
            body: Center(child: Text('Trip not found')),
          );
        }

        final tripStart = DateTime(
          trip.startDate.year,
          trip.startDate.month,
          trip.startDate.day,
        );
        final dayIndex = dayDate.difference(tripStart).inDays;
        final safeIndex = dayIndex < 0 ? 0 : dayIndex;

        return AgendaScreen(
          trip: trip,
          dayIndex: safeIndex,
          dayDate: dayDate,
        );
      },
    );
  }
}


class _AgendaScreenState extends State<AgendaScreen> {
  final _repository = ItineraryActivityRepository();

  List<ItineraryActivity> agendas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAgendas();
  }

  Future<void> _loadAgendas() async {
    setState(() => _loading = true);

    final all =
        await _repository.getTripActivities(widget.trip.tripId);

    final filtered = all.where((a) =>
        a.date.year == widget.dayDate.year &&
        a.date.month == widget.dayDate.month &&
        a.date.day == widget.dayDate.day).toList();

    filtered.sort(
      (a, b) => a.combineDateTime.compareTo(b.combineDateTime),
    );

    setState(() {
      agendas = filtered;
      _loading = false;
    });
  }

  Future<void> _toggleCompleted(
    ItineraryActivity activity,
    bool? value,
  ) async {
    final updated =
        activity.copyWith(isCompleted: value ?? false);

    await _repository.updateActivity(updated);
    await _loadAgendas();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE, d MMM yyyy').format(widget.dayDate);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Itinerary - ${widget.trip.title}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${widget.dayIndex + 1} • $formattedDate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : agendas.isEmpty
                      ? Center(
                          child: Text(
                            'No activities yet.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: agendas.length,
                          itemBuilder: (context, index) {
                            final activity = agendas[index];
                            return AgendaTile(
                              activity: activity,
                              onChecked: (v) =>
                                  _toggleCompleted(activity, v),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),

      floatingActionButton: CreateButton(
        tooltip: 'Add Activity',
        onPressed: () async {
          final activity =
              await context.push<ItineraryActivity>(
            '/itinerary/add',
            extra: {
              'trip': widget.trip,
              'date': widget.dayDate,
            },
          );

          if (activity != null) {
            await _repository.addActivity(activity);
            await _loadAgendas();
          }
        },
      ),
    );
  }
}

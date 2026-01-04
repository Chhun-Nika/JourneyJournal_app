import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/trip.repo.dart';
import 'package:journey_journal_app/model/trip.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_date_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';
import '../../data/preferences/user_preferences.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/app_button.dart';
import '../shared/widgets/app_text_field.dart';
import '../utils/date_validator.dart';

class TripForm extends StatefulWidget {
  const TripForm({super.key});

  @override
  State<TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _desinationController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await UserPreference.getUser();
    if (!mounted) return;
    setState(() {
      currentUserId = user?.userId;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _desinationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void onCreate() async {
    if (!_formkey.currentState!.validate()) return;

    final trip = Trip(
      userId: currentUserId!,
      title: _nameController.text.trim(),
      destination: _desinationController.text.trim(),
      startDate: startDate!,
      endDate: endDate!,
    );

    try {
      await TripRepository().addTrip(trip);

      if (!mounted) return;
      context.pop(trip); // return newly created trip
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create trip')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New Trip",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 18, right: 18),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trip Name
              AppTextField(
                label: "Trip Name",
                controller: _nameController,
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: 12),

              // Destination
              AppTextField(
                label: "Destination",
                controller: _desinationController,
                validator: (v) => Validators.required(v, 'Destination'),
              ),
              const SizedBox(height: 12),

              // Start Date
              AppDateField(
                hint: "Select start date",
                value: startDate,
                allowPastDates: true, // cannot pick past date
                onChanged: (date) {
                  setState(() {
                    startDate = date;
                    if (endDate != null && endDate!.isBefore(date)) {
                      endDate = date; // adjust end date
                    }
                  });
                },
                validator: (_) =>
                    AppDateValidator.validateRequired(startDate, 'start date'),
              ),
              const SizedBox(height: 12),

              // End Date
              AppDateField(
                hint: "Select end date",
                value: endDate,
                allowPastDates: true,
                onChanged: (date) => setState(() => endDate = date),
                validator: (_) => AppDateValidator.validateEndDate(
                  start: startDate,
                  end: endDate,
                  startFieldName: 'start date',
                  endFieldName: 'end date',
                ),
              ),
              const SizedBox(height: 30),

              // Create Button
              AppButton(text: "Create Trip", onPressed: onCreate),
            ],
          ),
        ),
      ),
    );
  }
}

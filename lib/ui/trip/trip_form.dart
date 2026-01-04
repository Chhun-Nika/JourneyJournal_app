import 'package:flutter/material.dart';
import 'package:journey_journal_app/data/repository/trip.repo.dart';
import 'package:journey_journal_app/model/trip.dart';
import 'package:journey_journal_app/ui/shared/app_button.dart';
import 'package:journey_journal_app/ui/shared/app_date_field.dart';
import 'package:journey_journal_app/ui/shared/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';
import 'package:uuid/uuid.dart';

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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _noteController.dispose();
    _desinationController.dispose();
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        startDate = date;
        if (endDate != null && endDate!.isBefore(date)) {
          endDate = date;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (startDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select start date first')));
      return;
    }
    final date = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate,
      firstDate: startDate!,
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  void onCreate() async {
    if (!_formkey.currentState!.validate()) return;

    final trip = Trip(
      tripId: const Uuid().v4(),
      userId: 'test_user_123', // replace it to current user 
      title: _nameController.text.trim(),
      destination: _desinationController.text.trim(),
      startDate: startDate!,
      endDate: endDate!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await TripRepository().addTrip(trip);
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Failed to create trip: $e');
    }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Trip"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                hint: "Trip Name",
                controller: _nameController,
                validator: (v) => Validators.required(v, 'Name'),
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: "Desination",
                controller: _desinationController,
                validator: (v) => Validators.required(v, 'Desination'),
              ),
              const SizedBox(height: 10),
              AppDateField(
                hint: "Start Date",
                value: startDate,
                onTap: _pickStartDate,
                validator: (_) =>
                    startDate == null ? 'Please select start date' : null,
              ),
              const SizedBox(height: 10),
              AppDateField(
                hint: "End Date",
                value: endDate,
                onTap: _pickEndDate,
                validator: (_) =>
                    endDate == null ? 'Please select end date' : null,
              ),
              const SizedBox(height: 30),
              AppButton(text: "Create Trip", onPressed: onCreate),
            ],
          ),
        ),
      ),
    );
  }
}

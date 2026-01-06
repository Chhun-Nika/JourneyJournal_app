import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/itinerary_activity_repo.dart';
import '../../model/itinerary_activity.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';

class AddItineraryActivityScreen extends StatefulWidget {
  final Trip trip;
  final DateTime dayDate;

  const AddItineraryActivityScreen({
    super.key,
    required this.trip,
    required this.dayDate,
  });

  @override
  State<AddItineraryActivityScreen> createState() =>
      _AddItineraryActivityScreenState();
}

class _AddItineraryActivityScreenState
    extends State<AddItineraryActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _itineraryRepo = ItineraryActivityRepository();

  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _reminderEnabled = false;
  int _reminderMinutes = 15;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    final activity = ItineraryActivity(
      tripId: widget.trip.tripId,
      name: _nameController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      date: widget.dayDate,
      time: _selectedTime,
      reminderEnabled: _reminderEnabled,
      reminderMinutesBefore: _reminderMinutes,
    );

    // context.pop(activity);
    try {
      await _itineraryRepo.addActivity(activity);
      if (!mounted) return;
      context.pop(activity); // Return the new expense to the list screen
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save activity')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Activity'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Activity name (required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Activity name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Location (optional)
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                ),
              ),
              const SizedBox(height: 16),

              // Description (optional)
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Time picker
              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Time'),
                  child: Text(_selectedTime.format(context)),
                ),
              ),
              const SizedBox(height: 16),

              // Reminder toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable reminder'),
                value: _reminderEnabled,
                onChanged: (v) => setState(() => _reminderEnabled = v),
              ),

              if (_reminderEnabled) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _reminderMinutes,
                  decoration: const InputDecoration(
                    labelText: 'Remind me before',
                  ),
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 minutes')),
                    DropdownMenuItem(value: 10, child: Text('10 minutes')),
                    DropdownMenuItem(value: 15, child: Text('15 minutes')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes')),
                    DropdownMenuItem(value: 60, child: Text('1 hour')),
                  ],
                  onChanged: (v) => setState(() => _reminderMinutes = v ?? 15),
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  child: const Text('Save Activity'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

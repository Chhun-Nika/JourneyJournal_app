import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/repository/itinerary_activity_repo.dart';
import 'package:journey_journal_app/data/service/notification_service.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_dropdown_menu.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_time_field.dart';
import '../../model/itinerary_activity.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';

class AddItineraryActivityScreen extends StatefulWidget {
  final Trip trip;
  final DateTime dayDate;
  final ItineraryActivity? existingActivity;

  const AddItineraryActivityScreen({
    super.key,
    required this.trip,
    required this.dayDate,
    this.existingActivity,
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

  @override
  void initState() {
    super.initState();

    final existing = widget.existingActivity;
    if (existing != null) {
      _nameController.text = existing.name;
      _locationController.text = existing.location ?? '';
      _descController.text = existing.description ?? '';
      _selectedTime = existing.time;
      _reminderEnabled = existing.reminderEnabled;
      _reminderMinutes = existing.reminderMinutesBefore;
    }
  }

  void _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final existing = widget.existingActivity;
    final activity = ItineraryActivity(
      activityId: existing?.activityId,
      tripId: existing?.tripId ?? widget.trip.tripId,
      name: _nameController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      date: existing?.date ?? widget.dayDate,
      time: _selectedTime,
      isCompleted: existing?.isCompleted ?? false,
      reminderEnabled: _reminderEnabled,
      reminderMinutesBefore: _reminderMinutes,
      createdAt: existing?.createdAt,
      updatedAt: now,
    );

    try {
      if (existing == null) {
        await _itineraryRepo.addActivity(activity);
      } else {
        await _itineraryRepo.updateActivity(activity);
        await NotificationService.instance
            .cancelItineraryNotifications(existing);
      }
      await NotificationService.instance.scheduleItineraryNotifications(
        activity,
      );
      if (!mounted) return;
      context.pop(activity);
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
    final isEditing = widget.existingActivity != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Activity' : 'Add Activity'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 26, 18, 24),
        child: Form(
          key: _formKey,
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              // Activity name (required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Activity name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Location (optional)
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                ),
              ),
              const SizedBox(height: 12),

              // Description (optional)
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  alignLabelWithHint: true,
                ),
                textAlignVertical: TextAlignVertical.top,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Time picker
              AppTimeField(
                hint: 'Time',
                value: _selectedTime,
                onChanged: (time) => setState(() => _selectedTime = time),
              ),
              const SizedBox(height: 12),

              // Reminder toggle
              SwitchListTile(
                contentPadding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                title: const Text('Enable reminder'),
                value: _reminderEnabled,
                onChanged: (v) => setState(() => _reminderEnabled = v),
              ),

              if (_reminderEnabled) ...[
                const SizedBox(height: 8),
                AppDropdownMenu<int>(
                  label: 'Remind me before',
                  value: _reminderMinutes,
                  entries: [
                    DropdownMenuEntry(value: 0, label: 'None'),
                    DropdownMenuEntry(value: 5, label: '5 minutes'),
                    DropdownMenuEntry(value: 10, label: '10 minutes'),
                    DropdownMenuEntry(value: 15, label: '15 minutes'),
                    DropdownMenuEntry(value: 30, label: '30 minutes'),
                    DropdownMenuEntry(value: 60, label: '1 hour'),
                  ],
                  onSelected: (v) =>
                      setState(() => _reminderMinutes = v ?? 15),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  child: Text(isEditing ? 'Save Changes' : 'Save Activity'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

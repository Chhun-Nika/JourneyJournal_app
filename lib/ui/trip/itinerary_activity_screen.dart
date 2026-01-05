import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/trip.dart';
import '../shared/theme/app_theme.dart';

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

class _AgendaScreenState extends State<AgendaScreen> {
  List<String> itineraryItems = [];

  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        itineraryItems.add(text);
        _controller.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      itineraryItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMM yyyy');
    final formattedDate = dateFormat.format(widget.dayDate);

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
            // Day info
            Text(
              'Day ${widget.dayIndex + 1} - $formattedDate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Input field to add new activity
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add new activity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of itinerary items
            Expanded(
              child: itineraryItems.isEmpty
                  ? Center(
                      child: Text(
                        'No activities yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: itineraryItems.length,
                      itemBuilder: (context, index) {
                        final item = itineraryItems[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _removeItem(index),
                            ),
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
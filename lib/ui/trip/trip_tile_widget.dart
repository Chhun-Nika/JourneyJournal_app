import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripTileWidget extends StatelessWidget {
  final String tripName;
  final DateTime startDate;
  final DateTime endDate;

  const TripTileWidget({
    super.key,
    required this.tripName,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM');
    final formattedDate =
        '${dateFormat.format(startDate)} - '
        '${dateFormat.format(endDate)} ${endDate.year}';

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: ListTile(
            title: Text(
              tripName,
              style: const TextStyle(
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              formattedDate,
              style: const TextStyle(
                color: Color(0xff7f7f7f),
                fontSize: 12,
                fontWeight: FontWeight.w500 
              ),
            ),
            trailing: const Icon(Icons.chevron_right,),
          ),
        ),
      ),
    );
  }
}

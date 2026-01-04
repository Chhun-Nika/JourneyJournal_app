import 'package:flutter/material.dart';

class DayTileWidget extends StatelessWidget {
  final String dayCount;

  const DayTileWidget({super.key, required this.dayCount});

  @override
  Widget build(BuildContext context) {
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
              dayCount,
              style: const TextStyle(
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}

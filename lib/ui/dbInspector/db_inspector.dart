import 'package:flutter/material.dart';
import 'package:journey_journal_app/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class DbInspectorScreen extends StatefulWidget {
  const DbInspectorScreen({super.key});

  @override
  State<DbInspectorScreen> createState() => _DbInspectorScreenState();
}

class _DbInspectorScreenState extends State<DbInspectorScreen> {
  late Database _db;
  List<String> _tables = [];
  Map<String, List<Map<String, dynamic>>> _tableData = {};

  @override
  void initState() {
    super.initState();
    _loadDbData();
  }

  Future<void> _loadDbData() async {
    _db = await DatabaseHelper.instance.database;

    // Get all table names
    final tablesQuery = await _db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
    );

    final tables = tablesQuery.map((e) => e['name'] as String).toList();

    Map<String, List<Map<String, dynamic>>> data = {};

    for (final table in tables) {
      final rows = await _db.query(table);
      data[table] = rows;
    }

    setState(() {
      _tables = tables;
      _tableData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Inspector'),
      ),
      body: _tables.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tables.length,
              itemBuilder: (context, index) {
                final table = _tables[index];
                final rows = _tableData[table] ?? [];
                return ExpansionTile(
                  title: Text(table),
                  children: rows.isEmpty
                      ? [const ListTile(title: Text('No rows'))]
                      : rows.map((row) {
                          return ListTile(
                            title: Text(row.entries
                                .map((e) => '${e.key}: ${e.value}')
                                .join(', ')),
                          );
                        }).toList(),
                );
              },
            ),
    );
  }
}
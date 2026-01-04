import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavScaffold extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> items;
  final Color selectedColor;
  final Color unselectedColor;

  const BottomNavScaffold({
    super.key,
    required this.screens,
    required this.items,
    this.selectedColor = AppTheme.primaryColor,
    this.unselectedColor = Colors.grey,
  });

  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: widget.selectedColor,
        unselectedItemColor: widget.unselectedColor,
        showUnselectedLabels: true,
        onTap: _onTap,
        items: widget.items,
      ),
    );
  }
}
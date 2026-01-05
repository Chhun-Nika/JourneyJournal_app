import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    
    Widget buildDrawerItem({
      required String title,
      required IconData icon,
      required String route,
    }) {
      return ListTile(
        leading: Icon(icon, color: AppTheme.textColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: AppTheme.textColor,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          context.push(route); // Navigate to route
        },
      );
    }

    return Drawer(
      child: Container(
        color: AppTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.primaryColor),
              child: Center(
                child: Text(
                  'Journey Journal',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(), // optional visual separation
            buildDrawerItem(
              title: 'DB Inspector',
              icon: Icons.storage,
              route: '/db-inspector', // this will link to your inspector screen
            ),
          ],
        ),
      ),
    );
  }
}
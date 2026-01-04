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
          context.go(route); // Navigate to route
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
            buildDrawerItem(
              title: 'Trips',
              icon: Icons.list_alt,
              route: '/trips',
            ),
            buildDrawerItem(
              title: 'Profile',
              icon: Icons.person,
              route: '/profile',
            ),
            buildDrawerItem(
              title: 'Settings',
              icon: Icons.settings,
              route: '/settings',
            ),
            buildDrawerItem(
              title: 'About',
              icon: Icons.info_outline,
              route: '/about',
            ),
          ],
        ),
      ),
    );
  }
}

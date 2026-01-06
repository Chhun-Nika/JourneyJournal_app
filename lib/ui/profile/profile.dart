import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journey_journal_app/data/preferences/user_preferences.dart';
import 'package:journey_journal_app/model/user.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_button.dart';
import 'package:journey_journal_app/ui/profile/update_profile_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserPreference.getUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await UserPreference.clearUser();
    if (!mounted) return;
    context.go('/login');
  }

  Future<void> _openUpdateProfile() async {
    final user = _user;
    if (user == null) return;
    final updatedUser = await Navigator.of(context).push<User>(
      MaterialPageRoute(
        builder: (_) => UpdateProfileScreen(user: user),
      ),
    );
    if (updatedUser != null && mounted) {
      setState(() => _user = updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _user == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No user info found'),
                    const SizedBox(height: 16),
                    AppButton(text: 'Go to Login', onPressed: _logout),
                  ],
                ),
              )
            : ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.secondaryColor,
                      child: Text(
                        _user!.name.isNotEmpty
                            ? _user!.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      _user!.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      _user!.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppTheme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(text: 'Update Profile', onPressed: _openUpdateProfile),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: AppTheme.inputFieldHeight,
                    child: Material(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        AppTheme.tileBorderRadius,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppTheme.tileBorderRadius,
                        ),
                        onTap: _logout,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Log out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

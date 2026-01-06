import 'package:flutter/material.dart';
import 'package:journey_journal_app/data/preferences/user_preferences.dart';
import 'package:journey_journal_app/data/repository/user_repo.dart';
import 'package:journey_journal_app/model/user.dart';
import 'package:journey_journal_app/ui/shared/theme/app_theme.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_button.dart';
import 'package:journey_journal_app/ui/shared/widgets/app_text_field.dart';
import 'package:journey_journal_app/ui/utils/validators.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;
  bool _loading = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _saving = false;
  String? _oldPasswordError;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await _userRepository.getUserById(widget.user.userId);
    if (!mounted) return;
    setState(() {
      _currentUser = user ?? widget.user;
      _nameController.text = _currentUser!.name;
      _emailController.text = _currentUser!.email;
      _loading = false;
    });
  }

  String? _validateOldPassword(String? value) {
    if (_oldPasswordError != null) return _oldPasswordError;

    final oldValue = value?.trim() ?? '';
    final newValue = _newPasswordController.text.trim();
    if (newValue.isNotEmpty && oldValue.isEmpty) {
      return 'Old password is required';
    }
    if (oldValue.isNotEmpty) {
      return Validators.password(oldValue);
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    final newValue = value?.trim() ?? '';
    final oldValue = _oldPasswordController.text.trim();
    final wantsChange = oldValue.isNotEmpty || newValue.isNotEmpty;
    if (!wantsChange) return null;
    if (newValue.isEmpty) return 'New password is required';
    return Validators.password(newValue);
  }

  String? _validateConfirmPassword(String? value) {
    final confirmValue = value?.trim() ?? '';
    final newValue = _newPasswordController.text.trim();
    final oldValue = _oldPasswordController.text.trim();
    final wantsChange = oldValue.isNotEmpty || newValue.isNotEmpty;
    if (!wantsChange) return null;
    if (confirmValue.isEmpty) return 'Confirm password is required';
    final confirmError = Validators.password(confirmValue);
    if (confirmError != null) return confirmError;
    if (confirmValue != newValue) return 'Passwords do not match';
    return null;
  }

  Future<void> _saveProfile() async {
    if (_saving) return;
    setState(() => _oldPasswordError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final currentUser = _currentUser;
      if (currentUser == null) return;

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();

      if (email != currentUser.email) {
        final existingUser = await _userRepository.getUserByEmail(email);
        if (existingUser != null &&
            existingUser.userId != currentUser.userId) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use')),
          );
          return;
        }
      }

      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text.trim();
      final wantsPasswordChange =
          oldPassword.isNotEmpty || newPassword.isNotEmpty;

      if (wantsPasswordChange) {
        final isValidOld = currentUser.verifyPassword(oldPassword);
        if (!isValidOld) {
          if (!mounted) return;
          setState(() => _oldPasswordError = 'Incorrect password');
          _formKey.currentState!.validate();
          FocusScope.of(context).requestFocus(_oldPasswordFocus);
          return;
        }

        await _userRepository.updatePassword(
          currentUser.userId,
          newPassword,
        );
      }

      final updatedUser = currentUser.copyWith(name: name, email: email);
      await _userRepository.updateUser(updatedUser);
      await UserPreference.saveUser(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.of(context).pop(updatedUser);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    AppTextField(
                      label: 'Name',
                      controller: _nameController,
                      validator: (v) => Validators.required(v, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Old Password',
                      controller: _oldPasswordController,
                      obscureText: true,
                      focusNode: _oldPasswordFocus,
                      validator: _validateOldPassword,
                      onChanged: (_) {
                        if (_oldPasswordError != null) {
                          setState(() => _oldPasswordError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: _validateNewPassword,
                      onChanged: (_) {
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _formKey.currentState?.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      focusNode: _confirmPasswordFocus,
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: _saving ? 'Saving...' : 'Save Changes',
                      onPressed: _saving ? () {} : _saveProfile,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

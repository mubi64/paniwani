import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/strings.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  ProfileScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    if (user == null) {
      // This shouldn't happen under normal circumstances
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.profile),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You are not logged in"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text("Go to Login"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user.fullName?.isNotEmpty == true
                      ? user.fullName!.substring(0, 1).toUpperCase()
                      : "U",
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Profile Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      "Full Name",
                      user.fullName ?? "Not Set",
                      Icons.person,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      context,
                      "Phone Number",
                      user.phoneNumber,
                      Icons.phone,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      context,
                      "Email",
                      user.email ?? "Not Set",
                      Icons.email,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      context,
                      "Gender",
                      user.gender ?? "Not Set",
                      Icons.people,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      context,
                      "Date of Birth",
                      user.dateOfBirth != null
                          ? "${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}"
                          : "Not Set",
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Edit profile functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Edit Profile functionality")),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
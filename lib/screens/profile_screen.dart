import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paniwani/utils/utils.dart';
import 'package:provider/provider.dart';
import '../api/services/auth_service.dart';
import '../themes/theme_provider.dart';
import '../utils/comman_dialogs.dart';
import '../utils/strings.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final Utils _utils = Utils();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInfo();
    });
  }

  void getUserInfo() async {
    final authservice = context.read<AuthService>();
    authservice.getCurrentUser(context);
  }

  Future<void> _logout(BuildContext context) async {
    dialogConfirm(context, _utils, () async {
      _utils.showProgressDialog(context);
      await _authService.logout(context);
      _utils.hideProgressDialog(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }, AppStrings.confirmLogout);
  }

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "U";

    final nameParts = fullName.split(" ");
    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      return "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
    }

    return fullName.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // final user = _authService.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer<AuthService>(
        builder: (context, auth, child) {
          var user = auth.currentUser;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You are not logged in",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Go to Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Hero(
                          tag: 'profilePicture',
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(user.fullName),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      user.fullName?.isNotEmpty == true
                          ? user.fullName!
                          : "User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Edit Profile functionality"),
                        ),
                      );
                    },
                    tooltip: "Edit Profile",
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      // Settings
                      CardTitle(
                        title: AppStrings.settings,
                        colorScheme: colorScheme,
                      ),
                      _buildInfoCard(
                        context,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                ),
                              ),
                              // switch
                              CupertinoSwitch(
                                value:
                                    Provider.of<ThemeProvider>(
                                      context,
                                    ).isDarkMode,
                                onChanged:
                                    (value) =>
                                        Provider.of<ThemeProvider>(
                                          context,
                                          listen: false,
                                        ).toggleTheme(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CardTitle(
                        title: AppStrings.personalInfo,
                        colorScheme: colorScheme,
                      ),
                      _buildInfoCard(
                        context,
                        children: [
                          _buildProfileItem(
                            context: context,
                            label: "Full Name",
                            value: user.fullName ?? "Not Set",
                            icon: Icons.person_outlined,
                          ),
                          _buildProfileItem(
                            context: context,
                            label: "Email",
                            value: user.email ?? "Not Set",
                            icon: Icons.email_outlined,
                          ),
                          _buildProfileItem(
                            context: context,
                            label: "Phone Number",
                            value: user.phoneNumber,
                            icon: Icons.phone_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      // Additional Info
                      Text(
                        AppStrings.additionalInfo,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      _buildInfoCard(
                        context,
                        children: [
                          _buildProfileItem(
                            context: context,
                            label: "Gender",
                            value: user.gender ?? "Not Set",
                            icon: Icons.people_outline,
                          ),
                          _buildProfileItem(
                            context: context,
                            label: "Date of Birth",
                            value:
                                user.dateOfBirth != null
                                    ? "${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}"
                                    : "Not Set",
                            icon: Icons.calendar_today_outlined,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Actionable Buttons
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // Edit profile functionality
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //         content: Text("Edit Profile functionality"),
                      //       ),
                      //     );
                      //   },
                      //   icon: const Icon(Icons.edit_outlined),
                      //   label: const Text("Edit Profile"),
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 56),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 32,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({super.key, required this.title, required this.colorScheme});

  final String title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
    );
  }
}

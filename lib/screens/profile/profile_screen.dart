import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/core/errors/error_handler.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/profile/edit_profile_screen.dart';
import 'package:todo/screens/auth/change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final List<TodoItem> todos;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = isDarkMode;
    final cardColor = isDark ? const Color(0xFF132F4C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = const Color(0xFF5EBBF5).withValues(alpha: 0.3);

    final authService = AuthService();
    final user = authService.currentUser;

    final completedTasks = todos.where((t) => t.isCompleted).length;
    final totalTasks = todos.length;
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks * 100).toInt() : 0;

    return StreamBuilder<DocumentSnapshot>(
      stream: authService.userDataStream(user?.uid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ErrorHandler.getMessage(snapshot.error, context),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final displayName = userData['name'] ?? user?.displayName ?? loc.noName;
        final email = userData['email'] ?? user?.email ?? loc.noEmail;
        final birthDate = userData['birthDate'] ?? loc.notSet;
        final phone = userData['phone'] ?? loc.notSet;
        final location = userData['location'] ?? loc.notSet;
        final photoUrl = userData['photoUrl'] ?? '';

        return Column(
          children: [
            // Professional Header
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: photoUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                photoUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.white),
                              ),
                            )
                          : const Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Statistics Row
                    Row(
                      children: [
                        _buildStatCard(
                          loc.completedStats,
                          completedTasks.toString(),
                          Icons.task_alt,
                          const Color(0xFF4CAF50),
                          cardColor,
                          textColor,
                          subTextColor,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          loc.efficiency,
                          '$completionRate%',
                          Icons.speed,
                          const Color(0xFFFFC107),
                          cardColor,
                          textColor,
                          subTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Info Section
                    _buildSectionHeader(loc.personalInfo, textColor),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.calendar_today_outlined, loc.birthDate, birthDate, subTextColor),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.phone_outlined, loc.phone, phone, subTextColor),
                          const Divider(height: 24),
                          _buildInfoRow(Icons.location_on_outlined, loc.location, location, subTextColor),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Account Actions
                    _buildSectionHeader(loc.accountActions, textColor),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: loc.editProfile,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => EditProfileScreen(isDarkMode: isDark),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.lock_outline,
                      label: loc.changePassword,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => ChangePasswordScreen(isDarkMode: isDark),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, Color cardColor, Color textColor, Color subTextColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color subTextColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2B7FE8)),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: subTextColor, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF132F4C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5EBBF5).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF2B7FE8)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

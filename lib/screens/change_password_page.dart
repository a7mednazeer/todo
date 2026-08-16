import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  final bool isDarkMode;
  const ChangePasswordPage({super.key, required this.isDarkMode});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF);
    final cardColor = isDark ? const Color(0xFF132F4C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = const Color(0xFF5EBBF5).withValues(alpha: 0.3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Security',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your password and security settings.',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInputField(
                    label: 'Current Password',
                    controller: currentPasswordController,
                    icon: Icons.lock_outline,
                    isDark: isDark,
                    isPassword: true,
                    obscureText: _obscureCurrent,
                    onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'New Password',
                    controller: newPasswordController,
                    icon: Icons.lock_reset_outlined,
                    isDark: isDark,
                    isPassword: true,
                    obscureText: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Confirm New Password',
                    controller: confirmPasswordController,
                    icon: Icons.lock_reset_outlined,
                    isDark: isDark,
                    isPassword: true,
                    obscureText: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FE8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('Update Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
  }) {
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: subTextColor)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2B7FE8), size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                    onPressed: onToggle,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2B7FE8), width: 2)),
          ),
        ),
      ],
    );
  }
}

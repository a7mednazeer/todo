import 'package:todo/classes/error_handler.dart';
import 'package:todo/classes/auth_service.dart';
import 'package:todo/classes/app_localizations.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final bool isDarkMode;
  const EditProfilePage({super.key, required this.isDarkMode});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController birthDateController;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    birthDateController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      // Default values from Firebase Auth
      setState(() {
        nameController.text = user.displayName ?? '';
      });

      try {
        final doc = await _authService.getUserProfile(user.uid);
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            nameController.text = data['name'] ?? user.displayName ?? '';
            phoneController.text = data['phone'] ?? '';
            locationController.text = data['location'] ?? '';
            birthDateController.text = data['birthDate'] ?? '';
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).errorNameEmpty)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _authService.updateDisplayName(nameController.text);
        await _authService.updateUserProfile(user.uid, {
          'name': nameController.text,
          'phone': phoneController.text,
          'location': locationController.text,
          'birthDate': birthDateController.text,
        });
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getMessage(e, context)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = widget.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF);
    final cardColor = isDark ? const Color(0xFF132F4C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = const Color(0xFF5EBBF5).withValues(alpha: 0.3);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(loc.editProfile, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF2B7FE8).withValues(alpha: 0.1),
                    child: Icon(Icons.person, size: 80, color: const Color(0xFF2B7FE8)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2B7FE8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
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
                    label: loc.fullName,
                    controller: nameController,
                    icon: Icons.person_outline,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: loc.birthDate,
                    controller: birthDateController,
                    icon: Icons.calendar_today_outlined,
                    isDark: isDark,
                    hint: 'DD/MM/YYYY',
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: loc.phoneNumber,
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: loc.location,
                    controller: locationController,
                    icon: Icons.location_on_outlined,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FE8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(loc.saveChanges, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    String? hint,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          style: TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF2B7FE8), size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2B7FE8), width: 2)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final bool isDarkMode;
  const EditProfilePage({super.key, required this.isDarkMode});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController(text: 'Ahmed Mohamed');
  final TextEditingController phoneController = TextEditingController(text: '+20 123 456 789');
  final TextEditingController locationController = TextEditingController(text: 'Cairo, Egypt');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
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
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                    label: 'Full Name',
                    controller: nameController,
                    icon: Icons.person_outline,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Phone Number',
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    isDark: isDark,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Location',
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
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FE8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

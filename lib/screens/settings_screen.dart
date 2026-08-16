import 'package:flutter/material.dart';
import 'package:todo/classes/app_localizations.dart';
import 'package:todo/screens/help_center_page.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, String> languageMap = {
    'en': 'English',
    'ar': 'العربية',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'ru': 'Русский',
    'tr': 'Türkçe',
    'hi': 'हिन्दी',
    'zh': '中文',
    'pt': 'Português',
    'nl': 'Nederlands',
    'ko': '한국어',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final locale = AppLocalizations.of(context);
    final backgroundColor = isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Column(
      children: [
        _buildHeader(isDark, locale),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(locale.language, isDark),
                const SizedBox(height: 12),
                _buildDropdownCard(
                  icon: Icons.language_rounded,
                  value: languageMap[widget.currentLanguage]!,
                  items: languageMap.values.toList(),
                  onChanged: (value) {
                    final languageCode = languageMap.entries
                        .firstWhere((entry) => entry.value == value)
                        .key;
                    widget.onLanguageChanged(languageCode);
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(locale.mode, isDark),
                const SizedBox(height: 12),
                _buildDropdownCard(
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  value: isDark ? locale.dark : locale.light,
                  items: [locale.light, locale.dark],
                  onChanged: (value) {
                    widget.onThemeChanged(value == locale.dark);
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('Support & About', isDark),
                const SizedBox(height: 12),
                _buildMenuTile(
                  icon: Icons.help_center_outlined,
                  title: 'Help Center',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => HelpCenterPage(isDarkMode: isDark),
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
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDropdownCard({
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5EBBF5).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2B7FE8), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: isDark ? const Color(0xFF132F4C) : Colors.white,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(value: item, child: Text(item));
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, AppLocalizations locale) {
    return Container(
      width: double.infinity,
      height: 140,
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
        child: Center(
          child: Text(
            locale.settings,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF132F4C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF5EBBF5).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF2B7FE8)),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

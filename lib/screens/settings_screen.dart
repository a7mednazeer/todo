import 'package:flutter/material.dart';
import 'package:todo/classes/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

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
  };

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final locale = AppLocalizations.of(context);

    return Column(
      children: [
        _buildHeader(isDark, locale),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.language,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
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
                Text(
                  locale.mode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  value: isDark ? locale.dark : locale.light,
                  items: [locale.light, locale.dark],
                  onChanged: (value) {
                    widget.onThemeChanged(value == locale.dark);
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

  Widget _buildHeader(bool isDark, AppLocalizations locale) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Text(
        locale.settings,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF132F4C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF5EBBF5).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF5EBBF5)),
        ),
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF5EBBF5),
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: isDark ? const Color(0xFF132F4C) : Colors.white,
        icon: const SizedBox.shrink(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

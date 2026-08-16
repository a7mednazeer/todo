import 'package:todo/classes/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  final bool isDarkMode;
  const FeedbackPage({super.key, required this.isDarkMode});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedType = 'feedback_suggestion';

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _sendFeedback() async {
    final loc = AppLocalizations.of(context);
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.enterFeedbackError)),
      );
      return;
    }

    String localizedType;
    switch (_selectedType) {
      case 'feedback_suggestion':
        localizedType = loc.feedbackSuggestion;
        break;
      case 'feedback_bug':
        localizedType = loc.feedbackBug;
        break;
      case 'feedback_compliment':
        localizedType = loc.feedbackCompliment;
        break;
      case 'feedback_other':
        localizedType = loc.feedbackOther;
        break;
      default:
        localizedType = _selectedType;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'feedback@todoapp.com',
      query: 'subject=${Uri.encodeComponent("App Feedback: $localizedType")}&body=${Uri.encodeComponent(_feedbackController.text)}',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.emailError)),
        );
      }
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
        title: Text(loc.sendFeedback, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            Text(loc.valueFeedback, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text(loc.feedbackPrompt, style: TextStyle(fontSize: 14, color: subTextColor)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.feedbackType, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  const SizedBox(height: 8),
                  _buildDropdown(isDark),
                  const SizedBox(height: 24),
                  Text(loc.sendFeedback, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 6,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: loc.shareThoughtsHint,
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2B7FE8), width: 2)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _sendFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FE8),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(loc.submitFeedback, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(bool isDark) {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1929) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedType,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF132F4C) : Colors.white,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
          items: [
            'feedback_suggestion',
            'feedback_bug',
            'feedback_compliment',
            'feedback_other'
          ].map((String key) {
            String label;
            switch (key) {
              case 'feedback_suggestion':
                label = loc.feedbackSuggestion;
                break;
              case 'feedback_bug':
                label = loc.feedbackBug;
                break;
              case 'feedback_compliment':
                label = loc.feedbackCompliment;
                break;
              case 'feedback_other':
                label = loc.feedbackOther;
                break;
              default:
                label = key;
            }
            return DropdownMenuItem<String>(value: key, child: Text(label));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedType = newValue!;
            });
          },
        ),
      ),
    );
  }
}

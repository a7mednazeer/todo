import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todo/classes/faq_catalog.dart';
import 'package:todo/classes/chat_matcher.dart';
import 'package:todo/classes/app_localizations.dart';

import 'package:todo/screens/contact_support_page.dart';
import 'package:todo/screens/feedback_page.dart';

class HelpCenterPage extends StatelessWidget {
  final bool isDarkMode;
  const HelpCenterPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(loc.helpCenter, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            _buildSectionHeader(loc.support, textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.chat_bubble_outline,
              title: loc.chatWithUs,
              subtitle: loc.chatSubtitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ChatbotScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.help_outline,
              title: loc.faq,
              subtitle: loc.faqSubtitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FAQScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(loc.contact, textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.mail_outline,
              title: loc.contactSupport,
              subtitle: loc.contactSubtitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ContactSupportPage(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.feedback_outlined,
              title: loc.sendFeedback,
              subtitle: loc.feedbackSubtitle,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FeedbackPage(isDarkMode: isDark))),
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(loc.appInfo, textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.info_outline,
              title: loc.aboutApp,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AboutScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.description_outlined,
              title: loc.termsOfService,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PolicyScreen(title: loc.termsOfService, isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.privacy_tip,
              title: loc.privacyPolicy,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PolicyScreen(title: loc.privacyPolicy, isDarkMode: isDark))),
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor));
  }

  Widget _buildMenuTile({required IconData icon, required String title, String? subtitle, required VoidCallback onTap, required bool isDark}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF132F4C) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2B7FE8)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])) : null,
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  final bool isDarkMode;
  const ChatbotScreen({super.key, required this.isDarkMode});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context);
    _messages = [
      {'text': loc.chatSubtitle, 'isUser': false},
    ];
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    final userText = _controller.text;
    final loc = AppLocalizations.of(context);
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
    });

    // Matcher Logic
    Future.delayed(const Duration(milliseconds: 500), () {
      final response = ChatMatcher.getResponse(userText, loc.faqCatalog);
      setState(() {
        _messages.add({'text': response, 'isUser': false});
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = widget.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(loc.supportChat), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (c, i) => _buildBubble(_messages[i]),
            ),
          ),
          _buildInputArea(isDark, loc),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    bool isUser = msg['isUser'];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2B7FE8) : (widget.isDarkMode ? const Color(0xFF132F4C) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(msg['text'], style: TextStyle(color: isUser ? Colors.white : (widget.isDarkMode ? Colors.white : Colors.black87))),
      ),
    );
  }

  Widget _buildInputArea(bool isDark, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: isDark ? const Color(0xFF132F4C) : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(hintText: loc.askQuestion, border: InputBorder.none, hintStyle: const TextStyle(color: Colors.grey)),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Color(0xFF2B7FE8)), onPressed: _handleSend),
        ],
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  final bool isDarkMode;
  const FAQScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = isDarkMode;
    final faqItems = loc.faqCatalog;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(loc.faq), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqItems.length,
        itemBuilder: (c, i) => ExpansionTile(
          title: Text(faqItems[i].question, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          children: [Padding(padding: const EdgeInsets.all(16), child: Text(faqItems[i].answer, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])))],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  final bool isDarkMode;
  const AboutScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(loc.appInfo), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Color(0xFF2B7FE8)),
            const SizedBox(height: 16),
            Text(loc.appTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(loc.aboutDescription, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class PolicyScreen extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  const PolicyScreen({super.key, required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(title), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          title.toLowerCase().contains('privacy') ? loc.privacyPolicyContent : loc.termsOfServiceContent,
          style: TextStyle(fontSize: 14, height: 1.6, color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }
}

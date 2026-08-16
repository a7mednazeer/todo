import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todo/classes/faq_catalog.dart';
import 'package:todo/classes/chat_matcher.dart';

import 'package:todo/screens/contact_support_page.dart';
import 'package:todo/screens/feedback_page.dart';

class HelpCenterPage extends StatelessWidget {
  final bool isDarkMode;
  const HelpCenterPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Help Center', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            _buildSectionHeader('Support', textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.chat_bubble_outline,
              title: 'Chat with us',
              subtitle: 'Talk to our virtual assistant',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ChatbotScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.help_outline,
              title: 'Frequently Asked Questions',
              subtitle: 'Find quick answers',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FAQScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Contact', textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.mail_outline,
              title: 'Contact Support',
              subtitle: 'Send us an email',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ContactSupportPage(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Tell us how to improve',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FeedbackPage(isDarkMode: isDark))),
              isDark: isDark,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('App Info', textColor),
            const SizedBox(height: 12),
            _buildMenuTile(
              icon: Icons.info_outline,
              title: 'About ToDo App',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AboutScreen(isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PolicyScreen(title: 'Terms of Service', isDarkMode: isDark))),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PolicyScreen(title: 'Privacy Policy', isDarkMode: isDark))),
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

  void _launchEmail(String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@todoapp.com',
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent("Hello Support Team,\n\n")}',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}

class ChatbotScreen extends StatefulWidget {
  final bool isDarkMode;
  const ChatbotScreen({super.key, required this.isDarkMode});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! I am your ToDo assistant. How can I help you today?', 'isUser': false},
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    final userText = _controller.text;
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
    });

    // Matcher Logic
    Future.delayed(const Duration(milliseconds: 500), () {
      final response = ChatMatcher.getResponse(userText);
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
    final isDark = widget.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: const Text('Support Chat'), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
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
          _buildInputArea(isDark),
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

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: isDark ? const Color(0xFF132F4C) : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(hintText: 'Ask a question...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey)),
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
    final isDark = isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: const Text('FAQ'), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqCatalog.length,
        itemBuilder: (c, i) => ExpansionTile(
          title: Text(faqCatalog[i].question, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          children: [Padding(padding: const EdgeInsets.all(16), child: Text(faqCatalog[i].answer, style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])))],
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
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: const Text('About'), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Color(0xFF2B7FE8)),
            const SizedBox(height: 16),
            const Text('ToDo List App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text('Organize your life and boost your productivity with our simple, secure, and offline-first task manager.', textAlign: TextAlign.center),
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
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1929) : const Color(0xFFF5F9FF),
      appBar: AppBar(title: Text(title), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)])))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          _getContent(),
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }

  String _getContent() {
    if (title.contains('Privacy')) {
      return 'Privacy Policy\n\nYour privacy is important to us. This ToDo app works entirely offline. We do not collect, store, or transmit your personal data or task list to any external servers. All information created within the app stays on your local device storage. We do not use any third-party tracking or analytics services.';
    } else {
      return 'Terms of Service\n\nBy using the ToDo App, you agree that this software is provided "as-is" without any warranties. You are responsible for maintaining your own data. Since the app is offline-only, deleting the app or clearing its data will result in the permanent loss of your tasks. We are not liable for any data loss.';
    }
  }
}

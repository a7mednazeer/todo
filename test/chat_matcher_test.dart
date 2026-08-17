import 'package:flutter_test/flutter_test.dart';
import 'package:todo/utils/chat_matcher.dart';
import 'package:todo/models/faq_model.dart';

void main() {
  group('ChatMatcher Tests', () {
    final mockFaq = [
      const FAQItem(
        question: 'How do I create a task?',
        answer: 'Tap the + button.',
        keywords: ['create', 'add', 'new'],
      ),
      const FAQItem(
        question: 'Is it offline?',
        answer: 'Yes, 100% offline.',
        keywords: ['offline', 'internet'],
      ),
    ];

    test('Exact match returns correct answer', () {
      final response = ChatMatcher.getResponse('How do I create a task?', mockFaq);
      expect(response, 'Tap the + button.');
    });

    test('Partial match with keywords returns correct answer', () {
      final response = ChatMatcher.getResponse('add new task', mockFaq);
      expect(response, 'Tap the + button.');
    });

    test('Trigram matching for typos works', () {
      // "creae" instead of "create"
      final response = ChatMatcher.getResponse('How to creae a task', mockFaq);
      expect(response, 'Tap the + button.');
    });

    test('Confidence threshold below 0.35 returns default message', () {
      final response = ChatMatcher.getResponse('What is the weather like?', mockFaq);
      expect(response.contains('not quite sure'), true);
    });

    test('Empty input returns help prompt', () {
      final response = ChatMatcher.getResponse('', mockFaq);
      expect(response, 'How can I help you today?');
    });
  });
}

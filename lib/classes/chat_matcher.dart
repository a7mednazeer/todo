import 'package:todo/classes/faq_catalog.dart';

class ChatMatcher {
  /// Threshold for character-trigram similarity (0.0 to 1.0)
  static const double confidenceThreshold = 0.35;

  static String getResponse(String input, List<FAQItem> localizedFaq) {
    if (input.trim().isEmpty) return "How can I help you today?";

    String bestAnswer = "";
    double maxScore = 0;

    final querySet = _getTrigrams(input.toLowerCase());

    for (var item in localizedFaq) {
      // Check question similarity
      final questionSet = _getTrigrams(item.question.toLowerCase());
      double score = _calculateSimilarity(querySet, questionSet);

      // Boost score if keywords match
      for (var kw in item.keywords) {
        if (input.toLowerCase().contains(kw.toLowerCase().trim())) {
          score += 0.2;
        }
      }

      if (score > maxScore) {
        maxScore = score;
        bestAnswer = item.answer;
      }
    }

    if (maxScore >= confidenceThreshold) {
      return bestAnswer;
    } else {
      return "I'm not quite sure about that. Would you like to check our FAQ or contact our support team directly?";
    }
  }

  static Set<String> _getTrigrams(String text) {
    final trigrams = <String>{};
    if (text.length < 3) {
      trigrams.add(text);
      return trigrams;
    }
    for (int i = 0; i <= text.length - 3; i++) {
      trigrams.add(text.substring(i, i + 3));
    }
    return trigrams;
  }

  static double _calculateSimilarity(Set<String> set1, Set<String> set2) {
    if (set1.isEmpty || set2.isEmpty) return 0;
    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;
    return intersection / union;
  }
}

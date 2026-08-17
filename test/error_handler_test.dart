import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/localization/app_localizations.dart';
import 'package:todo/core/errors/error_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('ErrorHandler Localized Tests', () {
    testWidgets('Returns localized error for wrong-password in English', (WidgetTester tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          home: Builder(builder: (context) {
            testContext = context;
            return const SizedBox();
          }),
        ),
      );
      await tester.pumpAndSettle();

      final error = FirebaseAuthException(code: 'wrong-password');
      final message = ErrorHandler.getMessage(error, testContext);

      expect(message, 'Incorrect email or password. Please try again.');
    });

    testWidgets('Returns localized error for email-already-in-use in Arabic', (WidgetTester tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          home: Builder(builder: (context) {
            testContext = context;
            return const SizedBox();
          }),
        ),
      );
      await tester.pumpAndSettle();

      final loc = AppLocalizations.of(testContext);
      expect(loc.languageCode, 'ar'); // Verify locale is correctly loaded

      final error = FirebaseAuthException(code: 'email-already-in-use');
      final message = ErrorHandler.getMessage(error, testContext);

      expect(message, 'هذا البريد الإلكتروني مسجل بالفعل.');
    });
  });
}

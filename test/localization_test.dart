import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/localization/app_localizations.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('English translations load correctly', () async {
      const locale = Locale('en');
      final localizations = AppLocalizations(locale.languageCode);
      
      expect(localizations.appTitle, 'ToDo List');
      expect(localizations.signIn, 'Sign In');
    });

    test('Arabic translations (RTL) load correctly', () async {
      const locale = Locale('ar');
      final localizations = AppLocalizations(locale.languageCode);
      
      expect(localizations.appTitle, 'قائمة المهام');
      expect(localizations.signIn, 'تسجيل الدخول');
    });

    test('Spanish translations load correctly', () async {
      const locale = Locale('es');
      final localizations = AppLocalizations(locale.languageCode);
      
      expect(localizations.appTitle, 'Lista de Tareas');
      expect(localizations.signIn, 'Iniciar Sesión');
    });

    test('Profile Photo keys are localized', () {
      const locale = Locale('en');
      final localizations = AppLocalizations(locale.languageCode);
      
      expect(localizations.profilePhotoUrl, 'Profile Photo URL');
      expect(localizations.photoUrlHint.isNotEmpty, true);
    });

    test('Supported locales list contains all 13 languages', () {
      const delegate = AppLocalizationsDelegate();
      final supported = ['en', 'ar', 'es', 'fr', 'de', 'it', 'ru', 'tr', 'hi', 'zh', 'pt', 'nl', 'ko'];
      
      for (var code in supported) {
        expect(delegate.isSupported(Locale(code)), true);
      }
    });
  });
}

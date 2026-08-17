import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/core/localization/app_localizations.dart';

class ErrorHandler {
  static String getMessage(dynamic error, BuildContext context) {
    final loc = AppLocalizations.of(context);
    String errorCode = '';
    String? errorMessage;

    if (error is FirebaseAuthException) {
      errorCode = error.code;
      errorMessage = error.message;
    } else if (error is FirebaseException) {
      errorCode = error.code;
      errorMessage = error.message;
    } else {
      // Try to parse error code from string if it's a technical string
      final str = error.toString();
      if (str.contains('invalid-credential')) errorCode = 'invalid-credential';
      else if (str.contains('wrong-password')) errorCode = 'wrong-password';
      else if (str.contains('user-not-found')) errorCode = 'user-not-found';
      else if (str.contains('email-already-in-use')) errorCode = 'email-already-in-use';
      else if (str.contains('network-request-failed')) errorCode = 'network-request-failed';
    }

    switch (errorCode) {
      case 'user-not-found':
        return loc.errNoUserFound;
      case 'wrong-password':
      case 'invalid-credential':
        return loc.errWrongPassword;
      case 'email-already-in-use':
        return loc.errEmailInUse;
      case 'weak-password':
        return loc.errWeakPassword;
      case 'invalid-email':
        return loc.errInvalidEmail;
      case 'user-disabled':
        return loc.errUserDisabled;
      case 'too-many-requests':
        return loc.errTooManyRequests;
      case 'network-request-failed':
        return loc.errNetworkFailed;
      case 'requires-recent-login':
        return loc.errRequiresRecentLogin;
      case 'permission-denied':
        return loc.errPermissionDenied;
      case 'unavailable':
        return loc.errServiceUnavailable;
    }

    // Generic fallback for other types of errors
    String msg = error.toString();
    if (msg.contains('Unable to establish connection')) {
      return loc.errConnectionFailed;
    }
    
    // If it's a firebase error but we don't have a custom message, use the provided message or code
    if (errorCode.isNotEmpty) {
      return errorMessage ?? 'Error: $errorCode';
    }

    return loc.errUnexpected;
  }
}

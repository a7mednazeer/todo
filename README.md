# ToDo App - Premium Global Task Manager

A professional, feature-rich, and fully localized task management application built with Flutter and Firebase. This app combines high-end design aesthetics with robust cloud functionality and intelligent user support.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

---

## 🌟 Key Features

### 🛠 Task Management
- **Intuitive UI**: Organize daily tasks with a beautiful, gradient-based header and clear task cards.
- **Date Selector**: Dynamic horizontal calendar for quick navigation between dates.
- **Gestures**: Swipe-to-delete functionality with confirmation dialogs.
- **Offline First**: Your tasks are saved locally, ensuring lightning-fast performance even without internet.

### 🌎 Global Localization (13 Languages)
Fully translated UI and system messages for:
- English, Arabic, Spanish, French, German, Italian, Russian, Turkish, Hindi, Chinese, Portuguese, Dutch, and Korean.
- Includes Right-to-Left (RTL) support for Arabic.

### 🔐 Secure Authentication & Profile
- **Firebase Auth**: Robust login, signup, and password reset flows.
- **Cloud Firestore**: Real-time synchronization of user profiles (Birth Date, Phone, Location).
- **Security Actions**: In-app password change with re-authentication and secure error handling.

### 🤖 Intelligent Support
- **Smart Chatbot**: Virtual assistant powered by character-trigram similarity matching to handle multi-language queries (Chinese, Hindi, etc.) without whitespace tokenization issues.
- **Integrated FAQ**: Centralized knowledge base shared between the Help Center and Chatbot.
- **Feedback & Contact**: Direct email integration for user support and bug reporting.

### 🎨 Premium Design
- **Adaptive Dark Mode**: Fully optimized for both Light and Dark environments.
- **Notch Compatibility**: Specialized safe-area handling for modern devices with centered camera notches.
- **Modern Components**: Rounded cards (16-24px), soft shadows, and professional blue-sky gradients (`#2B7FE8` to `#5EBBF5`).

---

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **Language**: [Dart](https://dart.dev)
- **Backend**: [Firebase Authentication](https://firebase.google.com/docs/auth), [Cloud Firestore](https://firebase.google.com/docs/firestore)
- **State Management**: Streams & Localizations
- **Storage**: [Shared Preferences](https://pub.dev/packages/shared_preferences) for app settings.
- **Utilities**: [intl](https://pub.dev/packages/intl) for formatting, [url_launcher](https://pub.dev/packages/url_launcher) for external links.

---

## 📥 Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/todo-app.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Create a project on [Firebase Console](https://console.firebase.google.com/).
   - Add an Android app with package name `com.example.todo`.
   - Download `google-services.json` and place it in `android/app/`.
   - Enable **Email/Password** Auth and **Cloud Firestore**.

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── classes/
│   ├── app_localizations.dart   # Centralized 13-language translation engine
│   ├── auth_service.dart        # Firebase Auth & Firestore logic
│   ├── chat_matcher.dart        # Trigram-based chatbot logic
│   ├── error_handler.dart       # Human-readable error translations
│   └── faq_catalog.dart         # Localized knowledge base structure
├── screens/
│   ├── login_page.dart          # Secure entry point
│   ├── profile_page.dart        # Real-time synced user dashboard
│   ├── settings_screen.dart     # Language and Theme management
│   ├── todo_screen.dart         # Main task interaction layer
│   └── help_center_page.dart    # Chatbot & FAQ support
└── main.dart                    # App initialization
```

---

## 📜 Legal

This application includes a fully localized **Privacy Policy** and **Terms of Service**.
- **Privacy**: We prioritize local storage. User data is never sold or tracked by third parties.
- **Data**: Users own their data. Since the app is offline-first, users are responsible for maintaining their local device data.

---

## 📧 Support

For support, bug reports, or feature requests, please use the **Help Center** within the app or contact us at `support@todoapp.com`.

---
*Organize your life and boost your productivity with ToDo App.*

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/classes/app_localizations.dart';
import 'package:todo/classes/todo_item.dart';
import 'package:todo/screens/settings_screen.dart';
import 'package:todo/screens/todo_screen.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  bool isDarkMode = false;
  String currentLanguage = 'en';
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      currentLanguage = prefs.getString('currentLanguage') ?? 'en';
      // _isLoading = false;
    });
  }

  // Save theme preference
  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      isDarkMode = value;
    });
  }

  // Save language preference
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLanguage', languageCode);
    setState(() {
      currentLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while preferences are being loaded
    // if (_isLoading) {
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: Center(
    //         child: CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5EBBF5)),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return MaterialApp(
      title: 'ToDo List',
      debugShowCheckedModeBanner: false,
      locale: Locale(currentLanguage),

      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('ru'),
        Locale('tr'),
        Locale('hi'),
        Locale('zh'),
        Locale('pt'),
        Locale('nl'),
        Locale('ko'),
      ],

      builder: (context, child) {
        // This ensures localization is available before building
        return child ?? const SizedBox.shrink();
      },

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE8F4F8),
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: MainScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
        currentLanguage: currentLanguage,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<TodoItem> todos = [
    // TodoItem(
    //   title: 'Play basketball',
    //   details: 'Play basketball at the local court',
    //   time: const TimeOfDay(hour: 11, minute: 30),
    //   date: DateTime.now(),
    //   isCompleted: false,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    // final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A1929)
          : const Color(0xFFE8F4F8),
      body: _currentIndex == 0
          ? ToDoListScreen(
              todos: todos,
              onTodosChanged: (updatedTodos) {
                setState(() {
                  todos = updatedTodos;
                });
              },
              isDarkMode: isDark,
            )
          : SettingsScreen(
              isDarkMode: isDark,
              onThemeChanged: widget.onThemeChanged,
              currentLanguage: widget.currentLanguage,
              onLanguageChanged: widget.onLanguageChanged,
            ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(isDark),
    );
  }

  Widget _buildFAB() {
    final isSettings = _currentIndex == 1;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSettings
              ? [
                  const Color(0xFFE53935),
                  const Color(0xFFD32F2F),
                ] // Red gradient for logout
              : [
                  const Color(0xFF5EBBF5),
                  const Color(0xFF2B7FE8),
                ], // Blue gradient for add
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isSettings
                ? const Color(0x66E53935) // Red shadow
                : const Color(0x662B7FE8), // Blue shadow
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          if (_currentIndex == 0) {
            _showAddTodoDialog();
          } else {
            _showLogoutDialog();
          }
        },
        child: Icon(
          isSettings ? Icons.logout : Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return BottomAppBar(
      color: isDark ? const Color(0xFF132F4C) : Colors.white,
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.view_list_rounded,
                color: _currentIndex == 0
                    ? const Color(0xFF5EBBF5)
                    : (isDark ? Colors.grey[600] : Colors.grey[400]),
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            const SizedBox(width: 64),
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: _currentIndex == 1
                    ? const Color(0xFF5EBBF5)
                    : (isDark ? Colors.grey[600] : Colors.grey[400]),
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog() {
    final locale = AppLocalizations.of(context);
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            locale.addNewTask,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: locale.taskTitle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF5EBBF5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detailsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: locale.taskDetails,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF5EBBF5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF5EBBF5)),
                        const SizedBox(width: 12),
                        Text(
                          '${locale.time}${selectedTime.format(context)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF5EBBF5),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${locale.date}${DateFormat('dd-MM-yyyy').format(selectedDate)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(locale.cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    todos.add(
                      TodoItem(
                        title: titleController.text,
                        details: detailsController.text,
                        time: selectedTime,
                        date: selectedDate,
                        isCompleted: false,
                      ),
                    );
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        locale.taskAdded,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(
                        0xFF4CAF50,
                      ), // Green for success
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B7FE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(locale.add, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    final locale = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          locale.logout,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(locale.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              locale.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add your logout logic here

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    locale.logoutSuccess,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(locale.logout, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

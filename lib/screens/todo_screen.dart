import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/classes/app_localizations.dart';
import 'package:todo/classes/todo_item.dart';
import 'package:todo/screens/edit_screen.dart';

class ToDoListScreen extends StatefulWidget {
  final List<TodoItem> todos;
  final Function(List<TodoItem>) onTodosChanged;
  final bool isDarkMode;

  const ToDoListScreen({
    super.key,
    required this.todos,
    required this.onTodosChanged,
    required this.isDarkMode,
  });

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  int selectedDayIndex = 1;
  bool _isDeleteDialogOpen = false;

  // ignore: unused_field
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late PageController _pageController = PageController(initialPage: 0);

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Calculate initial page to show current week
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStartOfYear = now.difference(startOfYear).inDays;
    final initialPage = (daysSinceStartOfYear / 5).floor();

    _pageController = PageController(initialPage: initialPage);
    _selectedDay = now;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Column(
      children: [
        Stack(
          children: [
            _buildHeader(locale),
            Padding(
              padding: const EdgeInsets.only(top: 75),
              child: _buildMonthYearSelector(locale),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: _buildDateSelector(locale),
            ),
          ],
        ),

        Expanded(child: _buildTodoList()),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations locale) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
        ),
      ),
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        locale.appTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMonthYearSelector(AppLocalizations locale) {
    final isDark = widget.isDarkMode;

    final months = locale.getMonths();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Month Dropdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF132F4C)
                        : const Color(0xE6FFFFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF2B7FE8),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF2B7FE8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: isDark
                          ? const Color(0xFF132F4C)
                          : Colors.white,
                      items: List.generate(12, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text(months[index]),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMonth = value;
                            _updateDateSelection();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Year Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF132F4C)
                      : const Color(0xE6FFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF2B7FE8),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF2B7FE8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    dropdownColor: isDark
                        ? const Color(0xFF132F4C)
                        : Colors.white,
                    items: List.generate(10, (index) {
                      final year = DateTime.now().year - 3 + index;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedYear = value;
                          _updateDateSelection();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTodayButton(locale),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTodayButton(AppLocalizations locale) {
    final isDark = widget.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _resetToToday,
          child: Center(
            child: Container(
              width: Localizations.localeOf(context).languageCode == 'fr'
                  ? 120
                  : 100,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF132F4C) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, isDark ? 0.3 : 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.today, color: Color(0xFF2B7FE8), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    locale.today,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF2B7FE8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateDateSelection() {
    final newDate = DateTime(_selectedYear, _selectedMonth, 1);
    final startOfYear = DateTime(_selectedYear, 1, 1);
    final daysSinceStartOfYear = newDate.difference(startOfYear).inDays;
    final newPage = (daysSinceStartOfYear / 5).floor();

    setState(() {
      _selectedDay = newDate;
      _focusedDay = newDate;
    });

    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _resetToToday() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStartOfYear = now.difference(startOfYear).inDays;
    final todayPage = (daysSinceStartOfYear / 5).floor();

    setState(() {
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now;
      _focusedDay = now;
    });

    _pageController.animateToPage(
      todayPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDateSelector(AppLocalizations locale) {
    final isDark = widget.isDarkMode;
    final now = DateTime.now();

    // Start from January 1st of selected year
    final startOfYear = DateTime(_selectedYear, 1, 1);

    // Calculate total days in the selected year
    final endOfYear = DateTime(_selectedYear, 12, 31);
    final totalDays = endOfYear.difference(startOfYear).inDays + 1;

    final allDays = List.generate(totalDays, (index) {
      return startOfYear.add(Duration(days: index));
    });

    final dayNames = [
      locale.mon,
      locale.tue,
      locale.wed,
      locale.thu,
      locale.fri,
      locale.sat,
      locale.sun,
    ];

    return Column(
      children: [
        SizedBox(
          height: 90,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              final newFocusedDay = startOfYear.add(Duration(days: page * 5));

              setState(() {
                _focusedDay = newFocusedDay;

                // Update month and year when swiping
                if (_selectedMonth != newFocusedDay.month ||
                    _selectedYear != newFocusedDay.year) {
                  _selectedMonth = newFocusedDay.month;
                  _selectedYear = newFocusedDay.year;
                }
              });
            },
            itemCount: (totalDays / 5).ceil(),
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * 5;
              final endIndex = (startIndex + 5).clamp(0, allDays.length);
              final pageDays = allDays.sublist(startIndex, endIndex);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pageDays.asMap().entries.map((entry) {
                  final date = entry.value;
                  final isSelected = isSameDay(date, _selectedDay);
                  final isToday = isSameDay(date, now);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                      });
                    },
                    child: Container(
                      width: 68,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? isDark
                                  ? const Color(0xFF132F4C)
                                  : Colors.white
                            : isDark
                            ? const Color(0xFF132F4C)
                            : const Color(0xE6FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected
                            ? Border.all(
                                color: const Color(0xFF2B7FE8),
                                width: 2,
                              )
                            : Border.all(
                                color: isDark
                                    ? const Color(0xFF132F4C)
                                    : Colors.white,
                                width: 2,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0x4A000000),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayNames[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF2B7FE8)
                                  : isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFF2B7FE8)
                                  : isDark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodoList() {
    final locale = AppLocalizations.of(context);
    final isDark = widget.isDarkMode;

    // Filter todos by selected date
    final filteredTodos = widget.todos.where((todo) {
      return isSameDay(todo.date, _selectedDay);
    }).toList();

    if (filteredTodos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0x332B7FE8), const Color(0x335EBBF5)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist_rounded,
                size: 60,
                color: isDark
                    ? const Color(0x995EBBF5)
                    : const Color(0x992B7FE8),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              locale.noTasks,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              locale.noTasksMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (Localizations.localeOf(context).languageCode == 'fr' || Localizations.localeOf(context).languageCode == 'ru')
                    ? 14
                    : 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            // Hint
            Text(
              locale.addTaskHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            // Action button hint
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   decoration: BoxDecoration(
            //     gradient: const LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
            //     ),
            //     borderRadius: BorderRadius.circular(30),
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0x4D2B7FE8),
            //         blurRadius: 12,
            //         offset: const Offset(0, 6),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(
            //         Icons.add_circle_outline,
            //         color: Colors.white,
            //         size: 20,
            //       ),
            //       const SizedBox(width: 8),
            //       Text(
            //         locale.addNewTask,
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        // Get the original index from widget.todos
        final originalIndex = widget.todos.indexOf(filteredTodos[index]);
        return _buildTodoItem(filteredTodos[index], originalIndex);
      },
    );
  }

  Widget _buildTodoItem(TodoItem todo, int index) {
    final isDark = widget.isDarkMode;
    final locale = AppLocalizations.of(context);

    return Dismissible(
      key: Key('${todo.title}_$index'),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: AlignmentDirectional.centerStart,
        padding: Localizations.localeOf(context).languageCode == 'ar'
            ? EdgeInsets.only(right: 20)
            : EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Text(
              locale.delete,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditTaskScreen(todo: todo, isDarkMode: isDark),
            ),
          );

          if (result != null && result is TodoItem) {
            setState(() {
              widget.todos[index] = result;
            });
            widget.onTodosChanged(widget.todos);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF132F4C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: todo.isCompleted
                          ? [const Color(0xFF00FF08), const Color(0xFF81C784)]
                          : [const Color(0xFF2B7FE8), const Color(0xFF5EBBF5)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: todo.isCompleted
                              ? const Color(0xFF00FF00)
                              : const Color(0xFF5EBBF5),
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (todo.details.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.details,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd-MM-yyyy').format(todo.date),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 25),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                todo.time.format(context),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.todos[index].isCompleted =
                          !widget.todos[index].isCompleted;
                    });
                    widget.onTodosChanged(widget.todos);
                  },
                  child: todo.isCompleted
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF37C83C),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context).done,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x4D2B7FE8),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      onUpdate: (details) {
        if (details.progress > 0.3) {
          if (details.reached) {
            _showDeleteConfirmation(index);
          }
        }
      },
    );
  }

  void _showDeleteConfirmation(int index) {
    final locale = AppLocalizations.of(context);

    if (_isDeleteDialogOpen) return;

    _isDeleteDialogOpen = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          locale.deleteTask,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(locale.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _isDeleteDialogOpen = false;
            },
            child: Text(
              locale.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.todos.removeAt(index);
              });
              widget.onTodosChanged(widget.todos);
              _isDeleteDialogOpen = false;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    locale.taskDeleted,
                    style: TextStyle(color: Colors.white),
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
            child: Text(locale.delete, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

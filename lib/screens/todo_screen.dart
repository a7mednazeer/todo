import 'package:flutter/material.dart';
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

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Column(
      children: [
        _buildHeader(locale),
        _buildDateSelector(locale),
        Expanded(child: _buildTodoList()),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations locale) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Text(
        locale.appTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDateSelector(AppLocalizations locale) {
    final isDark = widget.isDarkMode;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final totalDays = 35;
    final allDays = List.generate(totalDays, (index) {
      return startOfWeek.add(Duration(days: index));
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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7FE8), Color(0xFF5EBBF5)],
        ),
      ),
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: SizedBox(
        height: 90,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _focusedDay = startOfWeek.add(Duration(days: page * 5));
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
                      selectedDayIndex = entry.key;
                    });
                  },
                  child: Container(
                    width: 68,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? isDark
                                ? const Color(0xFF132F4C)
                                : Colors.white
                          : isDark
                          ? const Color(0xFF132F4C)
                          : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
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
                            fontSize: 13,
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
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTodoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: widget.todos.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(widget.todos[index], index);
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
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
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
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
                            Icons.access_time,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            todo.time.format(context),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
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
                  content: Text(locale.taskDeleted),
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

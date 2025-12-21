import 'package:flutter/material.dart';

class TodoItem {
  String title;
  String details;
  TimeOfDay time;
  DateTime date;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.details,
    required this.time,
    required this.date,
    required this.isCompleted,
  });
}

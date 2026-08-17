import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String id;
  String title;
  String details;
  TimeOfDay time;
  DateTime date;
  bool isCompleted;

  TodoItem({
    this.id = '',
    required this.title,
    required this.details,
    required this.time,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'hour': time.hour,
      'minute': time.minute,
      'date': Timestamp.fromDate(date),
      'isCompleted': isCompleted,
    };
  }

  factory TodoItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TodoItem(
      id: doc.id,
      title: data['title'] ?? '',
      details: data['details'] ?? '',
      time: TimeOfDay(
        hour: data['hour'] ?? 0,
        minute: data['minute'] ?? 0,
      ),
      date: (data['date'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}

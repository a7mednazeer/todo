import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  group('TodoItem Model Tests', () {
    test('toMap() converts correctly for Firestore', () {
      final date = DateTime(2026, 8, 17);
      final item = TodoItem(
        title: 'Test Task',
        details: 'Test Details',
        time: const TimeOfDay(hour: 10, minute: 30),
        date: date,
        isCompleted: false,
      );

      final map = item.toMap();

      expect(map['title'], 'Test Task');
      expect(map['hour'], 10);
      expect(map['minute'], 30);
      expect(map['date'], isA<Timestamp>());
      expect(map['isCompleted'], false);
    });

    test('TodoItem equality/creation with ID', () {
      final item = TodoItem(
        id: '123',
        title: 'Title',
        details: 'Details',
        time: const TimeOfDay(hour: 1, minute: 0),
        date: DateTime.now(),
        isCompleted: true,
      );

      expect(item.id, '123');
      expect(item.isCompleted, true);
    });
  });
}

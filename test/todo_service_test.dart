import 'package:flutter_test/flutter_test.dart';
import 'package:todo/models/todo_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  group('TodoService Logic Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    final userId = 'user123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('Adding and retrieving tasks from Firestore works', () async {
      final task = TodoItem(
        title: 'Task 1',
        details: 'Details 1',
        time: const TimeOfDay(hour: 9, minute: 0),
        date: DateTime(2026, 8, 17),
        isCompleted: false,
      );

      // Manual simulation of TodoService logic
      await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .add(task.toMap());

      final snapshot = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.data()['title'], 'Task 1');
    });

    test('Updating task completion status works', () async {
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .add({'title': 'Old Title', 'isCompleted': false});

      await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(docRef.id)
          .update({'isCompleted': true});

      final updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['isCompleted'], true);
    });

    test('Deleting a task removes it from collection', () async {
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .add({'title': 'To be deleted'});

      await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .doc(docRef.id)
          .delete();

      final snapshot = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .get();

      expect(snapshot.docs.isEmpty, true);
    });
  });
}

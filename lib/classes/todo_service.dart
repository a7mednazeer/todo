import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/classes/todo_item.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference _getTodoCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('todos');
  }

  // Get tasks stream
  Stream<List<TodoItem>> getTodos(String userId) {
    return _getTodoCollection(userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TodoItem.fromFirestore(doc)).toList();
    });
  }

  // Add task
  Future<void> addTodo(String userId, TodoItem item) async {
    await _getTodoCollection(userId).add(item.toMap());
  }

  // Update task
  Future<void> updateTodo(String userId, TodoItem item) async {
    await _getTodoCollection(userId).doc(item.id).update(item.toMap());
  }

  // Toggle completion
  Future<void> toggleComplete(String userId, String taskId, bool currentStatus) async {
    await _getTodoCollection(userId).doc(taskId).update({
      'isCompleted': !currentStatus,
    });
  }

  // Delete task
  Future<void> deleteTodo(String userId, String taskId) async {
    await _getTodoCollection(userId).doc(taskId).delete();
  }
}

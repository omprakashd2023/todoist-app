import 'package:flutter/material.dart';

import '../common/utils/utils.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  void addTodo({required Todo todo}) {
    final index = _todos.indexWhere((element) => element.id == todo.id);
    if (index == -1) {
      _todos.add(todo);
    } else {
      _todos.removeAt(index);
      _todos.insert(index, todo);
    }
    notifyListeners();
  }

  void removeTodo({required String id}) {
    _todos.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void editTodo({required Todo todo}) {
    final index = _todos.indexWhere((element) => element.id == todo.id);
    _todos[index] = todo;
    notifyListeners();
  }

  void setTodos({required List<Todo> todos}) {
    _todos = todos;
    notifyListeners();
  }

  Todo getTodoById({required String id}) {
    return _todos.firstWhere((element) => element.id == id);
  }

  List<Todo> get allTodos {
    return [..._todos];
  }

  List<Todo> get completedTodos {
    return _todos
        .where((element) => element.status == Status.completed)
        .toList();
  }

  List<Todo> sortedTodos() {
    _todos.sort((a, b) {
      final dueDateComparison = a.dueDate.compareTo(b.dueDate);
      if (dueDateComparison != 0) {
        if (dueDateComparison == -1) {
          return a.status == Status.completed ? 1 : -1;
        } else {
          return b.status == Status.completed ? -1 : 1;
        }
      }

      final statusOrder = <Status>[
        Status.notStarted,
        Status.inProgress,
        Status.completed
      ];
      final statusComparison = statusOrder
          .indexOf(a.status)
          .compareTo(statusOrder.indexOf(b.status));
      if (statusComparison != 0) {
        return statusComparison;
      }
      
      return a.createdAt.compareTo(b.createdAt);
    });

    return [..._todos];
  }
}

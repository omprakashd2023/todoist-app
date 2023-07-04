import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../provider/user_provider.dart';
import '../../../provider/todo_provider.dart';

import '../../../models/todo.dart';

import '../../../common/utils/error_handling.dart';
import '../../../common/utils/utils.dart';

class HomeServices {
  final _url = '${dotenv.env['SERVER_URL']}/todo';
  Future<void> createTodo({
    required BuildContext context,
    required Todo todo,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token') ?? '';
      final uri = Uri.parse('$_url/create');
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: todo.toJson(),
      );
      if (response.statusCode == 200) {
        final todo = Todo.fromMap(
          jsonDecode(response.body)["todo"],
        );
        httpErrorHandle(
            response: response,
            context: context,
            onSuccess: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .addTodo(todo: todo);
              showSnackBar(
                context,
                'Todo created successfully',
              );
            });
      } else {
        showSnackBar(
          context,
          'Something went wrong',
        );
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Future<void> fetchAllTodos({
    required BuildContext context,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final url = Uri.parse('$_url/all/${user.id}');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      List<Todo> todos = [];
      todos = (jsonDecode(response.body)["todos"] as List)
          .map((todo) => Todo.fromMap(todo))
          .toList();
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          Provider.of<TodoProvider>(context, listen: false)
              .setTodos(todos: todos);
        },
      );
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Future<Todo> getTodoById({
    required BuildContext context,
    required String id,
  }) async {
    final url = Uri.parse('$_url/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';
    Todo todo = Todo(
      userId: '',
      id: '',
      title: '',
      description: '',
      dueDate: DateTime.now(),
      status: Status.notStarted,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      todo = Todo.fromJson(
        jsonEncode(
          jsonDecode(response.body)["todo"],
        ),
      );
      return todo;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    return todo;
  }

  Future<void> updateTodo({
    required BuildContext context,
    required String id,
    String? title,
    String? description,
    DateTime? dueDate,
    Status? status,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';
    final url = Uri.parse('$_url/$id');
    final todo =
        Provider.of<TodoProvider>(context, listen: false).getTodoById(id: id);
    try {
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode(
            <String, dynamic>{
              'title': title ?? todo.title,
              'description': description ?? todo.description,
              'dueDate': dueDate != null
                  ? dueDate.millisecondsSinceEpoch
                  : todo.dueDate.millisecondsSinceEpoch,
              'status': status != null ? status.name : todo.status.name,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
            },
          ));
      if (response.statusCode == 200) {
        final todo = Todo.fromJson(
          jsonEncode(
            jsonDecode(response.body)["todo"],
          ),
        );
        httpErrorHandle(
            response: response,
            context: context,
            onSuccess: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .addTodo(todo: todo);
              showSnackBar(
                context,
                'Todo updated successfully',
              );
            });
      } else {
        showSnackBar(
          context,
          'Something went wrong',
        );
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  Future<void> deleteTodo({
    required BuildContext context,
    required String id,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token') ?? '';
    final url = Uri.parse('$_url/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          Provider.of<TodoProvider>(context, listen: false).removeTodo(
            id: id,
          );
          showSnackBar(
            context,
            'Todo deleted successfully',
          );
        },
      );
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/utils.dart';

import '../services/home_service.dart';

import '../../../routes.dart';

import '../../../models/todo.dart';

class TodoDetailPage extends StatefulWidget {
  final Todo todo;

  const TodoDetailPage({
    super.key,
    required this.todo,
  });

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final HomeServices _homeServices = HomeServices();

  bool isLoading = false;

  Color _getStatusColor() {
    if (widget.todo.status == Status.inProgress) {
      return Colors.blueAccent;
    } else if (widget.todo.status == Status.completed) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }

  void _deleteTodo() {
    setState(() {
      isLoading = true;
    });
    _homeServices
        .deleteTodo(
      context: context,
      id: widget.todo.id!,
    )
        .then((_) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  void _editTodo(){
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(
      Routes.newTodoRoute,
      arguments: widget.todo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            onPressed: _editTodo,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: _deleteTodo,
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.todo.title,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Status:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.todo.status == Status.inProgress
                                    ? 'In Progress'
                                    : widget.todo.status == Status.completed
                                        ? 'Completed'
                                        : 'Not Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.todo.description,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Due Date:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().format(widget.todo.dueDate),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

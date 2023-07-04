import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/utils.dart';

import '../../../provider/user_provider.dart';

import '../services/home_service.dart';

import '../../../models/todo.dart';

// ignore: must_be_immutable
class TodoTaskInputPage extends StatefulWidget {
  Todo? todo;
  TodoTaskInputPage({
    super.key,
    this.todo,
  });

  @override
  State<TodoTaskInputPage> createState() => _TodoTaskInputPageState();
}

class _TodoTaskInputPageState extends State<TodoTaskInputPage> {
  final HomeServices _homeServices = HomeServices();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  late Status _selectedStatus;

  bool isLoading = false;

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTodoTask() {
    setState(() {
      isLoading = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final DateTime dueDate = _selectedDate!;
    final Status status = _selectedStatus;

    final todo = Todo(
      userId: user.id,
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      createdAt: DateTime.now(),
    );
    if (widget.todo != null) {
      _homeServices
          .updateTodo(
        context: context,
        id: widget.todo!.id!,
        title: title,
        description: description,
        dueDate: dueDate,
        status: status,
      )
          .then(
        (_) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    } else {
      _homeServices.createTodo(context: context, todo: todo).then(
        (_) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _selectedDate = widget.todo!.dueDate;
      _selectedStatus = widget.todo!.status;
    } else {
      _selectedStatus = Status.notStarted;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Todo Task'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Due Date:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat.yMd().format(_selectedDate!)
                              : 'Select a date',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      ChoiceChip(
                        selectedColor: Colors.red,
                        backgroundColor: Colors.redAccent,
                        label: const Text(
                          'Not Started',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        selected: _selectedStatus == Status.notStarted,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedStatus = Status.notStarted;
                          });
                        },
                      ),
                      ChoiceChip(
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.blueAccent,
                        label: const Text(
                          'In Progress',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        selected: _selectedStatus == Status.inProgress,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedStatus = Status.inProgress;
                          });
                        },
                      ),
                      ChoiceChip(
                        selectedColor: Colors.green,
                        backgroundColor: Colors.greenAccent,
                        label: const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        selected: _selectedStatus == Status.completed,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedStatus = Status.completed;
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveTodoTask,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

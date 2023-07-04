import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/colors.dart';
import '../services/home_service.dart';

import '../../../routes.dart';

import '../../../common/utils/utils.dart';

class TodoItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Status status;

  const TodoItem({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.id,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  final HomeServices _homeServices = HomeServices();

  void navigateToTodoDetailPage(BuildContext context) async {
    final todo = await _homeServices.getTodoById(
      context: context,
      id: widget.id,
    );

    if (todo.title != '') {
      Navigator.of(context).pushNamed(
        Routes.todoDetailRoute,
        arguments: todo,
      );
    } else {
      showSnackBar(
        context,
        'Todo not found',
      );
    }
  }

  void _updateTodoStatus(BuildContext context, bool value) {
    _homeServices.updateTodo(
      context: context,
      id: widget.id,
      status: Status.inProgress == widget.status
          ? Status.completed
          : Status.inProgress,
    );
  }

  void _deleteTodo(BuildContext context) {
    _homeServices.deleteTodo(
      context: context,
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    bool isCompleted = widget.status == Status.completed ? true : false;
    switch (widget.status) {
      case Status.notStarted:
        statusColor = Colors.redAccent;
        break;
      case Status.inProgress:
        statusColor = Colors.blueAccent;
        break;
      case Status.completed:
        statusColor = Colors.greenAccent;
        break;
    }

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        height: 160.0,
        width: MediaQuery.of(context).size.width * 0.46,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ).copyWith(right: 16.0),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.error,
        ),
        child: const Icon(
          size: 32.0,
          Icons.delete,
          color: Colors.white,
        ),
      ),
      key: Key(widget.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteTodo(
            context,
          );
        }
      },
      child: GestureDetector(
        onTap: () => navigateToTodoDetailPage(context),
        child: SizedBox(
          height: 160,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ).copyWith(
                right: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 160,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        Text(
                          'Due Date: ${DateFormat.yMEd().format(widget.dueDate)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Center(
                    child: Checkbox(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colours.grey;
                        }
                        return Theme.of(context).colorScheme.tertiary;
                      }),
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted =
                              value! && widget.status == Status.inProgress;
                        });
                        widget.status == Status.inProgress ||
                                widget.status == Status.completed
                            ? _updateTodoStatus(
                                context,
                                value!,
                              )
                            : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

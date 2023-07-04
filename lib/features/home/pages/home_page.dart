import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/todo.dart';
import '../../../provider/todo_provider.dart';
import '../../../provider/user_provider.dart';

import '../services/home_service.dart';
import '../../auth/services/auth_services.dart';

import '../widgets/search_bar.dart';
import '../widgets/todo_item.dart';

import '../../../common/utils/utils.dart';

import '../../../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeServices _homeServices = HomeServices();
  final AuthServices _authServices = AuthServices();
  bool isLoading = true;
  List<Todo> allTodos = [];
  List<Todo> filteredTodos = [];
  List<Todo> searchedTodos = [];
  bool isNotStarted = false, isInProgress = false, isCompleted = false;
  final TextEditingController _searchController = TextEditingController();

  void _navigateToNewTodoPage(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.newTodoRoute);
  }

  @override
  void initState() {
    startTimer();
    _homeServices.fetchAllTodos(context: context).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      if (allTodos.isEmpty) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _searchTodos(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      searchedTodos = filteredTodos;
    } else {
      searchedTodos = filteredTodos
          .where(
            (todo) =>
                todo.title.toLowerCase().contains(
                      enteredKeyword.toLowerCase(),
                    ) ||
                todo.description.toLowerCase().contains(
                      enteredKeyword.toLowerCase(),
                    ),
          )
          .toList();
    }
    setState(() {
      filteredTodos = searchedTodos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final todoProvider = Provider.of<TodoProvider>(context);
    if (!isNotStarted &&
        !isInProgress &&
        !isCompleted &&
        searchedTodos.isEmpty) {
      allTodos = filteredTodos = todoProvider.sortedTodos();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoist'),
        actions: [
          IconButton(
            onPressed: () => _authServices.logout(context: context),
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _authServices.logout(context: context),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : allTodos.isEmpty
              ? const Center(
                  child: Text('No Todos...'),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SearchBar(
                            search: _searchTodos,
                            searchController: _searchController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _searchController.clear();
                                  searchedTodos = [];
                                  filteredTodos = allTodos;
                                  isNotStarted =
                                      isInProgress = isCompleted = false;
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your Tasks',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).textTheme.displayMedium!.color,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 35.0,
                            width: double.infinity,
                            child: Text(
                              'You have [${filteredTodos.where(
                                    (todo) => todo.status != Status.completed,
                                  ).toList().length}] pending tasks out of [${filteredTodos.length}].',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilterChip(
                            selectedColor: Colors.red,
                            selected: isNotStarted,
                            label: const Text(
                              'Not Started',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onSelected: (value) {
                              setState(() {
                                isNotStarted = value;
                                isInProgress =
                                    isInProgress == true ? false : isInProgress;
                                isCompleted =
                                    isCompleted == true ? false : isCompleted;
                                filteredTodos = allTodos
                                    .where(
                                      (todo) =>
                                          todo.status == Status.notStarted ||
                                          (todo.status == Status.inProgress &&
                                              isInProgress) ||
                                          (todo.status == Status.completed &&
                                              isCompleted),
                                    )
                                    .toList();
                              });
                            },
                            backgroundColor: Colors.redAccent,
                          ),
                          FilterChip(
                            selectedColor: Colors.blue,
                            selected: isInProgress,
                            label: const Text(
                              'InProgress',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onSelected: (value) {
                              setState(() {
                                isInProgress = value;
                                isNotStarted =
                                    isNotStarted == true ? false : isNotStarted;
                                isCompleted =
                                    isCompleted == true ? false : isCompleted;
                                filteredTodos = allTodos
                                    .where(
                                      (todo) =>
                                          todo.status == Status.inProgress ||
                                          (todo.status == Status.notStarted &&
                                              isNotStarted) ||
                                          (todo.status == Status.completed &&
                                              isCompleted),
                                    )
                                    .toList();
                              });
                            },
                            backgroundColor: Colors.blueAccent,
                          ),
                          FilterChip(
                            selectedColor: Colors.green,
                            selected: isCompleted,
                            label: const Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onSelected: (value) {
                              setState(() {
                                isCompleted = value;
                                isInProgress =
                                    isInProgress == true ? false : isInProgress;
                                isNotStarted =
                                    isNotStarted == true ? false : isNotStarted;
                                filteredTodos = allTodos
                                    .where(
                                      (todo) =>
                                          todo.status == Status.completed ||
                                          (todo.status == Status.notStarted &&
                                              isNotStarted) ||
                                          (todo.status == Status.inProgress &&
                                              isInProgress),
                                    )
                                    .toList();
                              });
                            },
                            backgroundColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: ListView.builder(
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return TodoItem(
                              id: todo.id!,
                              title: todo.title,
                              description: todo.description,
                              dueDate: todo.dueDate,
                              status: todo.status,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNewTodoPage(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

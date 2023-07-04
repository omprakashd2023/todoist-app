import 'dart:convert';

import '../../../common/utils/utils.dart';

class Todo {
  final String? id;
  final String title;
  final String description;
  final String userId;
  final DateTime dueDate;
  final Status status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    DateTime? dueDate,
    Status? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt != null ? updatedAt!.millisecondsSinceEpoch : null,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      userId: map['userId'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      status: Status.values
          .firstWhere((element) => element.name == map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);
}

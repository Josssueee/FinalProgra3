import 'package:intl/intl.dart';

class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  bool hasNotification;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.hasNotification = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'hasNotification': hasNotification ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      hasNotification: map['hasNotification'] == 1,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    bool? hasNotification,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  String get formattedDueDate {
    return DateFormat('dd/MM/yyyy').format(dueDate);
  }
}

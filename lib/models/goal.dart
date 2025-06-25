import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String id;
  String title;
  String description;
  DateTime targetDate;
  List<SubGoal> subGoals;
  double progress;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.subGoals,
    this.progress = 0.0,
  });

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
    List<SubGoal>? subGoals,
    double? progress,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      subGoals: subGoals ?? this.subGoals,
      progress: progress ?? this.progress,
    );
  }

  factory Goal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Goal(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      targetDate: (data['targetDate'] as Timestamp).toDate(),
      subGoals: (data['subGoals'] as List<dynamic>? ?? []).map((sg) {
        return SubGoal(
          id: sg['id'] ?? '',
          title: sg['title'] ?? '',
          isCompleted: sg['isCompleted'] ?? false,
          dueDate: sg['dueDate'] != null
              ? (sg['dueDate'] as Timestamp).toDate()
              : null,
        );
      }).toList(),
    )..updateProgress();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'targetDate': Timestamp.fromDate(targetDate),
      'progress': progress,
      'subGoals': subGoals.map((sg) => sg.toMap()).toList(),
    };
  }

  void updateProgress() {
    if (subGoals.isEmpty) {
      progress = 0.0;
      return;
    }
    int completed = subGoals.where((sg) => sg.isCompleted).length;
    progress = (completed / subGoals.length) * 100;
  }
}

class SubGoal {
  final String id;
  String title;
  bool isCompleted;
  DateTime? dueDate;

  SubGoal({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }
}

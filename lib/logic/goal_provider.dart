import 'package:flutter/foundation.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/services/goal_service.dart';

class GoalProvider with ChangeNotifier {
  late GoalService _goalService;
  List<Goal> _goals = [];
  bool _isLoading = false;
  String? _error;

  GoalProvider(GoalService goalService) {
    _goalService = goalService;
  }

  void updateGoalService(GoalService goalService) {
    _goalService = goalService;
  }

  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Goal> get activeGoals => _goals.where((g) => g.progress < 100).toList();

  List<Goal> get completedGoals =>
      _goals.where((g) => g.progress >= 100).toList();

  Future<void> loadGoals() async {
    try {
      _isLoading = true;
      notifyListeners();

      _goals = await _goalService.getGoalsOnce();
      _error = null;
    } catch (e) {
      _error = "فشل في تحميل الأهداف: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGoal(Goal goal) async {
    try {
      await _goalService.addGoal(goal);
      await loadGoals();
    } catch (e) {
      _error = "فشل في إضافة الهدف: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await _goalService.updateGoal(goal);
      await loadGoals();
    } catch (e) {
      _error = "فشل في تحديث الهدف: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _goalService.deleteGoal(goalId);
      _goals.removeWhere((g) => g.id == goalId);
      notifyListeners();
    } catch (e) {
      _error = "فشل في حذف الهدف: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<Goal?> toggleSubGoal(
    String goalId,
    String subGoalId,
    bool isCompleted,
  ) async {
    try {
      await _goalService.toggleSubGoal(goalId, subGoalId, isCompleted);

      final goalIndex = _goals.indexWhere((g) => g.id == goalId);
      if (goalIndex != -1) {
        final updatedSubGoals = _goals[goalIndex].subGoals.map((sg) {
          if (sg.id == subGoalId) {
            return SubGoal(
              id: sg.id,
              title: sg.title,
              isCompleted: isCompleted,
              dueDate: sg.dueDate,
            );
          }
          return sg;
        }).toList();

        final updatedGoal = _goals[goalIndex].copyWith(
          subGoals: updatedSubGoals,
        );

        updatedGoal.updateProgress();
        _goals[goalIndex] = updatedGoal;
        notifyListeners();
        return updatedGoal;
      }
    } catch (e) {
      _error = "فشل في تحديث الهدف الفرعي: ${e.toString()}";
      notifyListeners();
    }
    return null;
  }
}

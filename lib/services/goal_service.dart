import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawah/models/goal.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _goalsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(userId).collection('goals');
  }

  Future<void> addGoal(Goal goal) async {
    await _goalsCollection.add(goal.toFirestore());
  }

  Future<void> updateGoal(Goal goal) async {
    await _goalsCollection.doc(goal.id).update(goal.toFirestore());
  }

  Future<void> deleteGoal(String goalId) async {
    await _goalsCollection.doc(goalId).delete();
  }

  Future<void> toggleSubGoal(
    String goalId,
    String subGoalId,
    bool isCompleted,
  ) async {
    final goalRef = _goalsCollection.doc(goalId);
    final goalDoc = await goalRef.get();

    if (!goalDoc.exists) return;

    final goal = Goal.fromFirestore(goalDoc);
    final updatedSubGoals = goal.subGoals.map((sg) {
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

    await goalRef.update({
      'subGoals': updatedSubGoals.map((sg) => sg.toMap()).toList(),
    });
  }

  Future<List<Goal>> getGoalsOnce() async {
    final snapshot = await _goalsCollection
        .orderBy('targetDate', descending: false)
        .get();

    return snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList();
  }

  Stream<List<Goal>> getGoals() {
    return _goalsCollection
        .orderBy('targetDate', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList(),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/utils/app_colors.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const GoalCard({super.key, required this.goal, required this.onDelete});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoalProvider>(context, listen: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.teal[700],
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.yellow, width: 2.0),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: _buildProgressCircle(),
              title: Text(
                widget.goal.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                widget.goal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: widget.onDelete,
                  ),
                  IconButton(
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                ],
              ),
            ),
            if (_expanded) _buildSubGoalsList(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: widget.goal.progress / 100,
            strokeWidth: 4,
            backgroundColor: Colors.teal[600],
            color: Colors.amber,
          ),
        ),
        Text(
          '${widget.goal.progress.toInt()}%',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSubGoalsList(GoalProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.teal),
          const Text(
            'الأهداف الصغيرة:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.goal.subGoals.map((subGoal) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                title: Text(
                  subGoal.title,
                  style: TextStyle(
                    color: subGoal.isCompleted
                        ? Colors.greenAccent
                        : Colors.white,
                    decoration: subGoal.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  textAlign: TextAlign.right,
                ),
                secondary: subGoal.dueDate != null
                    ? Text(
                        '${subGoal.dueDate!.day}/${subGoal.dueDate!.month}',
                        style: const TextStyle(color: Colors.white70),
                      )
                    : null,
                value: subGoal.isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    provider.toggleSubGoal(widget.goal.id, subGoal.id, value);
                  }
                },
                activeColor: AppColors.accent,
                contentPadding: EdgeInsets.zero,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/screens/add_goal_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:confetti/confetti.dart';
import 'package:rawah/utils/app_sounds.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const GoalCard({super.key, required this.goal, required this.onDelete});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _expanded = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoalProvider>(context, listen: false);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onLongPress: _showOptionsSheet,
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
                trailing: IconButton(
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ),
              if (_expanded) _buildSubGoalsList(provider),
            ],
          ),
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
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
            child: Column(
              children: widget.goal.subGoals.map((subGoal) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CheckboxListTile(
                    title: Text(
                      subGoal.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: subGoal.isCompleted
                            ? Colors.greenAccent
                            : Colors.white,
                        decoration: subGoal.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    secondary: subGoal.dueDate != null
                        ? Text(
                            '${subGoal.dueDate!.day}/${subGoal.dueDate!.month}',
                            style: const TextStyle(color: Colors.white70),
                          )
                        : null,
                    value: subGoal.isCompleted,
                    activeColor: AppColors.accent,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) async {
                      if (value == null) return;
                      final wasCompleted = subGoal.isCompleted;
                      final updatedGoal = await provider.toggleSubGoal(
                        widget.goal.id,
                        subGoal.id,
                        value,
                      );

                      if (value && !wasCompleted && updatedGoal != null) {
                        if (updatedGoal.progress >= 100) {
                          AppSounds.playGoalComplete();
                          _confettiController.play();
                          _showGoalCompletedDialog(updatedGoal.title);
                        } else {
                          AppSounds.playSubGoalComplete();
                          _showSubGoalDialog(subGoal.title);
                        }
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubGoalDialog(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('💚 أحسنت', textAlign: TextAlign.center),
        content: Text(
          '🎯 لقد أنجزت "$title" بنجاح',
          textAlign: TextAlign.center,
        ),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('رائع'),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.teal[800],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'تعديل',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGoalScreen(goal: widget.goal),
                  ),
                );
                if (updated == true && mounted) {
                  Provider.of<GoalProvider>(context, listen: false).loadGoals();
                }
              },
            ),
            const Divider(color: Colors.white24, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'حذف',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      'تأكيد الحذف',
                      textAlign: TextAlign.right,
                    ),
                    content: const Text(
                      'هل تريد حذف هذا الهدف؟',
                      textAlign: TextAlign.right,
                    ),
                    actionsAlignment: MainAxisAlignment.end,
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

                if (confirmed == true) widget.onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalCompletedDialog(String title) {
    _confettiController.play();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        Future.delayed(
          const Duration(milliseconds: 300),
          () => _confettiController.play(),
        );
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.05,
                numberOfParticles: 40,
                gravity: 0.3,
                colors: const [
                  Colors.amber,
                  Colors.teal,
                  Colors.pink,
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                ],
              ),
            ),
            Center(
              child: Transform.scale(
                scale: animation.value,
                child: Opacity(
                  opacity: animation.value,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'أحسنت! 🎉',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لقد أكملت الهدف "$title" بنجاح 💪',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('رائع'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

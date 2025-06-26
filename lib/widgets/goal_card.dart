import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/logic/goal_provider.dart';
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
  Goal? _previousGoal;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _previousGoal = widget.goal;
  }

  @override
  void didUpdateWidget(GoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_previousGoal != null &&
        _previousGoal!.progress < 100 &&
        widget.goal.progress >= 100) {
      _celebrateMainGoal();
    }
    _previousGoal = widget.goal;
  }

  void _celebrateMainGoal() {
    AppSounds.playGoalComplete();
    _confettiController.play();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // مطلوب عشان showGeneralDialog
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Center(
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
                        'لقد أكملت الهدف "${widget.goal.title}" بنجاح 💪',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('رائع!'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
                    onChanged: (value) async {
                      if (value != null) {
                        final updatedGoal = await provider.toggleSubGoal(
                          widget.goal.id,
                          subGoal.id,
                          value,
                        );

                        if (value && updatedGoal != null) {
                          AppSounds.playSubGoalComplete();

                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: '',
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                                  return const SizedBox.shrink();
                                },
                            transitionBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return Transform.scale(
                                    scale: animation.value,
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            padding: const EdgeInsets.all(24),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
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
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 60,
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  'أحسنت! 💚',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'لقد أنجزت "${subGoal.title}" بنجاح 🎯',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.teal,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('رائع!'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                          );
                        }
                      }
                    },
                    activeColor: AppColors.accent,
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

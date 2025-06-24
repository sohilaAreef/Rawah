import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/services/goal_service.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/logic/goal_provider.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subGoalController = TextEditingController();

  DateTime? _targetDate;
  final List<SubGoal> _subGoals = [];
  DateTime? _subGoalDueDate;

  String formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إضافة هدف جديد',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.accent,
        ),
        body: Container(
          color: Colors.teal[900],
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: 'عنوان الهدف',
                  validator: (value) => value == null || value.isEmpty
                      ? 'الرجاء إدخال عنوان للهدف'
                      : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'وصف الهدف (اختياري)',
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildDateSelector(),
                const SizedBox(height: 20),
                _buildSubGoalsSection(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'حفظ الهدف',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _selectTargetDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'تاريخ الهدف',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _targetDate != null ? formatDate(_targetDate!) : 'اختر تاريخاً',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: _selectTargetDate,
        ),
      ],
    );
  }

  Widget _buildSubGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الأهداف الصغيرة:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10),
        if (_subGoals.isNotEmpty) ...[
          ..._subGoals.map((subGoal) {
            return Card(
              color: Colors.teal[800],
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  subGoal.title,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                subtitle: subGoal.dueDate != null
                    ? Text(
                        'تاريخ التسليم: ${formatDate(subGoal.dueDate!)}',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.right,
                      )
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      _subGoals.removeWhere((sg) => sg.id == subGoal.id);
                    });
                  },
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _subGoalController,
                label: 'إضافة هدف صغير',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 5),
                );
                if (date != null) {
                  setState(() => _subGoalDueDate = date);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.amber),
              onPressed: () {
                if (_subGoalController.text.isNotEmpty) {
                  setState(() {
                    _subGoals.add(
                      SubGoal(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _subGoalController.text,
                        isCompleted: false,
                        dueDate: _subGoalDueDate,
                      ),
                    );
                    _subGoalController.clear();
                    _subGoalDueDate = null;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() => _targetDate = date);
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate() && _targetDate != null) {
      final goal = Goal(
        id: '',
        title: _titleController.text,
        description: _descriptionController.text,
        targetDate: _targetDate!,
        subGoals: _subGoals,
      );

      goal.updateProgress();

      try {
        await Provider.of<GoalService>(context, listen: false).addGoal(goal);
        context.read<GoalProvider>().loadGoals();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء إدخال جميع البيانات المطلوبة',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

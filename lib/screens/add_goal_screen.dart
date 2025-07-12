import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/goal.dart';
import 'package:rawah/services/goal_service.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/logic/goal_provider.dart';

class AddGoalScreen extends StatefulWidget {
  final Goal? goal;
  const AddGoalScreen({super.key, this.goal});

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
  bool _showSubGoalError = false;
  bool _showDateError = false;

  String formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    final existingGoal = widget.goal;
    if (existingGoal != null) {
      _titleController.text = existingGoal.title;
      _descriptionController.text = existingGoal.description;
      _targetDate = existingGoal.targetDate;
      _subGoals.addAll(existingGoal.subGoals);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.goal != null ? 'تعديل الهدف' : 'إضافة هدف جديد',
            style: const TextStyle(color: Colors.white),
          ),

          backgroundColor: AppColors.accent,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: Colors.teal[900],
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'البيانات الأساسية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                _buildTextField(
                  controller: _titleController,
                  label: 'عنوان الهدف *',
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
                if (_showDateError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Text(
                      'الرجاء تحديد تاريخ للهدف',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.right,
                    ),
                  ),

                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'الأهداف الصغيرة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'الأهداف الصغيرة تساعدك على تقسيم هدفك الكبير إلى خطوات قابلة للتنفيذ',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),

                _buildSubGoalsSection(),
                if (_showSubGoalError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Text(
                      'الرجاء إضافة هدف صغير واحد على الأقل',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.right,
                    ),
                  ),

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
        suffixIcon: label.contains('*')
            ? const Icon(Icons.star, color: Colors.red, size: 12)
            : null,
      ),
      validator: validator,
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تاريخ الهدف *',
          style: TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectTargetDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _showDateError ? Colors.red : Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      Text(
                        _targetDate != null
                            ? formatDate(_targetDate!)
                            : 'اختر تاريخاً',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _selectTargetDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'اختيار التاريخ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_subGoals.isNotEmpty) ...[
          ..._subGoals.map((subGoal) {
            return Card(
              color: Colors.teal[800],
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal[600],
                  child: Text(
                    (_subGoals.indexOf(subGoal) + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  subGoal.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: subGoal.dueDate != null
                    ? Text(
                        'تاريخ التسليم: ${formatDate(subGoal.dueDate!)}',
                        style: const TextStyle(color: Colors.white70),
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
          }),
          const SizedBox(height: 20),
        ],

        Card(
          color: Colors.teal[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إضافة هدف صغير جديد',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subGoalController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'عنوان الهدف الصغير *',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.amber,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add, color: Colors.amber),
                      onPressed: _addSubGoal,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (_subGoalController.text.isNotEmpty) {
                      _addSubGoal();
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectSubGoalDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              Text(
                                _subGoalDueDate != null
                                    ? formatDate(_subGoalDueDate!)
                                    : 'إضافة تاريخ (اختياري)',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addSubGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'اضغط على Enter أو زر الإضافة لإدخال الهدف',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addSubGoal() {
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
        _showSubGoalError = false;
      });
    }
  }

  Future<void> _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _targetDate = date;
        _showDateError = false;
      });
    }
  }

  Future<void> _selectSubGoalDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _subGoalDueDate = date);
    }
  }

  Future<void> _saveGoal() async {
    bool isValid = true;

    if (_targetDate == null) {
      setState(() => _showDateError = true);
      isValid = false;
    }

    if (_subGoals.isEmpty) {
      setState(() => _showSubGoalError = true);
      isValid = false;
    }

    if (!_formKey.currentState!.validate()) {
      isValid = false;
    }

    if (!isValid) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (context.mounted) {
        Scrollable.ensureVisible(
          _formKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء إكمال جميع البيانات المطلوبة',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final goal = Goal(
      id: widget.goal?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      targetDate: _targetDate!,
      subGoals: _subGoals,
    );

    goal.updateProgress();

    final goalService = Provider.of<GoalService>(context, listen: false);

    try {
      if (widget.goal != null) {
        await goalService.updateGoal(goal);
      } else {
        await goalService.addGoal(goal);
      }

      context.read<GoalProvider>().loadGoals();

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ: $e',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

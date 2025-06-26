import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/goal_provider.dart';
import 'package:rawah/screens/add_goal_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/goal_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalProvider>().loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.accent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'أهدافي',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.amber),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Align(
                        alignment: Alignment.centerRight,
                        child: Text('عن الصفحة'),
                      ),
                      content: const Text(
                        'في هذه الصفحة يمكنك رؤية أهدافك وتتبع تقدمك فيها، سواء الأهداف النشطة أو المكتملة.',
                        textDirection: TextDirection.rtl,
                      ),
                      actions: [
                        TextButton(
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('حسناً'),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'الأهداف النشطة'),
              Tab(text: 'الأهداف المكتملة'),
            ],
          ),
        ),

        body: Consumer<GoalProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildGoalsList(provider, false),
                _buildGoalsList(provider, true),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.accent,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddGoalScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoalsList(GoalProvider provider, bool completed) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    final filteredGoals = completed
        ? provider.completedGoals
        : provider.activeGoals;

    if (filteredGoals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              completed ? Icons.celebration : Icons.rocket_launch,
              size: 60,
              color: Colors.white54,
            ),
            const SizedBox(height: 20),
            Text(
              completed
                  ? 'لا توجد أهداف مكتملة بعد'
                  : 'لا توجد أهداف نشطة حالياً',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredGoals.length,
      itemBuilder: (context, index) {
        return GoalCard(
          goal: filteredGoals[index],
          onDelete: () => provider.deleteGoal(filteredGoals[index].id),
        );
      },
    );
  }
}

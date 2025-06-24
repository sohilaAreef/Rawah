import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/emotion_provider.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/emotion_selector.dart';
import 'package:rawah/widgets/emotion_chart.dart';
import 'package:rawah/widgets/emotion_pie_chart.dart';
import 'package:rawah/widgets/emotion_history_list.dart';

class DailyEmotionTracker extends StatefulWidget {
  const DailyEmotionTracker({super.key});

  @override
  _DailyEmotionTrackerState createState() => _DailyEmotionTrackerState();
}

class _DailyEmotionTrackerState extends State<DailyEmotionTracker>
    with SingleTickerProviderStateMixin {
  EmotionType? _selectedEmotion;
  int _selectedIntensity = 3;
  final TextEditingController _notesController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final emotionProvider = Provider.of<EmotionProvider>(
        context,
        listen: false,
      );
      emotionProvider.loadEmotions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emotionProvider = Provider.of<EmotionProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'تتبع المشاعر اليومية',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            tabs: const [
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.history)),
              Tab(icon: Icon(Icons.insights)),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, AppColors.primary.withOpacity(0.05)],
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEmotionEntryTab(emotionProvider),

              EmotionHistoryList(emotions: emotionProvider.emotions),

              _buildChartsTab(emotionProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionEntryTab(EmotionProvider emotionProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'اختر مشاعرك اليوم',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  EmotionSelector(
                    selectedEmotion: _selectedEmotion,
                    selectedIntensity: _selectedIntensity,
                    onEmotionSelected: (type) =>
                        setState(() => _selectedEmotion = type),
                    onIntensitySelected: (intensity) =>
                        setState(() => _selectedIntensity = intensity),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملاحظات إضافية (اختياري)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: AppColors.accent),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'اكتب ملاحظاتك هنا...',
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              if (_selectedEmotion != null) {
                emotionProvider.addEmotion(
                  DailyEmotion(
                    type: _selectedEmotion!,
                    intensity: _selectedIntensity,
                    date: DateTime.now(),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم حفظ المشاعر بنجاح'),
                    backgroundColor: AppColors.accent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );

                setState(() {
                  _selectedEmotion = null;
                  _notesController.clear();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء اختيار شعور'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: const Text(
              'حفظ المشاعر اليومية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab(EmotionProvider emotionProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'توزيع المشاعر خلال الأسبوع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: EmotionChart(emotions: emotionProvider.emotions),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'نسب المشاعر خلال الأسبوع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: EmotionPieChart(emotions: emotionProvider.emotions),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

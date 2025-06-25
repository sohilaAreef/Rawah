import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionPieChart extends StatelessWidget {
  final List<DailyEmotion> emotions;

  const EmotionPieChart({super.key, required this.emotions});

  @override
  Widget build(BuildContext context) {
    final emotionCounts = <EmotionType, int>{};
    for (var emotion in emotions) {
      emotionCounts.update(
        emotion.type,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final pieSections = emotionCounts.entries.map((entry) {
      final color = _getEmotionColor(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${emotionTypeToName(entry.key)}\n${entry.value}',
        radius: 40,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: pieSections,
        centerSpaceRadius: 50,
        sectionsSpace: 2,
        startDegreeOffset: -90,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOutCubic,
    );
  }

  Color _getEmotionColor(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return Colors.yellow[700]!;
      case EmotionType.sad:
        return Colors.blue[700]!;
      case EmotionType.angry:
        return Colors.red[700]!;
      case EmotionType.anxious:
        return Colors.orange[700]!;
      case EmotionType.excited:
        return Colors.pink[400]!;
      case EmotionType.calm:
        return Colors.green[500]!;
      case EmotionType.tired:
        return Colors.grey[600]!;
      case EmotionType.neutral:
        return Colors.purple[300]!;
      default:
        return AppColors.accent;
    }
  }

  String emotionTypeToName(EmotionType type) {
    switch (type) {
      case EmotionType.happy:
        return 'سعيد';
      case EmotionType.sad:
        return 'حزين';
      case EmotionType.angry:
        return 'غاضب';
      case EmotionType.anxious:
        return 'قلق';
      case EmotionType.excited:
        return 'متحمس';
      case EmotionType.calm:
        return 'هادئ';
      case EmotionType.tired:
        return 'متعب';
      case EmotionType.neutral:
        return 'محايد';
      default:
        return 'أخرى';
    }
  }
}

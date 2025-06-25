import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rawah/models/daily_emotion.dart';
import 'package:rawah/utils/app_colors.dart';

class EmotionChart extends StatelessWidget {
  final List<DailyEmotion> emotions;

  const EmotionChart({super.key, required this.emotions});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = [
                  'أحد',
                  'اثنين',
                  'ثلاثاء',
                  'أربعاء',
                  'خميس',
                  'جمعة',
                  'سبت',
                ];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    value < days.length ? days[value.toInt()] : '',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey[300], strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey[400]!, width: 1),
            left: BorderSide(color: Colors.grey[400]!, width: 1),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final Map<int, double> weeklyData = {};
    for (int i = 0; i < 7; i++) {
      weeklyData[i] = 0.0;
    }

    for (var emotion in emotions) {
      final weekday = emotion.date.weekday;
      if (weekday >= 0 && weekday < 7) {
        weeklyData[weekday] =
            weeklyData[weekday]! + emotion.intensity.toDouble();
      }
    }

    return weeklyData.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.accent.withOpacity(0.7), AppColors.accent],
            ),
          ),
        ],
      );
    }).toList();
  }
}

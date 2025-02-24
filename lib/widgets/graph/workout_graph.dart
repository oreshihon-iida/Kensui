import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/daily_total_model.dart';

enum GraphType {
  count,
  weight,
}

class WorkoutGraph extends StatelessWidget {
  final List<DailyTotalModel> dailyTotals;
  final GraphType graphType;
  final int? bodyWeight;

  const WorkoutGraph({
    super.key,
    required this.dailyTotals,
    required this.graphType,
    this.bodyWeight,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyTotals.isEmpty) {
      return const Center(child: Text('データがありません'));
    }

    if (graphType == GraphType.weight && bodyWeight == null) {
      return const Center(child: Text('体重データが必要です'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _calculateInterval(),
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              graphType == GraphType.count ? '回数' : '総重量 (kg)',
              style: const TextStyle(fontSize: 12),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: _calculateInterval(),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyTotals.length) {
                  // 日付順（新しい順）にソート
                  final sortedTotals = List<DailyTotalModel>.from(dailyTotals)
                    ..sort((a, b) => b.date.compareTo(a.date));
                  final date = sortedTotals[index].date;
                  
                  // 日付の重複を避けるため、前の日付と比較
                  if (index == 0 || index == sortedTotals.length - 1 ||
                      (index > 0 && (sortedTotals[index - 1].date.day != date.day ||
                                   sortedTotals[index - 1].date.month != date.month))) {
                    return Text(
                      '${date.month}/${date.day}',
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: _createDataPoints(),
            isCurved: false,
            dotData: const FlDotData(show: true),
            color: Theme.of(context).primaryColor,
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createDataPoints() {
    // 日付順（新しい順）にソート
    final sortedTotals = List<DailyTotalModel>.from(dailyTotals)
      ..sort((a, b) => b.date.compareTo(a.date));
    
    return List.generate(sortedTotals.length, (index) {
      final total = sortedTotals[index];
      final y = graphType == GraphType.count
          ? total.totalCount.toDouble()
          : total.workouts.fold<double>(
              0,
              (sum, workout) =>
                  sum +
                  (workout.count * (bodyWeight! + (workout.weightAdded ?? 0)))
                      .toDouble(),
            );
      return FlSpot(index.toDouble(), y);
    });
  }

  double _calculateInterval() {
    if (dailyTotals.isEmpty) return 5;

    final values = dailyTotals.map((total) {
      return graphType == GraphType.count
          ? total.totalCount.toDouble()
          : total.workouts.fold<double>(
              0,
              (sum, workout) =>
                  sum +
                  (workout.count * (bodyWeight! + (workout.weightAdded ?? 0)))
                      .toDouble(),
            );
    }).toList();

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    // Y軸の目盛り間隔を調整（小さい値から大きい値まで見やすく）
    if (maxValue <= 10) return 2;
    if (maxValue <= 20) return 4;
    if (maxValue <= 50) return 5;
    if (maxValue <= 100) return 10;
    if (maxValue <= 200) return 20;
    if (maxValue <= 500) return 50;
    if (maxValue <= 1000) return 100;
    return (maxValue / 500).ceil() * 500.0;
  }
}

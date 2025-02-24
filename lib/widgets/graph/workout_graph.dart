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
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 1,
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
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dailyTotals.length) {
                  final index = dailyTotals.length - 1 - value.toInt();
                  final date = dailyTotals[index].date;
                  return Text(
                    '${date.month}/${date.day}',
                    style: const TextStyle(fontSize: 12),
                  );
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
    final points = List.generate(dailyTotals.length, (index) {
      final total = dailyTotals[index];
      final y = graphType == GraphType.count
          ? total.totalCount.toDouble()
          : total.workouts.fold<double>(
              0,
              (sum, workout) =>
                  sum +
                  (workout.count * (bodyWeight! + (workout.weightAdded ?? 0)))
                      .toDouble(),
            );
      return FlSpot((dailyTotals.length - 1 - index).toDouble(), y);
    });
    return points;
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
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 500) return 50;
    return (maxValue / 100).ceil() * 100.0;
  }
}

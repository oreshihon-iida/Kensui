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
  final String selectedPeriod; // 1month, 3months, all

  const WorkoutGraph({
    super.key,
    required this.dailyTotals,
    required this.graphType,
    required this.selectedPeriod,
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
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                final filteredData = _filterDataByPeriod();
                if (index >= 0 && index < filteredData.length) {
                  final date = filteredData[index].date;
                  // 週の始まり（月曜日）を基準に表示、かつ月初めと月末も表示
                  final weekday = date.weekday;
                  final isMonthStart = date.day == 1;
                  final isMonthEnd = date.day == DateTime(date.year, date.month + 1, 0).day;
                  if (weekday == DateTime.monday || isMonthStart || isMonthEnd || index == filteredData.length - 1) {
                    return Text(
                      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
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
    // 日付でソート（古い順）
    final sortedTotals = _filterDataByPeriod();
    
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

  List<DailyTotalModel> _filterDataByPeriod() {
    // JSTでの現在時刻を取得
    final now = DateTime.now().add(const Duration(hours: 9));
    final filteredData = List<DailyTotalModel>.from(dailyTotals);
    
    // 期間に応じてデータをフィルタリング
    switch (selectedPeriod) {
      case '1month':
        // 現在の月の1日から過去1か月
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final oneMonthAgo = DateTime(now.year, now.month - 1, 1);
        filteredData.removeWhere((total) => 
          total.date.isBefore(oneMonthAgo) || total.date.isAfter(currentMonthStart.add(const Duration(days: 31))));
      case '3months':
        // 現在の月の1日から過去3か月
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final threeMonthsAgo = DateTime(now.year, now.month - 3, 1);
        filteredData.removeWhere((total) => 
          total.date.isBefore(threeMonthsAgo) || total.date.isAfter(currentMonthStart.add(const Duration(days: 31))));
      case 'all':
        // データが存在する最古の日から現在の月末まで
        final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
        filteredData.removeWhere((total) => total.date.isAfter(currentMonthEnd));
        break;
    }
    
    // 日付でソート（古い順）
    filteredData.sort((a, b) => a.date.compareTo(b.date));
    return filteredData;
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
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 200) return 50;
    if (maxValue <= 500) return 100;
    if (maxValue <= 1000) return 200;
    return (maxValue / 1000).ceil() * 1000.0;
  }
}

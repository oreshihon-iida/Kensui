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

    final sortedTotals = _filterDataByPeriod();
    // 過去（左）から現在（右）の順序でX軸を設定
    final minX = sortedTotals.first.date.millisecondsSinceEpoch.toDouble() / (24 * 60 * 60 * 1000);
    final maxX = sortedTotals.last.date.millisecondsSinceEpoch.toDouble() / (24 * 60 * 60 * 1000);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _calculateYAxisInterval(),
          verticalInterval: 1.0, // 日単位の目盛り（表示は週単位）
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withAlpha(76),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            final date = DateTime.fromMillisecondsSinceEpoch(
              (value * 24 * 60 * 60 * 1000).toInt(),
            );
            // 週の境界と月の境界に目盛り線を表示
            if (date.weekday == DateTime.monday || date.day == 1) {
              return FlLine(
                color: Colors.grey.withAlpha(76),
                strokeWidth: 1,
              );
            }
            return FlLine(
              color: Colors.grey.withAlpha(30),
              strokeWidth: 0.5,
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
              interval: _calculateYAxisInterval(),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameSize: 20,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1.0, // 日単位の目盛りに変更（表示条件は getTitlesWidget で制御）
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(
                  (value * 24 * 60 * 60 * 1000).toInt(),
                );
                // 月曜日、月初め、データの最初と最後の日付の場合に表示
                if (date.weekday == DateTime.monday || 
                    date.day == 1 || 
                    date.isAtSameMomentAs(sortedTotals.first.date) || 
                    date.isAtSameMomentAs(sortedTotals.last.date)) {
                  return Text(
                    '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
              color: Theme.of(context).primaryColor.withAlpha(26),
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
      // Convert date to double (days since epoch) for X-axis
      final x = total.date.millisecondsSinceEpoch.toDouble() / (24 * 60 * 60 * 1000);
      final y = graphType == GraphType.count
          ? total.totalCount.toDouble()
          : total.workouts.fold<double>(
              0,
              (sum, workout) =>
                  sum +
                  (workout.count * (bodyWeight! + (workout.weightAdded ?? 0)))
                      .toDouble(),
            );
      return FlSpot(x, y);
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
        break;
      case '3months':
        // 現在の月の1日から過去3か月
        final currentMonthStart = DateTime(now.year, now.month, 1);
        final threeMonthsAgo = DateTime(now.year, now.month - 3, 1);
        filteredData.removeWhere((total) => 
          total.date.isBefore(threeMonthsAgo) || total.date.isAfter(currentMonthStart.add(const Duration(days: 31))));
        break;
      case 'all':
      default:
        // データが存在する最古の日から現在の月末まで
        final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
        filteredData.removeWhere((total) => total.date.isAfter(currentMonthEnd));
        break;
    }
    
    // 日付でソート（古い順 = 左から右）
    filteredData.sort((a, b) => a.date.compareTo(b.date));
    return filteredData;
  }

  double _calculateYAxisInterval() {
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

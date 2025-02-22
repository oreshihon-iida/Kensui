import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../models/daily_total.dart';

class TrainingGraph extends StatefulWidget {
  const TrainingGraph({super.key});

  @override
  State<TrainingGraph> createState() => _TrainingGraphState();
}

class _TrainingGraphState extends State<TrainingGraph> {
  late final StorageService _storage;
  List<DailyTotal> _dailyTotals = [];

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _storage = StorageService(prefs);
    _loadData();
  }

  Future<void> _loadData() async {
    final totals = await _storage.getDailyTotals();
    setState(() {
      _dailyTotals = totals;
    });
  }

  List<FlSpot> _getSpots() {
    if (_dailyTotals.isEmpty) return [const FlSpot(0, 0)];
    
    return _dailyTotals.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.totalRepetitions.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '日別グラフ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpots(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

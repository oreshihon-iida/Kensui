import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_total_model.dart';
import '../models/workout_model.dart';
import '../services/workout_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _repetitionsController = TextEditingController();
  String _selectedPeriod = '1month'; // デフォルト: 直近1か月
  late WorkoutService _workoutService;
  List<DailyTotalModel> _dailyTotals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _workoutService = WorkoutService(prefs);
    await _loadDailyTotals();
  }

  Future<void> _loadDailyTotals() async {
    setState(() => _isLoading = true);
    final dailyTotals = await _workoutService.getDailyTotals(_selectedPeriod);
    setState(() {
      _dailyTotals = dailyTotals;
      _isLoading = false;
    });
  }

  Future<void> _saveWorkout() async {
    final count = int.tryParse(_repetitionsController.text);
    if (count == null || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効な回数を入力してください')),
      );
      return;
    }

    final workout = WorkoutModel(
      date: DateTime.now(),
      count: count,
      goalCount: count + 5, // 初期目標は現在の回数+5
    );

    await _workoutService.saveWorkout(workout);
    _repetitionsController.clear();
    await _loadDailyTotals();
  }

  @override
  void dispose() {
    _repetitionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('懸垂記録'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 回数入力フィールド
            TextField(
              controller: _repetitionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '回数を入力',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 保存ボタン
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('記録する'),
            ),
            const SizedBox(height: 24),

            // 期間選択
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: '1month',
                  label: Text('1ヶ月'),
                ),
                ButtonSegment(
                  value: '3months',
                  label: Text('3ヶ月'),
                ),
                ButtonSegment(
                  value: 'all',
                  label: Text('全期間'),
                ),
              ],
              selected: {_selectedPeriod},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedPeriod = newSelection.first;
                });
                _loadDailyTotals();
              },
            ),
            const SizedBox(height: 16),

            // グラフ表示エリア
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _dailyTotals.isEmpty
                        ? const Center(child: Text('記録がありません'))
                        : const Center(child: Text('グラフ表示エリア')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

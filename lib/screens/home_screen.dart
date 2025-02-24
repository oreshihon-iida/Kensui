import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_total_model.dart';
import '../models/workout_model.dart';
import '../services/workout_service.dart';
import '../services/user_profile_service.dart';
import '../widgets/graph/workout_graph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _repetitionsController = TextEditingController();
  String _selectedPeriod = '1month'; // デフォルト: 直近1か月
  late WorkoutService _workoutService;
  late UserProfileService _userProfileService;
  List<DailyTotalModel> _dailyTotals = [];
  bool _isLoading = true;
  GraphType _selectedGraphType = GraphType.count;
  int? _bodyWeight;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    _workoutService = WorkoutService(prefs);
    _userProfileService = UserProfileService(prefs);
    _bodyWeight = _userProfileService.getBodyWeight();
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final count = int.tryParse(_repetitionsController.text);
    if (count == null || count <= 0) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('有効な回数を入力してください')),
      );
      return;
    }

    final workout = WorkoutModel(
      date: DateTime.now(),
      count: count,
      goalCount: count + 5, // 初期目標は現在の回数+5
    );

    setState(() => _isLoading = true);
    try {
      await _workoutService.saveWorkout(workout);
      _repetitionsController.clear();
      await _loadDailyTotals(); // グラフを即時更新
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('記録の保存中にエラーが発生しました')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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

            // グラフ種類選択
            SegmentedButton<GraphType>(
              segments: const [
                ButtonSegment(
                  value: GraphType.count,
                  label: Text('回数'),
                ),
                ButtonSegment(
                  value: GraphType.weight,
                  label: Text('総重量'),
                ),
              ],
              selected: {_selectedGraphType},
              onSelectionChanged: (Set<GraphType> newSelection) {
                setState(() {
                  _selectedGraphType = newSelection.first;
                });
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
                    : WorkoutGraph(
                        dailyTotals: _dailyTotals,
                        graphType: _selectedGraphType,
                        bodyWeight: _bodyWeight,
                        selectedPeriod: _selectedPeriod,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

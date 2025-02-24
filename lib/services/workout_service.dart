import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';
import '../models/daily_total_model.dart';

class WorkoutService {
  static const String _workoutsKey = 'workouts';
  final SharedPreferences _prefs;

  WorkoutService(this._prefs);

  // 新しいワークアウトを保存
  Future<void> saveWorkout(WorkoutModel workout) async {
    final workouts = await getWorkouts();
    workouts.add(workout);
    await _saveWorkouts(workouts);
  }

  // 全てのワークアウトを取得
  Future<List<WorkoutModel>> getWorkouts() async {
    final workoutsJson = _prefs.getStringList(_workoutsKey) ?? [];
    print('Debug: Found ${workoutsJson.length} workouts in SharedPreferences');
    final workouts = workoutsJson
        .map((json) => WorkoutModel.fromJson(jsonDecode(json)))
        .toList();
    print('Debug: Parsed ${workouts.length} valid workout records');
  }

  // 指定期間のワークアウトを取得
  Future<List<WorkoutModel>> getWorkoutsByPeriod(String period) async {
    final workouts = await getWorkouts();
    print('Debug: Filtering ${workouts.length} workouts for period: $period');
    final now = DateTime.now();
    
    switch (period) {
      case '1month':
        return workouts.where((w) => 
          w.date.isAfter(now.subtract(const Duration(days: 30)))).toList();
      case '3months':
        return workouts.where((w) => 
          w.date.isAfter(now.subtract(const Duration(days: 90)))).toList();
      case 'all':
      default:
        return workouts;
    }
  }

  // 日別の集計データを取得
  Future<List<DailyTotalModel>> getDailyTotals(String period) async {
    final workouts = await getWorkoutsByPeriod(period);
    print('Debug: Aggregating ${workouts.length} workouts into daily totals');
    final Map<DateTime, List<WorkoutModel>> workoutsByDate = {};
    
    for (var workout in workouts) {
      final date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      workoutsByDate[date] = [...(workoutsByDate[date] ?? []), workout];
    }

    final dailyTotals = workoutsByDate.entries
        .map((e) => DailyTotalModel(date: e.key, workouts: e.value))
        .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    print('Debug: Generated ${dailyTotals.length} daily total records');
    return dailyTotals;
  }

  // ワークアウトリストを保存
  Future<void> _saveWorkouts(List<WorkoutModel> workouts) async {
    final workoutsJson = workouts
        .map((workout) => jsonEncode(workout.toJson()))
        .toList();
    await _prefs.setStringList(_workoutsKey, workoutsJson);
  }
}

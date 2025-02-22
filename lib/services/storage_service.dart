import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/workout_model.dart';

// ローカルストレージ操作用のサービスクラス
class StorageService {
  static const String workoutKey = 'workout_data';
  
  // データの保存
  Future<void> saveWorkout(WorkoutModel workout) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();
    workouts.add(workout);
    
    final workoutJsonList = workouts.map((w) => w.toJson()).toList();
    await prefs.setString(workoutKey, jsonEncode(workoutJsonList));
  }

  // データの取得
  Future<List<WorkoutModel>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutJson = prefs.getString(workoutKey);
    
    if (workoutJson == null) return [];
    
    final workoutList = jsonDecode(workoutJson) as List;
    return workoutList
        .map((json) => WorkoutModel.fromJson(json))
        .toList();
  }
}

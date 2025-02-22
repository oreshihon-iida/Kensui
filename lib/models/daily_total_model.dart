import 'workout_model.dart';

/// 1日分のトレーニング記録を集計するモデルクラス。
/// 複数回の懸垂トレーニングを集計し、統計情報を提供します。
class DailyTotalModel {
  final DateTime date;
  final List<WorkoutModel> workouts;
  
  DailyTotalModel({
    required this.date,
    required this.workouts,
  });

  // 1日の合計回数
  int get totalCount => workouts.fold(0, (sum, workout) => sum + workout.count);

  // 1日の最高回数
  int get maxCount => workouts.isEmpty ? 0 : workouts.map((w) => w.count).reduce((a, b) => a > b ? a : b);

  // 1日の平均回数
  double get averageCount => workouts.isEmpty ? 0 : totalCount / workouts.length;

  // 目標達成回数
  int get completedCount => workouts.where((w) => w.isCompleted).length;

  // 目標達成率
  double get completionRate => workouts.isEmpty ? 0 : (completedCount / workouts.length) * 100;

  // SharedPreferencesでの保存用にMapに変換
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'workouts': workouts.map((w) => w.toJson()).toList(),
    };
  }

  // SharedPreferencesからの読み込み用
  factory DailyTotalModel.fromJson(Map<String, dynamic> json) {
    return DailyTotalModel(
      date: DateTime.parse(json['date']),
      workouts: (json['workouts'] as List)
          .map((w) => WorkoutModel.fromJson(w))
          .toList(),
    );
  }
}

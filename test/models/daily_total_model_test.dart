import 'package:flutter_test/flutter_test.dart';
import 'package:kensui/models/daily_total_model.dart';
import 'package:kensui/models/workout_model.dart';

void main() {
  group('DailyTotalModelのテスト', () {
    final date = DateTime.now();
    final workouts = [
      WorkoutModel(
        date: date,
        count: 10,
        goalCount: 10,
        isCompleted: true,
      ),
      WorkoutModel(
        date: date,
        count: 8,
        goalCount: 10,
        isCompleted: false,
      ),
      WorkoutModel(
        date: date,
        count: 12,
        goalCount: 10,
        isCompleted: true,
      ),
    ];

    test('1日の合計回数が正しく計算されること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      expect(daily.totalCount, 30); // 10 + 8 + 12
    });

    test('1日の最高回数が正しく計算されること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      expect(daily.maxCount, 12);
    });

    test('1日の平均回数が正しく計算されること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      expect(daily.averageCount, 10.0); // (10 + 8 + 12) / 3
    });

    test('目標達成回数が正しく計算されること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      expect(daily.completedCount, 2); // 2回達成
    });

    test('目標達成率が正しく計算されること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      expect(daily.completionRate, (2 / 3) * 100); // 約66.67%
    });

    test('JSON変換が正しく動作すること', () {
      final daily = DailyTotalModel(date: date, workouts: workouts);
      final json = daily.toJson();
      final restored = DailyTotalModel.fromJson(json);
      
      expect(restored.date.toIso8601String(), date.toIso8601String());
      expect(restored.workouts.length, workouts.length);
      expect(restored.totalCount, daily.totalCount);
      expect(restored.maxCount, daily.maxCount);
      expect(restored.completedCount, daily.completedCount);
    });
  });
}

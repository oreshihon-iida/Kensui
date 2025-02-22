import 'package:flutter_test/flutter_test.dart';
import 'package:kensui/models/workout_model.dart';

void main() {
  group('WorkoutModelのテスト', () {
    test('目標達成時の新しい目標値が正しく計算されること', () {
      final workout = WorkoutModel(
        date: DateTime.now(),
        count: 10,
        goalCount: 10,
        isCompleted: true,
      );
      
      expect(workout.calculateNextGoal(), 15); // 現在の回数 + 5
    });

    test('目標未達成時は現在の目標値が維持されること', () {
      final workout = WorkoutModel(
        date: DateTime.now(),
        count: 8,
        goalCount: 10,
      );
      
      expect(workout.calculateNextGoal(), 10);
    });

    test('総重量が正しく計算されること', () {
      final workout = WorkoutModel(
        date: DateTime.now(),
        count: 10,
        goalCount: 10,
        weightAdded: 5,
      );
      
      expect(workout.calculateTotalWeight(70), 75); // 体重70kg + 追加重量5kg
    });

    test('JSON変換が正しく動作すること', () {
      final date = DateTime.now();
      final workout = WorkoutModel(
        date: date,
        count: 10,
        goalCount: 12,
        note: 'テストメモ',
        weightAdded: 5,
        isCompleted: true,
      );
      
      final json = workout.toJson();
      final restored = WorkoutModel.fromJson(json);
      
      expect(restored.date.toIso8601String(), date.toIso8601String());
      expect(restored.count, 10);
      expect(restored.goalCount, 12);
      expect(restored.note, 'テストメモ');
      expect(restored.weightAdded, 5);
      expect(restored.isCompleted, true);
    });
  });
}

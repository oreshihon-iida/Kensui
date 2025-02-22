import '../utils/date_formatter.dart';

/// トレーニングの記録を管理するモデルクラス。
/// 1回の懸垂トレーニングの詳細情報を保持します。
class WorkoutModel {
  final DateTime date;
  final int count;
  final int goalCount;
  final String? note;        // 任意のメモ
  final int? weightAdded;    // 追加重量（kg）
  final bool isCompleted;    // 目標達成フラグ

  WorkoutModel({
    required this.date,
    required this.count,
    required this.goalCount,
    this.note,
    this.weightAdded,
    this.isCompleted = false,
  });

  // 目標達成時の新しい目標値を計算
  int calculateNextGoal() {
    return isCompleted ? count + 5 : goalCount;
  }

  // 日付のフォーマット（DD形式）
  String get formattedDate => DateFormatter.formatDay(date);

  // 総重量の計算（体重 + 追加重量）
  int calculateTotalWeight(int bodyWeight) {
    return bodyWeight + (weightAdded ?? 0);
  }

  // SharedPreferencesでの保存用にMapに変換
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'count': count,
      'goalCount': goalCount,
      'note': note,
      'weightAdded': weightAdded,
      'isCompleted': isCompleted,
    };
  }

  // SharedPreferencesからの読み込み用
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      date: DateTime.parse(json['date']),
      count: json['count'],
      goalCount: json['goalCount'],
      note: json['note'],
      weightAdded: json['weightAdded'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // 新しいインスタンスを作成（目標達成時）
  WorkoutModel markAsCompleted() {
    return WorkoutModel(
      date: date,
      count: count,
      goalCount: calculateNextGoal(),
      note: note,
      weightAdded: weightAdded,
      isCompleted: true,
    );
  }
}

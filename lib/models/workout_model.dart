// トレーニングデータのモデルクラス
class WorkoutModel {
  final DateTime date;
  final int count;
  final int goalCount;

  WorkoutModel({
    required this.date,
    required this.count,
    required this.goalCount,
  });

  // SharedPreferencesでの保存用にMapに変換
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'count': count,
      'goalCount': goalCount,
    };
  }

  // SharedPreferencesからの読み込み用
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      date: DateTime.parse(json['date']),
      count: json['count'],
      goalCount: json['goalCount'],
    );
  }
}

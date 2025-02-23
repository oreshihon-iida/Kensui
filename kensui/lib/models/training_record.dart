import 'package:flutter/foundation.dart';

/// 懸垂トレーニングの個別記録を管理するモデルクラス
///
/// 各トレーニングセッションの実施日時と回数を記録します。
/// データの永続化のためにJSON形式でのシリアライズ機能を提供します。
@immutable
class TrainingRecord {
  /// トレーニングを実施した日時
  final DateTime timestamp;
  /// 実施した懸垂の回数
  final int repetitions;

  /// 新しいトレーニング記録を作成
  ///
  /// [timestamp] - トレーニングを実施した日時
  /// [repetitions] - 実施した回数（0以上の整数）
  const TrainingRecord({required this.timestamp, required this.repetitions});

  /// オブジェクトをJSONに変換
  ///
  /// タイムスタンプはISO 8601形式で保存されます
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'repetitions': repetitions,
  };

  /// JSONからオブジェクトを生成するファクトリメソッド
  ///
  /// [json] - 変換元のJSONデータ
  factory TrainingRecord.fromJson(Map<String, dynamic> json) => TrainingRecord(
    timestamp: DateTime.parse(json['timestamp']),
    repetitions: json['repetitions'] as int,
  );

  @override
  String toString() =>
      'TrainingRecord(timestamp: $timestamp, repetitions: $repetitions)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingRecord &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          repetitions == other.repetitions;

  @override
  int get hashCode => timestamp.hashCode ^ repetitions.hashCode;
}

/// 日別の懸垂回数合計を管理するモデルクラス
///
/// 特定の日付における全トレーニングセッションの合計回数を保持します。
/// グラフ表示や進捗管理に使用されます。
class DailyTotal {
  /// 集計対象の日付
  final DateTime date;
  /// その日の合計実施回数
  final int totalRepetitions;

  /// 新しい日別合計記録を作成
  ///
  /// [date] - 集計対象の日付
  /// [totalRepetitions] - その日の合計実施回数
  const DailyTotal({required this.date, required this.totalRepetitions});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalRepetitions': totalRepetitions,
  };

  factory DailyTotal.fromJson(Map<String, dynamic> json) => DailyTotal(
    date: DateTime.parse(json['date']),
    totalRepetitions: json['totalRepetitions'] as int,
  );

  @override
  String toString() =>
      'DailyTotal(date: $date, totalRepetitions: $totalRepetitions)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTotal &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalRepetitions == other.totalRepetitions;

  @override
  int get hashCode => date.hashCode ^ totalRepetitions.hashCode;
}

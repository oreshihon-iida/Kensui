import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_record.dart';

/// トレーニング記録のローカルストレージ管理を行うサービスクラス
///
/// SharedPreferencesを使用してトレーニング記録と日別集計データを
/// JSONフォーマットで永続化します。データの保存、取得、更新、
/// 削除の機能を提供します。
class StorageService {
  /// 個別トレーニング記録を保存するためのキー
  static const String _recordsKey = 'training_records';
  /// 日別集計データを保存するためのキー
  static const String _dailyTotalsKey = 'daily_totals';
  /// SharedPreferencesインスタンス
  final SharedPreferences _prefs;

  /// StorageServiceのコンストラクタ
  ///
  /// [_prefs] - 初期化済みのSharedPreferencesインスタンス
  StorageService(this._prefs);

  /// 新しいトレーニング記録を保存
  ///
  /// [record] - 保存するトレーニング記録
  ///
  /// 記録を保存し、日別集計データを更新します。
  /// 既存の記録は保持され、新しい記録が追加されます。
  Future<void> saveRecord(TrainingRecord record) async {
    final records = await getRecords();
    records.add(record);
    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(_recordsKey, jsonEncode(jsonList));
    await _updateDailyTotals(records);
  }

  /// 保存されている全てのトレーニング記録を取得
  ///
  /// 保存されている記録が無い場合は空のリストを返します。
  /// 記録はJSONから復元され、TrainingRecordオブジェクトのリストとして返されます。
  Future<List<TrainingRecord>> getRecords() async {
    final jsonString = _prefs.getString(_recordsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => TrainingRecord.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 日別の合計回数を更新
  ///
  /// [records] - 集計対象のトレーニング記録リスト
  ///
  /// 全ての記録から日付ごとの合計回数を計算し、
  /// DailyTotalオブジェクトとして保存します。
  /// 時刻情報は無視され、日付単位で集計されます。
  Future<void> _updateDailyTotals(List<TrainingRecord> records) async {
    final dailyTotals = <String, DailyTotal>{};

    for (final record in records) {
      // 時刻情報を除いた日付のみを使用
      final date = DateTime(
        record.timestamp.year,
        record.timestamp.month,
        record.timestamp.day,
      );
      final dateKey = date.toIso8601String();

      // 既存の合計に新しい記録を追加
      final currentTotal = dailyTotals[dateKey]?.totalRepetitions ?? 0;
      dailyTotals[dateKey] = DailyTotal(
        date: date,
        totalRepetitions: currentTotal + record.repetitions,
      );
    }

    final jsonList = dailyTotals.values.map((dt) => dt.toJson()).toList();
    await _prefs.setString(_dailyTotalsKey, jsonEncode(jsonList));
  }

  Future<List<DailyTotal>> getDailyTotals() async {
    final jsonString = _prefs.getString(_dailyTotalsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => DailyTotal.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteRecord(TrainingRecord record) async {
    final records = await getRecords();
    records.removeWhere(
      (r) =>
          r.timestamp == record.timestamp &&
          r.repetitions == record.repetitions,
    );
    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(_recordsKey, jsonEncode(jsonList));
    await _updateDailyTotals(records);
  }

  Future<void> updateRecord(
    TrainingRecord oldRecord,
    TrainingRecord newRecord,
  ) async {
    final records = await getRecords();
    final index = records.indexWhere(
      (r) =>
          r.timestamp == oldRecord.timestamp &&
          r.repetitions == oldRecord.repetitions,
    );
    if (index != -1) {
      records[index] = newRecord;
      final jsonList = records.map((r) => r.toJson()).toList();
      await _prefs.setString(_recordsKey, jsonEncode(jsonList));
      await _updateDailyTotals(records);
    }
  }
}

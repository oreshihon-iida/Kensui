import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_record.dart';

class StorageService {
  static const String _recordsKey = 'training_records';
  static const String _dailyTotalsKey = 'daily_totals';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveRecord(TrainingRecord record) async {
    final records = await getRecords();
    records.add(record);
    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs.setString(_recordsKey, jsonEncode(jsonList));
    await _updateDailyTotals(records);
  }

  Future<List<TrainingRecord>> getRecords() async {
    final jsonString = _prefs.getString(_recordsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => TrainingRecord.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> _updateDailyTotals(List<TrainingRecord> records) async {
    final dailyTotals = <String, DailyTotal>{};

    for (final record in records) {
      final date = DateTime(
        record.timestamp.year,
        record.timestamp.month,
        record.timestamp.day,
      );
      final dateKey = date.toIso8601String();

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

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_record.dart';
import '../models/daily_total.dart';

class StorageService {
  static const String _recordsKey = 'training_records';
  static const String _dailyTotalsKey = 'daily_totals';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveRecord(TrainingRecord record) async {
    final records = await getRecords();
    records.add(record);
    await _prefs.setString(_recordsKey, jsonEncode(records.map((r) => r.toJson()).toList()));
    await _updateDailyTotals(records);
  }

  Future<List<TrainingRecord>> getRecords() async {
    final String? data = _prefs.getString(_recordsKey);
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => TrainingRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteRecord(DateTime timestamp) async {
    final records = await getRecords();
    records.removeWhere((record) => record.timestamp == timestamp);
    await _prefs.setString(_recordsKey, jsonEncode(records.map((r) => r.toJson()).toList()));
    await _updateDailyTotals(records);
  }

  Future<List<DailyTotal>> getDailyTotals() async {
    final String? data = _prefs.getString(_dailyTotalsKey);
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => DailyTotal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _updateDailyTotals(List<TrainingRecord> records) async {
    final Map<String, int> dailyTotals = {};
    
    for (final record in records) {
      final date = DateTime(
        record.timestamp.year,
        record.timestamp.month,
        record.timestamp.day,
      );
      final dateStr = date.toIso8601String();
      dailyTotals[dateStr] = (dailyTotals[dateStr] ?? 0) + record.repetitions;
    }

    final List<DailyTotal> totals = dailyTotals.entries.map((entry) {
      return DailyTotal(
        date: DateTime.parse(entry.key),
        totalRepetitions: entry.value,
      );
    }).toList();

    totals.sort((a, b) => a.date.compareTo(b.date));
    await _prefs.setString(_dailyTotalsKey, jsonEncode(totals.map((t) => t.toJson()).toList()));
  }
}

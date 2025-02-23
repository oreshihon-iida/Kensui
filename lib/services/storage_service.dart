import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/training_record.dart';
import '../models/daily_total.dart';
import '../models/user_profile_model.dart';

class StorageService {
  static const String _recordsKey = 'training_records';
  static const String _dailyTotalsKey = 'daily_totals';
  static const String _userProfileKey = 'user_profile';
  final SharedPreferences _prefs;

  // メモリ内キャッシュ
  List<DailyTotal>? _cachedDailyTotals;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 30);

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
    // キャッシュが有効な場合はキャッシュを返す
    if (_isCacheValid()) {
      return _cachedDailyTotals!;
    }

    final String? data = _prefs.getString(_dailyTotalsKey);
    if (data == null) return [];

    _cachedDailyTotals = (jsonDecode(data) as List)
        .map((e) => DailyTotal.fromJson(e as Map<String, dynamic>))
        .toList();
    _lastCacheUpdate = DateTime.now();
    
    return _cachedDailyTotals!;
  }

  bool _isCacheValid() {
    if (_cachedDailyTotals == null || _lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration;
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
    
    // キャッシュと永続化ストレージを更新
    _cachedDailyTotals = totals;
    _lastCacheUpdate = DateTime.now();
    await _prefs.setString(_dailyTotalsKey, jsonEncode(totals.map((t) => t.toJson()).toList()));
  }

  // ユーザープロフィールの保存
  Future<void> saveUserProfile(UserProfileModel profile) async {
    await _prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
  }

  // ユーザープロフィールの取得
  Future<UserProfileModel?> getUserProfile() async {
    final jsonString = _prefs.getString(_userProfileKey);
    if (jsonString == null) return null;
    
    return UserProfileModel.fromJson(jsonDecode(jsonString));
  }


  Future<void> clearCache() async {
    _cachedDailyTotals = null;
    _lastCacheUpdate = null;
  }
}

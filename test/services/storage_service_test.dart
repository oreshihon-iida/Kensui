import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kensui/services/storage_service.dart';
import 'package:kensui/models/training_record.dart';
import 'package:kensui/models/daily_total.dart';

void main() {
  late StorageService storageService;
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    storageService = StorageService(preferences);
  });

  group('StorageService', () {
    test('saveRecord stores record and updates daily totals', () async {
      final record = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 15, 0),
        repetitions: 10,
      );

      await storageService.saveRecord(record);

      final records = await storageService.getRecords();
      expect(records.length, 1);
      expect(records.first.timestamp, record.timestamp);
      expect(records.first.repetitions, record.repetitions);

      final dailyTotals = await storageService.getDailyTotals();
      expect(dailyTotals.length, 1);
      expect(dailyTotals.first.date, DateTime(2025, 2, 17));
      expect(dailyTotals.first.totalRepetitions, 10);
    });

    test('deleteRecord removes record and updates daily totals', () async {
      final record = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 15, 0),
        repetitions: 10,
      );

      await storageService.saveRecord(record);
      await storageService.deleteRecord(record.timestamp);

      final records = await storageService.getRecords();
      expect(records.isEmpty, true);

      final dailyTotals = await storageService.getDailyTotals();
      expect(dailyTotals.isEmpty, true);
    });

    test('getDailyTotals returns empty list when no records exist', () async {
      final dailyTotals = await storageService.getDailyTotals();
      expect(dailyTotals.isEmpty, true);
    });
  });
}

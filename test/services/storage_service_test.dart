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

  group('StorageService Cache', () {
    test('getDailyTotals returns cached data when cache is valid', () async {
      final record = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 15, 0),
        repetitions: 10,
      );

      await storageService.saveRecord(record);
      final firstResult = await storageService.getDailyTotals();
      final secondResult = await storageService.getDailyTotals();

      expect(firstResult.length, 1);
      expect(secondResult.length, 1);
      expect(identical(firstResult, secondResult), true);
    });

    test('clearCache invalidates the cache', () async {
      final record = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 15, 0),
        repetitions: 10,
      );

      await storageService.saveRecord(record);
      final firstResult = await storageService.getDailyTotals();
      await storageService.clearCache();
      final secondResult = await storageService.getDailyTotals();

      expect(identical(firstResult, secondResult), false);
      expect(secondResult.length, 1);
      expect(secondResult.first.totalRepetitions, 10);
    });

    test('cache is updated when saving new record', () async {
      final firstRecord = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 15, 0),
        repetitions: 10,
      );
      await storageService.saveRecord(firstRecord);
      final firstResult = await storageService.getDailyTotals();

      final secondRecord = TrainingRecord(
        timestamp: DateTime(2025, 2, 17, 16, 0),
        repetitions: 5,
      );
      await storageService.saveRecord(secondRecord);
      final secondResult = await storageService.getDailyTotals();

      expect(firstResult.length, 1);
      expect(firstResult.first.totalRepetitions, 10);
      expect(secondResult.length, 1);
      expect(secondResult.first.totalRepetitions, 15);
    });
  });
}

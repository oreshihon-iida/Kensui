import 'package:flutter_test/flutter_test.dart';
import 'package:kensui/models/training_record.dart';

void main() {
  group('TrainingRecord', () {
    test('toJson converts TrainingRecord to JSON', () {
      final timestamp = DateTime(2025, 2, 17, 15, 0);
      final record = TrainingRecord(
        timestamp: timestamp,
        repetitions: 10,
      );

      final json = record.toJson();
      
      expect(json['timestamp'], timestamp.toIso8601String());
      expect(json['repetitions'], 10);
    });

    test('fromJson creates TrainingRecord from JSON', () {
      final json = {
        'timestamp': '2025-02-17T15:00:00.000',
        'repetitions': 10,
      };

      final record = TrainingRecord.fromJson(json);

      expect(record.timestamp, DateTime(2025, 2, 17, 15, 0));
      expect(record.repetitions, 10);
    });
  });
}

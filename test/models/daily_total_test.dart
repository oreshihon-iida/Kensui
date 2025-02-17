import 'package:flutter_test/flutter_test.dart';
import 'package:kensui/models/daily_total.dart';

void main() {
  group('DailyTotal', () {
    test('formattedDate returns day in DD format', () {
      final total = DailyTotal(
        date: DateTime(2025, 2, 7),
        totalRepetitions: 20,
      );

      expect(total.formattedDate, '07');
    });

    test('toJson converts DailyTotal to JSON', () {
      final date = DateTime(2025, 2, 17);
      final total = DailyTotal(
        date: date,
        totalRepetitions: 20,
      );

      final json = total.toJson();
      
      expect(json['date'], date.toIso8601String());
      expect(json['totalRepetitions'], 20);
    });

    test('fromJson creates DailyTotal from JSON', () {
      final json = {
        'date': '2025-02-17T00:00:00.000',
        'totalRepetitions': 20,
      };

      final total = DailyTotal.fromJson(json);

      expect(total.date, DateTime(2025, 2, 17));
      expect(total.totalRepetitions, 20);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kensui/widgets/dialogs/training_record_dialog.dart';
import 'package:kensui/models/training_record.dart';

void main() {
  testWidgets('TrainingRecordDialog handles long record lists', (WidgetTester tester) async {
    final now = DateTime.utc(2025, 2, 24, 4, 42); // Fixed UTC timestamp
    final records = List.generate(50, (i) => TrainingRecord(
      timestamp: now.subtract(Duration(minutes: i)),
      repetitions: 10,
    ));

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Dialog(
          child: TrainingRecordDialog(
            selectedDate: now,
            dayRecords: records,
            onSave: (_) {},
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Verify first record is visible with JST time (UTC 04:42 -> JST 13:42)
    expect(find.text('13:42 10回'), findsOneWidget);

    // Verify scrolling works
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verify last record is visible with JST time (UTC 03:52 -> JST 12:52)
    expect(find.text('12:52 10回'), findsOneWidget);
  });

  testWidgets('TrainingRecordDialog shows empty state message', (WidgetTester tester) async {
    final now = DateTime.utc(2025, 2, 24, 4, 42); // Fixed UTC timestamp
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TrainingRecordDialog(
          selectedDate: now,
          dayRecords: const [],
          onSave: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('記録はありません'), findsOneWidget);
  });

  testWidgets('TrainingRecordDialog saves record with current time', (WidgetTester tester) async {
    final now = DateTime.utc(2025, 2, 24, 4, 42); // Fixed UTC timestamp
    DateTime? savedTimestamp;
    int? savedRepetitions;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TrainingRecordDialog(
          selectedDate: now,
          dayRecords: const [],
          onSave: (record) {
            savedTimestamp = record.timestamp;
            savedRepetitions = record.repetitions;
          },
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Enter 50 repetitions
    await tester.enterText(find.byType(TextFormField), '50');
    
    // Press save button
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    // Verify record was saved with JST time
    expect(savedRepetitions, equals(50));
    expect(savedTimestamp?.hour, equals(13)); // UTC 4:42 -> JST 13:42
    expect(savedTimestamp?.minute, equals(42));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kensui/widgets/dialogs/training_record_dialog.dart';
import 'package:kensui/models/training_record.dart';

void main() {
  testWidgets('TrainingRecordDialog handles long record lists', (WidgetTester tester) async {
    final now = DateTime.now();
    final records = List.generate(50, (i) => TrainingRecord(
      timestamp: now.subtract(Duration(minutes: i)),
      repetitions: 10 + i,
    ));

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TrainingRecordDialog(
          selectedDate: now,
          dayRecords: records,
          onSave: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    // Dialog should be visible
    expect(find.byType(AlertDialog), findsOneWidget);
    
    // Should show records in descending order
    expect(find.text('${records.first.repetitions}回'), findsOneWidget);
    
    // Should be able to scroll
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Should show records at the bottom
    expect(find.text('${records.last.repetitions}回'), findsOneWidget);
  });

  testWidgets('TrainingRecordDialog shows empty state message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TrainingRecordDialog(
          selectedDate: DateTime.now(),
          dayRecords: const [],
          onSave: (_) {},
        ),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('記録はありません'), findsOneWidget);
  });

  testWidgets('TrainingRecordDialog saves record with current time', (WidgetTester tester) async {
    DateTime? savedTimestamp;
    int? savedRepetitions;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TrainingRecordDialog(
          selectedDate: DateTime.now(),
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

    // Verify record was saved with current time
    expect(savedRepetitions, equals(50));
    expect(savedTimestamp?.hour, equals(DateTime.now().hour));
    expect(savedTimestamp?.minute, equals(DateTime.now().minute));
  });
}

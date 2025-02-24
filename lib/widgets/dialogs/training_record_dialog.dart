import 'package:flutter/material.dart';
import '../../models/training_record.dart';
import 'scrollable_dialog_content.dart';

class TrainingRecordDialog extends StatelessWidget {
  final DateTime selectedDate;
  final TrainingRecord? record;
  final List<TrainingRecord> dayRecords;
  final Function(TrainingRecord) onSave;

  const TrainingRecordDialog({
    super.key,
    required this.selectedDate,
    this.record,
    required this.dayRecords,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController repetitionsController = TextEditingController(
      text: record?.repetitions.toString() ?? '',
    );

    return AlertDialog(
      title: const Text('トレーニング記録'),
      content: ScrollableDialogContent(
        children: [
          Text('日付: ${selectedDate.day}日'),
          const SizedBox(height: 16),
          TextFormField(
            controller: repetitionsController,
            decoration: const InputDecoration(
              labelText: '回数',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '回数を入力してください';
              }
              final number = int.tryParse(value);
              if (number == null || number < 0) {
                return '有効な回数を入力してください';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Text('本日の記録', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (dayRecords.isEmpty)
            const Text('記録はありません')
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: dayRecords.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final record = dayRecords[index];
                  final time = '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '$time ${record.repetitions}回',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            final repetitions = int.tryParse(repetitionsController.text);
            if (repetitions != null && repetitions >= 0) {
              final now = DateTime.now();
              final timestamp = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                now.hour,
                now.minute,
              );
              onSave(TrainingRecord(
                timestamp: timestamp,
                repetitions: repetitions,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}

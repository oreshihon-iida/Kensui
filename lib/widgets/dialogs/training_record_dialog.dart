import 'package:flutter/material.dart';
import '../../models/training_record.dart';
import 'scrollable_dialog_content.dart';

String formatTimeJst(DateTime utcTime) {
  final jst = utcTime.add(const Duration(hours: 9));
  return '${jst.hour.toString().padLeft(2, '0')}:${jst.minute.toString().padLeft(2, '0')}';
}

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
    final repetitionsController = TextEditingController(
      text: record?.repetitions.toString() ?? '',
    );

    return Dialog(
      child: ScrollableDialogContent(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        children: [
          Text(
            'トレーニング記録',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
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
          Text(
            '本日の記録',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (dayRecords.isEmpty)
            const Text('記録はありません')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayRecords.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final record = dayRecords[index];
                final time = formatTimeJst(record.timestamp);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '$time ${record.repetitions}回',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  final repetitions = int.tryParse(repetitionsController.text);
                  if (repetitions != null && repetitions >= 0) {
                    final now = DateTime.now();
                    final jst = now.toUtc().add(const Duration(hours: 9)); // Convert to JST
                    final timestamp = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      jst.hour,
                      jst.minute,
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
          ),
        ],
      ),
    );
  }
}

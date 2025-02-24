import 'package:flutter/material.dart';
import '../../models/training_record.dart';

class TrainingRecordDialog extends StatelessWidget {
  final DateTime selectedDate;
  final TrainingRecord? record;
  final Function(TrainingRecord) onSave;

  const TrainingRecordDialog({
    super.key,
    required this.selectedDate,
    this.record,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController repetitionsController = TextEditingController(
      text: record?.repetitions.toString() ?? '',
    );

    return AlertDialog(
      title: const Text('トレーニング記録'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
              onSave(TrainingRecord(
                timestamp: selectedDate,
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

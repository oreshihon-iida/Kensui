import 'package:flutter/material.dart';
import '../widgets/calendar/month_calendar.dart';
import '../widgets/dialogs/training_record_dialog.dart';
import '../models/training_record.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _repetitionsController = TextEditingController();

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _showTrainingRecordDialog(date);
  }

  void _showTrainingRecordDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => TrainingRecordDialog(
        selectedDate: date,
        onSave: _handleSaveRecord,
      ),
    );
  }

  void _handleSaveRecord(TrainingRecord record) {
    // TODO: 保存処理の実装
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${record.repetitions}回を記録しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthCalendarWidget(
              selectedDate: _selectedDate,
              onDateSelected: _handleDateSelected,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '日付を選択して記録を追加してください',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTrainingRecordDialog(_selectedDate),
        tooltip: '記録を追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _repetitionsController.dispose();
    super.dispose();
  }
}

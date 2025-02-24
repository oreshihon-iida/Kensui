import 'package:flutter/material.dart';
import '../widgets/calendar/month_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/dialogs/training_record_dialog.dart';
import '../models/training_record.dart';
import '../services/storage_service.dart';

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

  void _showTrainingRecordDialog(DateTime date) async {
    final storageService = StorageService(await SharedPreferences.getInstance());
    final allRecords = await storageService.getRecords();
    final dayRecords = allRecords
        .where((record) => 
          record.timestamp.year == date.year &&
          record.timestamp.month == date.month &&
          record.timestamp.day == date.day)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort descending

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => TrainingRecordDialog(
        selectedDate: date,
        dayRecords: dayRecords,
        onSave: _handleSaveRecord,
      ),
    );
  }

  void _handleSaveRecord(TrainingRecord record) async {
    final storageService = StorageService(await SharedPreferences.getInstance());
    await storageService.saveRecord(record);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${record.repetitions}回を記録しました')),
    );
    
    // 保存後にダイアログを再表示して履歴を更新
    _showTrainingRecordDialog(record.timestamp);
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

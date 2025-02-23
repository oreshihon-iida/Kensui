import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/training_record.dart';

class InputScreen extends StatefulWidget {
  final StorageService storageService;

  const InputScreen({super.key, required this.storageService});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repetitionsController = TextEditingController();

  @override
  void dispose() {
    _repetitionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final record = TrainingRecord(
        timestamp: DateTime.now(),
        repetitions: int.parse(_repetitionsController.text),
      );
      await widget.storageService.saveRecord(record);
      _repetitionsController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('記録を保存しました')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('懸垂記録'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _repetitionsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '回数',
                  border: OutlineInputBorder(),
                  helperText: '今回の懸垂回数を入力してください',
                ),
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
              FilledButton.icon(
                onPressed: _saveRecord,
                icon: const Icon(Icons.save),
                label: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

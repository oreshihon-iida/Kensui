import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyFatRateController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _bodyFatRateController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldNameを入力してください';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return '数値を入力してください';
    }
    if (number <= 0) {
      return '0より大きい値を入力してください';
    }
    return null;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // プロフィールの保存処理は別のPRで実装予定
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('プロフィールを保存しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: '身長 (cm)',
                  hintText: '例: 170',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, '身長'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: '体重 (kg)',
                  hintText: '例: 65',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, '体重'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyFatRateController,
                decoration: const InputDecoration(
                  labelText: '体脂肪率 (%)',
                  hintText: '例: 20',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return null;
                  return _validateNumber(value, '体脂肪率');
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

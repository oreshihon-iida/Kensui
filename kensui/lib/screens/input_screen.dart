import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/training_record.dart';

/// 懸垂回数入力画面
///
/// ユーザーが懸垂の回数を入力し、記録を保存するための画面です。
/// Material Design 3のコンポーネントを使用し、
/// 入力値の検証とユーザーフィードバックを提供します。
class InputScreen extends StatefulWidget {
  /// データ永続化を担当するStorageServiceインスタンス
  final StorageService storageService;

  /// InputScreenのコンストラクタ
  ///
  /// [storageService] - トレーニング記録の保存に使用するサービス
  const InputScreen({super.key, required this.storageService});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  /// フォームのバリデーション用キー
  final _formKey = GlobalKey<FormState>();
  /// 回数入力フィールドのコントローラー
  final _repetitionsController = TextEditingController();

  @override
  void dispose() {
    // メモリリーク防止のためコントローラーを破棄
    _repetitionsController.dispose();
    super.dispose();
  }

  /// トレーニング記録を保存
  ///
  /// フォームのバリデーションを実行し、入力が有効な場合は
  /// 新しいTrainingRecordを作成して保存します。
  /// 保存完了後、入力フィールドをクリアし、
  /// ユーザーに完了メッセージを表示します。
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

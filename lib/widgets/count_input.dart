import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountInput extends StatefulWidget {
  const CountInput({super.key});

  @override
  State<CountInput> createState() => _CountInputState();
}

class _CountInputState extends State<CountInput> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void _saveCount() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存しました')),
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '回数を入力',
              border: OutlineInputBorder(),
              helperText: '1回以上の整数を入力してください',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '回数を入力してください';
              }
              final count = int.tryParse(value);
              if (count == null) {
                return '有効な数値を入力してください';
              }
              if (count < 1) {
                return '1回以上を入力してください';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveCount,
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}

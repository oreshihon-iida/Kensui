import 'package:flutter/material.dart';
import '../widgets/count_input.dart';
import '../widgets/training_graph.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('懸垂カウンター'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            CountInput(),
            SizedBox(height: 24),
            Expanded(
              child: TrainingGraph(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';

class TrainingRecord {
  final DateTime timestamp;
  final int repetitions;

  TrainingRecord({
    required this.timestamp,
    required this.repetitions,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'repetitions': repetitions,
  };

  factory TrainingRecord.fromJson(Map<String, dynamic> json) => TrainingRecord(
    timestamp: DateTime.parse(json['timestamp']),
    repetitions: json['repetitions'] as int,
  );

  @override
  String toString() => 'TrainingRecord(timestamp: $timestamp, repetitions: $repetitions)';
}

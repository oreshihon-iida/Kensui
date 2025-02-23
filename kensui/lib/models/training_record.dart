import 'package:flutter/foundation.dart';

@immutable
class TrainingRecord {
  final DateTime timestamp;
  final int repetitions;

  const TrainingRecord({required this.timestamp, required this.repetitions});

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'repetitions': repetitions,
  };

  factory TrainingRecord.fromJson(Map<String, dynamic> json) => TrainingRecord(
    timestamp: DateTime.parse(json['timestamp']),
    repetitions: json['repetitions'] as int,
  );

  @override
  String toString() =>
      'TrainingRecord(timestamp: $timestamp, repetitions: $repetitions)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingRecord &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          repetitions == other.repetitions;

  @override
  int get hashCode => timestamp.hashCode ^ repetitions.hashCode;
}

class DailyTotal {
  final DateTime date;
  final int totalRepetitions;

  const DailyTotal({required this.date, required this.totalRepetitions});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalRepetitions': totalRepetitions,
  };

  factory DailyTotal.fromJson(Map<String, dynamic> json) => DailyTotal(
    date: DateTime.parse(json['date']),
    totalRepetitions: json['totalRepetitions'] as int,
  );

  @override
  String toString() =>
      'DailyTotal(date: $date, totalRepetitions: $totalRepetitions)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTotal &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalRepetitions == other.totalRepetitions;

  @override
  int get hashCode => date.hashCode ^ totalRepetitions.hashCode;
}

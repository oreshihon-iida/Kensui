class DailyTotal {
  final DateTime date;
  final int totalRepetitions;

  DailyTotal({
    required this.date,
    required this.totalRepetitions,
  });

  String get formattedDate => date.day.toString().padLeft(2, '0');

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalRepetitions': totalRepetitions,
  };

  factory DailyTotal.fromJson(Map<String, dynamic> json) => DailyTotal(
    date: DateTime.parse(json['date']),
    totalRepetitions: json['totalRepetitions'] as int,
  );

  @override
  String toString() => 'DailyTotal(date: $date, totalRepetitions: $totalRepetitions)';
}

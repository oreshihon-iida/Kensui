import '../utils/date_formatter.dart';

/// ユーザーの体調データを管理するモデルクラス。
/// 身長、体重、体脂肪率などの基本的な身体情報を保持します。
class UserProfileModel {
  final double height;        // 身長 (cm)
  final double weight;        // 体重 (kg)
  final double? bodyFatRate; // 体脂肪率 (%)
  final DateTime updatedAt;   // 更新日時

  UserProfileModel({
    required this.height,
    required this.weight,
    this.bodyFatRate,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // SharedPreferences用のJSON変換
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'bodyFatRate': bodyFatRate,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // JSONからのインスタンス生成
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      height: json['height'],
      weight: json['weight'],
      bodyFatRate: json['bodyFatRate'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // 更新用のコピーメソッド
  UserProfileModel copyWith({
    double? height,
    double? weight,
    double? bodyFatRate,
  }) {
    return UserProfileModel(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bodyFatRate: bodyFatRate ?? this.bodyFatRate,
    );
  }

  // 表示用の日付フォーマット
  String get formattedUpdateDate => DateFormatter.formatDay(updatedAt);
}

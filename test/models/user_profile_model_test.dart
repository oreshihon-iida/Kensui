import 'package:flutter_test/flutter_test.dart';
import 'package:kensui/models/user_profile_model.dart';

void main() {
  group('UserProfileModelのテスト', () {
    test('JSONシリアライズが正しく動作すること', () {
      final now = DateTime.now();
      final profile = UserProfileModel(
        height: 170.0,
        weight: 65.0,
        bodyFatRate: 15.0,
        updatedAt: now,
      );
      
      final json = profile.toJson();
      final restored = UserProfileModel.fromJson(json);
      
      expect(restored.height, 170.0);
      expect(restored.weight, 65.0);
      expect(restored.bodyFatRate, 15.0);
      expect(restored.updatedAt.toIso8601String(), now.toIso8601String());
    });

    test('copyWithが正しく動作すること', () {
      final profile = UserProfileModel(
        height: 170.0,
        weight: 65.0,
        bodyFatRate: 15.0,
      );
      
      final updated = profile.copyWith(weight: 64.0);
      
      expect(updated.height, 170.0);
      expect(updated.weight, 64.0);
      expect(updated.bodyFatRate, 15.0);
    });

    test('デフォルト値が正しく設定されること', () {
      final profile = UserProfileModel(
        height: 170.0,
        weight: 65.0,
      );
      
      expect(profile.bodyFatRate, null);
      expect(profile.updatedAt.difference(DateTime.now()).inSeconds.abs() < 2, true);
    });

    test('日付フォーマットが正しく動作すること', () {
      final date = DateTime(2025, 2, 23);
      final profile = UserProfileModel(
        height: 170.0,
        weight: 65.0,
        updatedAt: date,
      );
      
      expect(profile.formattedUpdateDate, '23');
    });
  });
}

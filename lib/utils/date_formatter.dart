import 'package:intl/intl.dart';

// 日付フォーマット用のユーティリティクラス
class DateFormatter {
  // DD形式（日付のみ）でフォーマット
  static String formatDay(DateTime date) {
    return DateFormat('dd').format(date);
  }

  // YYYY/MM/DD形式でフォーマット（必要に応じて）
  static String formatFull(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}

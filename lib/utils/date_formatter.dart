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

  // UTC時刻をJSTに変換
  static DateTime toJst(DateTime utcTime) {
    return utcTime.add(const Duration(hours: 9));
  }

  // JSTをUTCに変換
  static DateTime toUtc(DateTime jstTime) {
    return jstTime.subtract(const Duration(hours: 9));
  }

  // JST時刻表示用フォーマット（HH:MM）
  static String formatTimeJst(DateTime utcTime) {
    final jstTime = toJst(utcTime);
    return DateFormat('HH:mm').format(jstTime);
  }
}

# Kensui アプリケーション 要件定義

## 1. アプリケーション概要
シンプルな懸垂記録アプリケーション（iOS/Android対応）

## 2. システム要件

### 2.1 技術スタック
- フレームワーク: Flutter/Dart
- ローカルストレージ: SharedPreferences
- グラフ表示: fl_chart
- UIコンポーネント: Material Design

### 2.2 アーキテクチャ
- フロントエンドのみの構成
- バックエンド不要
- ローカルデータ保存
- ログイン機能なし（個人使用）

## 3. 機能要件

### 3.1 トレーニング記録
- 懸垂回数の手動入力
- 記録項目
  - 登録年月日時分
  - 回数

### 3.2 グラフ表示
- 日別合計回数の折れ線グラフ
  - 実績値の折れ線
  - 目標値の折れ線
- X軸: 日付（DD形式）
- Y軸: 合計回数
- 表示期間選択
  - 直近1か月（デフォルト）
  - 直近3か月
  - 全期間

### 3.3 目標設定機能
- 一日の目標回数設定
- 目標達成の自動判定
  - 一日の合計数が目標値に到達した時点で達成
- 目標値の自動調整
  - 達成時の合計数 + 5回を翌日の目標値として設定
  - 目標達成時に即時更新
- 目標達成時のビジュアルフィードバック

## 4. データモデル

### 4.1 トレーニング記録
```dart
class TrainingRecord {
  DateTime timestamp;  // 登録年月日時分
  int repetitions;    // 回数
}
```

### 4.2 日別合計
```dart
class DailyTotal {
  DateTime date;      // 日付（DD形式）
  int totalRepetitions;
  int dailyGoal;      // 一日の目標回数
}
```

### 4.3 目標設定
```dart
class DailyGoal {
  int targetRepetitions;  // 一日の目標回数
  DateTime lastUpdated;   // 最終更新日時
  
  void updateGoal(int achievedTotal) {
    targetRepetitions = achievedTotal + 5;
    lastUpdated = DateTime.now();
  }
}
```

## 5. UI/UXガイドライン
- シンプルで直感的な数値入力
- グラフの視認性を重視
  - 実績値と目標値の線を異なる色で表示
  - 目標達成時のビジュアルフィードバック
- 明確な日付表示
- エラー処理（無効な入力値の検証）

## 6. コンプライアンス要件
- [iOS App Store レビューガイドライン](https://developer.apple.com/jp/app-store/review/guidelines/)に準拠
- [Google Play デベロッパー配布契約](https://play.google/intl/ALL_jp/developer-distribution-agreement.html)に準拠

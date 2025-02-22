# 懸垂（Kensui）

懸垂回数を記録・管理するためのクロスプラットフォームアプリケーション。

## 機能

- 懸垂回数のカウントと記録
- 日別の集計データの表示
- グラフによる進捗の可視化
- 目標設定と達成管理

## 開発環境のセットアップ

1. 必要な環境
- Flutter SDK
- Git
- Visual Studio Code（Flutter拡張機能）

2. セットアップ手順
```bash
# リポジトリのクローン
git clone https://github.com/oreshihon-iida/Kensui.git
cd Kensui

# 依存関係のインストール
flutter pub get

# 開発サーバーの起動（Webブラウザ）
flutter run -d web-server --web-port 8080
```

## プロジェクト構造

```
lib/
├── models/      # データモデル
├── views/       # UI画面
├── controllers/ # ビジネスロジック
└── main.dart    # エントリーポイント
```

## ライセンス

このプロジェクトは非公開です。

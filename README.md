# Kensui - シンプルな懸垂記録アプリケーション

## アプリケーション概要
Kensuiは、日々の懸垂トレーニングを簡単に記録・管理できるクロスプラットフォームアプリケーションです。プライバシーを重視し、全てのデータをローカルに保存します。

### 主な機能
- 懸垂回数の手動入力と記録
- 日別合計回数のグラフ表示
- トレーニング履歴の管理
- ローカルバックアップとリストア

### 技術スタック
- Flutter/Dart（クロスプラットフォーム開発）
- Material Design（UIコンポーネント）
- SharedPreferences（ローカルストレージ）
- fl_chart（グラフ表示）

## インストール方法

### 必要な環境
- Flutter SDK
- Android Studio または Visual Studio Code
- iOS開発の場合：Xcode（macOSのみ）

### セットアップ手順
1. Flutter SDKのインストール
```bash
# macOSの場合
brew install flutter

# Windowsの場合
# Flutter SDKを手動でダウンロードし、環境変数に追加
```

2. 依存関係のインストール
```bash
flutter pub get
```

3. 開発環境の確認
```bash
flutter doctor
```

4. アプリケーションの実行
```bash
# Webブラウザで実行
flutter run -d web-server --web-port 8080 --release

# Androidエミュレータで実行
flutter run -d android
```

## 開発ガイドライン

### ブランチ運用
- main: プロダクションブランチ
- develop: 開発ブランチ
- feature/**: 機能実装ブランチ

### コミットメッセージ
- feat: 新機能
- fix: バグ修正
- docs: ドキュメント更新
- style: コードスタイル修正
- refactor: リファクタリング
- test: テストコード
- chore: その他

## 関連ドキュメント
- [アプリケーション設計仕様書](docs/architecture/simplified-frontend-design.md)
- [アプリストアガイドライン](docs/playbook/app-store-guidelines.md)

## ライセンス
このプロジェクトはMITライセンスの下で公開されています。

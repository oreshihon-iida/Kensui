# 懸垂 (Kensui)

シンプルな懸垂記録アプリケーションです。日々の懸垂運動を記録し、視覚化することができます。

## 主な機能
- 懸垂回数の記録
- 折れ線グラフによる日別進捗の表示
- トレーニング履歴のローカル保存

## 技術スタック
- Flutter/Dart
- SharedPreferences（ローカルストレージ）
- fl_chart（データ可視化）
- Material Design（UIコンポーネント）

## 開発環境のセットアップ

### Windowsでの環境構築

1. Flutter SDKのインストール
   - [Flutter公式サイト](https://docs.flutter.dev/get-started/install/windows)からFlutter SDKをダウンロード
   - ダウンロードしたzipファイルを任意のフォルダに展開（例：`C:\src\flutter`）
   - 環境変数のPathに展開したフォルダの`bin`ディレクトリを追加

2. 開発ツールのインストール
   - [Git for Windows](https://git-scm.com/download/win)をインストール
   - [Visual Studio Code](https://code.visualstudio.com/)をインストール
   - VSCodeでFlutter拡張機能をインストール

3. プロジェクトのセットアップ
   ```bash
   # プロジェクトのクローン
   git clone https://github.com/oreshihon-iida/Kensui.git
   cd Kensui

   # 依存パッケージのインストール
   flutter pub get
   ```

### macOSでの環境構築

1. Homebrewのインストール（未インストールの場合）
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Flutter SDKのインストール
   ```bash
   brew install flutter
   ```

3. 開発ツールのインストール
   ```bash
   # Git（未インストールの場合）
   brew install git

   # Visual Studio Code
   brew install --cask visual-studio-code
   ```

4. プロジェクトのセットアップ
   ```bash
   # プロジェクトのクローン
   git clone https://github.com/oreshihon-iida/Kensui.git
   cd Kensui

   # 依存パッケージのインストール
   flutter pub get
   ```

### 動作確認

セットアップ完了後、以下のコマンドで開発サーバーを起動できます：
```bash
flutter run
```

注意事項：
- 初期開発段階ではLinux DesktopまたはWebブラウザでの開発を推奨します
- Android/iOSでの開発には追加のセットアップが必要になります
- モバイル向け開発環境の構築手順は後日追加予定です

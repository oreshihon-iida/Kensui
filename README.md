# Kensui (懸垂カウンター)

懸垂の回数を記録するアプリケーション

## 機能
- 懸垂回数の記録
- 日別グラフ表示
- ローカルストレージでのデータ保存
- PWAサポート（ホーム画面へのインストール）
- オフラインサポート

## 環境構築手順

### 必要な環境
- Flutter SDK (3.x以上)
- Git
- Visual Studio Code + Flutter拡張機能
- Webブラウザ（Chrome推奨）

### プラットフォーム別の追加要件
#### モバイル開発用（オプション）
- Android Studio
- Android SDK
- エミュレータまたは実機デバイス

### Windows

1. Flutter SDKのインストール
   - [Flutter公式サイト](https://flutter.dev/docs/get-started/install/windows)からSDKをダウンロード
   - 環境変数の設定
   - `flutter doctor`で環境チェック

2. Android Studioのインストール
   - [Android Studio](https://developer.android.com/studio)をダウンロード
   - Flutter pluginのインストール

3. Android エミュレータのセットアップ
   - Android StudioのAVD Managerを開く
   - 「Create Virtual Device」をクリック
   - デバイスとシステムイメージを選択（例：Pixel 4, API 33）
   - エミュレータを作成

4. 依存関係のインストール
   ```bash
   flutter pub get
   ```

### macOS

1. Flutter SDKのインストール
   ```bash
   brew install flutter
   ```

2. Xcode（iOS開発用）のインストール
   - App Storeからインストール
   - `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
   - `sudo xcodebuild -runFirstLaunch`

3. Android Studio（Android開発用）のインストール
   - [Android Studio](https://developer.android.com/studio)をダウンロード
   - Flutter pluginのインストール

4. Android エミュレータのセットアップ
   - Android StudioのAVD Managerを開く
   - 「Create Virtual Device」をクリック
   - デバイスとシステムイメージを選択（例：Pixel 4, API 33）
   - エミュレータを作成

5. 依存関係のインストール
   ```bash
   flutter pub get
   ```

### Linux

1. Flutter SDKのインストール
   ```bash
   sudo snap install flutter --classic
   ```

2. 必要なパッケージのインストール
   ```bash
   sudo apt-get update
   sudo apt-get install -y \
     openjdk-11-jdk \
     android-sdk \
     qemu-kvm
   ```

3. Android Studioのインストール
   - [Android Studio](https://developer.android.com/studio)をダウンロード
   - Flutter pluginのインストール

4. Android エミュレータのセットアップ
   - KVMの有効化が必要：
     ```bash
     sudo usermod -aG kvm $USER
     ```
   - Android StudioのAVD Managerを開く
   - 「Create Virtual Device」をクリック
   - デバイスとシステムイメージを選択（例：Pixel 4, API 33）
   - エミュレータを作成

5. 依存関係のインストール
   ```bash
   flutter pub get
   ```

## 開発環境

### アプリケーションの実行

#### Webアプリケーションの実行
1. リポジトリのクローン
   ```bash
   git clone https://github.com/oreshihon-iida/Kensui.git
   cd Kensui
   ```

2. 依存関係のインストール
   ```bash
   flutter pub get
   ```

3. Webアプリケーションの起動
   ```bash
   flutter run -d web-server --web-port 8080 --release
   ```

4. ブラウザでアクセス
   - http://localhost:8080 にアクセス
   - PWA機能を利用する場合は、Chromeのインストールプロンプトに従ってください

#### デバッグモードでの実行
開発時は以下のコマンドでデバッグモードを使用できます：
```bash
flutter run -d web-server --web-port 8080
```

#### ビルドとデプロイ
リリース用のビルドを作成：
```bash
flutter build web --release
```
ビルドされたファイルは `build/web` ディレクトリに出力されます。

## トラブルシューティング

### Webアプリケーションの問題
1. キャッシュの問題
   - ブラウザのキャッシュをクリア
   - `flutter clean` を実行して再ビルド

2. 依存関係の問題
   - `flutter pub get` を再実行
   - `flutter pub outdated` で更新可能なパッケージを確認

3. ビルドエラー
   - `flutter clean` を実行
   - `flutter doctor` で環境の問題を確認

### エミュレータが起動しない場合
1. KVMの確認
   ```bash
   kvm-ok
   ```

2. ハードウェアアクセラレーションの確認
   - BIOSでVT-x/AMD-Vが有効になっているか確認
   - KVMモジュールが読み込まれているか確認
   ```bash
   lsmod | grep kvm
   ```

3. 権限の確認
   ```bash
   ls -l /dev/kvm
   groups | grep kvm
   ```

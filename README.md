# Kensui (懸垂カウンター)

懸垂の回数を記録するアプリケーション

## 機能
- 懸垂回数の記録
- 日別グラフ表示
- ローカルストレージでのデータ保存

## 環境構築手順

### 必要な環境
- Flutter SDK
- Android Studio または Visual Studio Code
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

## エミュレータの要件

### ハードウェア要件
- Intel VT-x/AMD-V対応プロセッサ
- ハードウェアアクセラレーション（Intel HAXM または KVM）
- 最小4GB RAM
- グラフィックスドライバーのサポート

### 実機デバイスでのテスト
- USBデバッグを有効にしたAndroidデバイス
- または開発者モードを有効にしたiOSデバイス

## トラブルシューティング

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

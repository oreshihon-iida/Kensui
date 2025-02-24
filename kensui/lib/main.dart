import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/input_screen.dart';
import 'services/storage_service.dart';

/// アプリケーションのエントリーポイント
///
/// アプリケーションの初期化を行い、必要な依存関係を設定します：
/// 1. Flutterバインディングの初期化
/// 2. SharedPreferencesインスタンスの取得
/// 3. StorageServiceの初期化
/// 4. アプリケーションのルートウィジェットの起動
void main() async {
  // Flutterバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferencesのインスタンスを取得
  final prefs = await SharedPreferences.getInstance();
  // StorageServiceを初期化
  final storageService = StorageService(prefs);
  // アプリケーションを起動
  runApp(MyApp(storageService: storageService));
}

/// アプリケーションのルートウィジェット
///
/// Material Design 3のテーマを設定し、
/// アプリケーションの基本的な外観と動作を定義します。
/// StorageServiceをInputScreenに提供します。
class MyApp extends StatelessWidget {
  /// データ永続化を担当するStorageServiceインスタンス
  final StorageService storageService;

  /// MyAppのコンストラクタ
  ///
  /// [storageService] - アプリケーション全体で使用するStorageService
  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kensui',
      theme: ThemeData(
        // ブルーを基調としたカラースキームを設定
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // Material Design 3を有効化
        useMaterial3: true,
      ),
      // InputScreenをホーム画面として設定
      home: InputScreen(storageService: storageService),
    );
  }
}

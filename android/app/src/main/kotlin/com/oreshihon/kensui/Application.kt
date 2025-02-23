package com.oreshihon.kensui

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugins.GeneratedPluginRegistrant

class Application : Application() {
    lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()
        
        // Initialize and cache FlutterEngine
        flutterEngine = FlutterEngine(this).apply {
            dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        }
        
        // Register all plugins
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        // Cache the FlutterEngine
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
    }
}

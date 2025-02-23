package com.oreshihon.kensui

import android.app.Application
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugins.GeneratedPluginRegistrant

class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
    }
}

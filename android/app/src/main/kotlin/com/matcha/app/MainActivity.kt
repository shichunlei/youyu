package com.matcha.app

import io.flutter.embedding.android.FlutterActivity
import android.util.Log
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            Log.e("Flutter", "Uncaught error in thread ${thread.name}", throwable)
        }
    }
}

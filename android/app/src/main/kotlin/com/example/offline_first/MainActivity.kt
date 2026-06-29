package com.example.offline_first

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // 1. Nama jembatan ini harus sama persis dengan yang ada di Dart
    private val CHANNEL = "utd.enterprise.channel/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // 2. Menerima instruksi khusus
            if (call.method == "showReversedNimToast") {
                // Menangkap parameter NIM yang dikirim Dart
                val nim = call.argument<String>("nim")
                
                if (nim != null) {
                    // 3. LOGIKA ANTI-AI KOTLIN: Membalikkan string (20123011 jadi 11032102)
                    val reversedNim = nim.reversed()
                    
                    // 4. Memunculkan Native Toast di layar
                    Toast.makeText(context, "NIM Dibalik (Kotlin): $reversedNim", Toast.LENGTH_LONG).show()
                    
                    // Mengirim status berhasil kembali ke Dart
                    result.success(reversedNim)
                } else {
                    result.error("UNAVAILABLE", "NIM tidak ditemukan.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
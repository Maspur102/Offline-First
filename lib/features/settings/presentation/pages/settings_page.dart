import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib untuk Method Channel
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;
  
  // 1. Deklarasi Nama Jembatan (Harus sama persis dengan yang ada di Kotlin nanti)
  static const platform = MethodChannel('utd.enterprise.channel/native');

  // 2. Fungsi Pengirim Pesan ke Mesin Kotlin
  Future<void> _invokeNativeToast() async {
    try {
      // Mengirimkan NIM Purnama secara langsung (Anti-AI Challenge)
      await platform.invokeMethod('showReversedNimToast', {'nim': '20123011'});
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil native channel: '${e.message}'.");
    }
  }

  void _handleProfileClick() {
    if (_showEasterEgg) return; 

    setState(() {
      _clickCount++;
    });

    if (_clickCount == 1) {
      _triggerEasterEgg();
      _clickCount = 0; 
    }
  }

  void _triggerEasterEgg() {
    setState(() {
      _showEasterEgg = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showEasterEgg = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Profil'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleProfileClick,
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('UTD Store', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Purnama Raharja - 20123011', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                const Text('Tugas Individu (UAS)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 30),
                
                // TOMBOL BARU: Untuk Memicu Native Toast
                ElevatedButton.icon(
                  onPressed: _invokeNativeToast,
                  icon: const Icon(Icons.android, color: Colors.green),
                  label: const Text('Uji Native Method Channel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Beranda'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )
              ],
            ),
          ),
          
          if (_showEasterEgg)
            Positioned.fill(
              child: Container(
                color: Colors.black87, 
                child: Center(
                  child: Lottie.network(
                    'https://lottie.host/17e089d5-f55a-4e20-ae28-66a9359e2f5b/V2aE1EStN3.json', 
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;

  void _handleProfileClick() {
    if (_showEasterEgg) return; // Mencegah klik saat animasi sedang berjalan

    setState(() {
      _clickCount++;
    });

    // TANTANGAN ANTI-AI: Pemicu animasi berdasarkan digit terakhir NPM (1)
    if (_clickCount == 1) {
      _triggerEasterEgg();
      _clickCount = 0; // Reset penghitung
    }
  }

  void _triggerEasterEgg() {
    setState(() {
      _showEasterEgg = true;
    });

    // Menahan animasi tampil di layar selama persis 3 detik
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
          // Lapis 1: Halaman Profil Utama
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
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali ke Beranda'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )
              ],
            ),
          ),
          
          // Lapis 2: Animasi Lottie Rahasia (Hanya Muncul Saat Dipicu)
          if (_showEasterEgg)
            Positioned.fill(
              child: Container(
                color: Colors.black87, // Latar gelap agar animasi pop-up menonjol
                child: Center(
                  child: Lottie.network(
                    // Animasi perayaan kembang api & piala
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
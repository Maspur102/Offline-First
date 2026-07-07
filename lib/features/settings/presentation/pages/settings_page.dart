import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;
  
  static const platform = MethodChannel('utd.enterprise.channel/native');

  Future<void> _invokeNativeToast() async {
    try {
      // Mengirimkan NIM Purnama ke Kotlin
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

    // Pemicu Lottie: Karena NIM 20123011 berakhiran angka 1, cukup 1 kali klik!
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _handleProfileClick,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('DigiNews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Struktur tabel rata kiri dengan identitas Purnama Raharja
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(16),
                    2: FlexColumnWidth(),
                  },
                  children: const [
                    TableRow(children: [Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('Purnama Raharja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    TableRow(children: [SizedBox(height: 12), SizedBox(), SizedBox()]),
                    TableRow(children: [Text('NPM', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('20123011', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    TableRow(children: [SizedBox(height: 12), SizedBox(), SizedBox()]),
                    TableRow(children: [Text('Keterangan', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('Tugas Individu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                  ],
                ),
                
                const SizedBox(height: 40),
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
                    errorBuilder: (context, error, stackTrace) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cake, color: Colors.amber, size: 80),
                          SizedBox(height: 16),
                          Text('🎉 Easter Egg Terbuka! 🎉\n(Nyalakan internet untuk animasi penuh)', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
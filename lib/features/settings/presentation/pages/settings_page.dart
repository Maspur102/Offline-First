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
      await platform.invokeMethod('showReversedNimToast', {'nim': '20123021'});
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handleProfileClick() {
    if (_showEasterEgg) return; 
    setState(() { _clickCount++; });
    if (_clickCount == 1) {
      setState(() { _showEasterEgg = true; });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() { _showEasterEgg = false; });
      });
      _clickCount = 0; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Profil')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // PERBAIKAN: Rata Kiri
              children: [
                GestureDetector(
                  onTap: _handleProfileClick,
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 45, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                
                // PERBAIKAN: Struktur Tabel agar sangat rapi sejajar
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(16),
                    2: FlexColumnWidth(),
                  },
                  children: const [
                    TableRow(children: [Text('Aplikasi', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('UTD Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    TableRow(children: [SizedBox(height: 12), SizedBox(), SizedBox()]),
                    TableRow(children: [Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('Rifky Raihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    TableRow(children: [SizedBox(height: 12), SizedBox(), SizedBox()]),
                    TableRow(children: [Text('NIM', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(), Text('20123021', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                  ],
                ),
                
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _invokeNativeToast,
                  icon: const Icon(Icons.android, color: Colors.green),
                  label: const Text('Uji Native Method Channel'),
                ),
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
                    errorBuilder: (c, e, s) => const Icon(Icons.cake, color: Colors.amber, size: 80),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 🌟 dotenv import

// Sayfaları import ediyoruz
import 'pages/ana_sayfa.dart';
import 'pages/biyografiler_sayfasi.dart';
import 'pages/harita_sayfasi.dart';
import 'pages/quiz_sayfasi.dart'; // 🌟 Yeni quiz sayfası importu

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // 🌟 .env dosyasını yükle
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milli Mücadele Rehberi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const AnaNavigasyon(),
    );
  }
}

class AnaNavigasyon extends StatefulWidget {
  const AnaNavigasyon({super.key});

  @override
  State<AnaNavigasyon> createState() => _AnaNavigasyonState();
}

class _AnaNavigasyonState extends State<AnaNavigasyon> {
  int _seciliIndex = 0;

  static const List<Widget> _sayfaListesi = <Widget>[
    AnaSayfa(),
    BiyografilerSayfasi(),
    HaritaSayfasi(),
    QuizSayfasi(), // 🌟 Quiz sayfası eklendi
  ];

  void _onItemTapped(int index) {
    setState(() {
      _seciliIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _sayfaListesi.elementAt(_seciliIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Biyografiler',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Harita'),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Bilgi Testi',
          ), // 🌟 Yeni ikon ve isim
        ],
        currentIndex: _seciliIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

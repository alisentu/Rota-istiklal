// lib/pages/ana_sayfa.dart
import 'package:flutter/material.dart';
import 'dart:async';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> _quotes = [
    {
      'quote': 'Ne mutlu Türküm diyene!',
      'year': '1933, Ankara',
    }, // ✅ İlk sırada
    {'quote': 'Yurtta sulh, cihanda sulh.', 'year': '1931, Ankara'},
    {
      'quote': 'Hayatta en hakiki mürşit ilimdir, fendir.',
      'year': '1924, Samsun',
    },
    {
      'quote': 'Egemenlik kayıtsız şartsız milletindir.',
      'year': '1920, Ankara',
    },
    {
      'quote':
          'Beni görmek demek, yüzümü görmek değildir. Benim fikirlerimi, benim duygularımı anlıyorsanız bu yeterlidir.',
      'year': '1930, İstanbul',
    },
    {
      'quote':
          'Sanatsız kalan bir milletin hayat damarlarından biri kopmuş demektir.',
      'year': '1923, İzmir',
    },
    {
      'quote': 'Vatanını en çok seven, görevini en iyi yapandır.',
      'year': '1929, Ankara',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_currentPage < _quotes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_quotes.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.red.shade700 : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text(
          'Atatürk’ün Sözleri',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade100,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _quotes.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final soz = _quotes[index];

                // 🔴 "Ne mutlu Türküm diyene!" için görsel ekleme
                if (soz['quote'] == 'Ne mutlu Türküm diyene!') {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assest/atam.png',
                          fit:
                              BoxFit
                                  .contain, // Görseli düzgün orantılı gösterir
                        ),
                      ),
                    ),
                  );
                }

                // 🔹 Diğer sözler
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 36,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_quote,
                              size: 40,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              soz['quote'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              soz['year'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildIndicator(),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

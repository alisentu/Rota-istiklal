// lib/pages/quiz_sayfasi.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuizSayfasi extends StatefulWidget {
  const QuizSayfasi({super.key});

  @override
  State<QuizSayfasi> createState() => _QuizSayfasiState();
}

class _QuizSayfasiState extends State<QuizSayfasi> {
  List<dynamic> sorular = [];
  int aktifSoru = 0;
  int dogruSayisi = 0;
  bool yukleniyor = true;

  // === YENİ DEĞİŞKENLER ===
  int? secilenCevapIndex; // Seçilen şıkkın index'i
  bool cevapVerildi = false; // Cevap verilip verilmediği
  // ========================

  Future<void> getSorular() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    final body = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "SADECE ve SADECE JSON formatında bir liste üret. BAŞKA HİÇBİR METİN VEYA AÇIKLAMA EKLEME. Konu: Atatürk. Format: [{\"soru\": \"\", \"secenekler\": [\"\", \"\", \"\", \"\"], \"dogru\": 1}, {...}, ...]. Toplam 10 soru olsun. Türkçe yaz.",
            },
          ],
        },
      ],
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];

      String cleanText = text.trim();

      if (cleanText.startsWith('```')) {
        cleanText =
            cleanText
                .replaceAll(RegExp(r'```(json)?'), '')
                .replaceAll(RegExp(r'```'), '')
                .trim();
      }

      if (!cleanText.startsWith('[')) {
        final startIndex = cleanText.indexOf('[');
        final lastIndex = cleanText.lastIndexOf(']');

        if (startIndex != -1 && lastIndex != -1 && lastIndex > startIndex) {
          cleanText = cleanText.substring(startIndex, lastIndex + 1);
        } else {
          cleanText = "[]";
        }
      }

      try {
        final parsed = jsonDecode(cleanText);

        setState(() {
          if (parsed is List) {
            sorular = parsed;
          } else {
            sorular = [];
          }
          yukleniyor = false;
        });
      } catch (e) {
        debugPrint("JSON parse hatası: $e");
        setState(() {
          yukleniyor = false;
          sorular = [];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Veri formatı hatası. Tekrar deneyin."),
            ),
          );
        });
      }
    } else {
      debugPrint("API hata: ${response.statusCode}");
      setState(() {
        yukleniyor = false;
        sorular = [];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API hatası: ${response.statusCode}")),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSorular();
  }

  void cevapVer(int index) {
    // Cevap zaten verildiyse tekrar tıklamayı engelle
    if (cevapVerildi) return;

    setState(() {
      secilenCevapIndex = index;
      cevapVerildi = true;
      if (index == sorular[aktifSoru]['dogru']) {
        dogruSayisi++;
      }
    });
  }

  void sonrakiSoruyaGec() {
    if (aktifSoru < sorular.length - 1) {
      setState(() {
        aktifSoru++;
        cevapVerildi = false; // Yeni soru için durumu sıfırla
        secilenCevapIndex = null; // Seçimi sıfırla
      });
    } else {
      // Test bittiğinde dialog göster
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Test Bitti 🎯"),
              content: Text("Doğru sayınız: $dogruSayisi / ${sorular.length}"),
              actions: [
                // 1. İPTAL Butonu (Mevcut sonuçta kalmak için)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("İptal"),
                ),
                // 2. TEKRAR DENE Butonu
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dialogu kapat
                    setState(() {
                      aktifSoru = 0;
                      dogruSayisi = 0;
                      yukleniyor = true;
                      cevapVerildi = false;
                      secilenCevapIndex = null;
                      sorular = [];
                    });
                    getSorular(); // Yeni soruları çek
                  },
                  child: const Text("Tekrar Dene"),
                ),
              ],
            ),
      );
    }
  }

  // Şık butonlarının rengini belirleyen yardımcı fonksiyon
  Color? getButtonColor(int index) {
    if (!cevapVerildi) return null; // Cevap verilmediyse varsayılan renk

    int dogruIndex = sorular[aktifSoru]['dogru'];

    if (index == dogruIndex) {
      return Colors.green.shade700; // Doğru cevap her zaman yeşil
    }

    if (index == secilenCevapIndex) {
      return Colors.red.shade700; // Yanlış seçilen cevap kırmızı
    }

    return null; // Diğerleri varsayılan renk
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atatürk Bilgi Testi"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
      ),
      body:
          yukleniyor
              ? const Center(child: CircularProgressIndicator())
              : sorular.isEmpty
              ? const Center(
                child: Text(
                  "Soru yüklenirken bir hata oluştu. API yanıtını kontrol edin.",
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Soru Numarası
                    Text(
                      "Soru ${aktifSoru + 1}/${sorular.length}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                    const Divider(height: 20, thickness: 2),

                    // Soru Metni
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sorular[aktifSoru]['soru'] ?? "Soru yüklenemedi.",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Cevap Seçenekleri
                    ...List.generate(4, (index) {
                      final secenekText =
                          sorular[aktifSoru]['secenekler'][index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => cevapVer(index),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor:
                                getButtonColor(index) ?? Colors.indigo.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            secenekText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }),

                    const Spacer(), // Boş kalan alanı doldurur
                    // Sonraki Soru Butonu
                    if (cevapVerildi)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: sonrakiSoruyaGec,
                          icon: Icon(
                            aktifSoru == sorular.length - 1
                                ? Icons.done_all
                                : Icons.arrow_forward,
                          ),
                          label: Text(
                            aktifSoru == sorular.length - 1
                                ? "Sonuçları Gör"
                                : "Sonraki Soru",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}

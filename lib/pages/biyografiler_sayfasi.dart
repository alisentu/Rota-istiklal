import 'package:flutter/material.dart';
import '../services/wikipedia_service.dart';

class BiyografilerSayfasi extends StatefulWidget {
  const BiyografilerSayfasi({super.key});

  @override
  State<BiyografilerSayfasi> createState() => _BiyografilerSayfasiState();
}

class _BiyografilerSayfasiState extends State<BiyografilerSayfasi> {
  final List<String> _kahramanlar = [
    "Mustafa Kemal Atatürk",
    "İsmet İnönü",
    "Kazım Karabekir",
    "Fevzi Çakmak",
    "Rauf Orbay",
    "Ali Fuat Cebesoy",
    "Halide Edib Adıvar",
  ];

  late Future<List<Map<String, dynamic>>> _biyografiListesi;
  final Set<int> _genisleyenKartlar = {}; // Açık olan biyografileri tutar

  @override
  void initState() {
    super.initState();
    _biyografiListesi = _fetchAllBiographies();
  }

  Future<List<Map<String, dynamic>>> _fetchAllBiographies() async {
    List<Map<String, dynamic>> results = [];

    for (String name in _kahramanlar) {
      final bio = await WikipediaService.fetchBiography(name);
      if (bio != null) results.add(bio);
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biyografiler'),
        backgroundColor: Colors.red.shade100,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _biyografiListesi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Veri yüklenirken hata oluştu."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Biyografi bulunamadı."));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final isExpanded = _genisleyenKartlar.contains(index);

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _genisleyenKartlar.remove(index);
                      } else {
                        _genisleyenKartlar.add(index);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          item['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 200),
                                crossFadeState:
                                    isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                firstChild: Text(
                                  item['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                secondChild: Text(item['description']),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isExpanded ? "Daralt ▲" : "Devamını Oku ▼",
                                style: TextStyle(
                                  color: Colors.red.shade400,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

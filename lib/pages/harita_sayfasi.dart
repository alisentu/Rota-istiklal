// lib/pages/harita_sayfasi.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/wikipedia_service.dart';

class HaritaSayfasi extends StatefulWidget {
  const HaritaSayfasi({super.key});

  @override
  State<HaritaSayfasi> createState() => _HaritaSayfasiState();
}

class _HaritaSayfasiState extends State<HaritaSayfasi> {
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  int _selectedYear = 1919;

  final List<Map<String, dynamic>> _events = [
    {
      'id': 'samsun',
      'title': '1919 - Samsun’a Çıkış',
      'lat': 41.2867,
      'lng': 36.33,
      'year': 1919,
      'wiki': 'Mustafa_Kemal\'in_Samsun\'a_çıkışı',
    },
    {
      'id': 'amasya',
      'title': '1919 - Amasya Genelgesi',
      'lat': 40.6525,
      'lng': 36.3289,
      'year': 1919,
      'wiki': 'Amasya_Genelgesi',
    },
    {
      'id': 'erzurum',
      'title': '1919 - Erzurum Kongresi',
      'lat': 39.90861,
      'lng': 41.27694,
      'year': 1919,
      'wiki': 'Erzurum_Kongresi',
    },
    {
      'id': 'sivas',
      'title': '1919 - Sivas Kongresi',
      'lat': 39.74833,
      'lng': 37.01611,
      'year': 1919,
      'wiki': 'Sivas_Kongresi',
    },
    {
      'id': 'ankara_tbmm',
      'title': '1920 - TBMM’nin Açılışı (Ankara)',
      'lat': 39.9207886,
      'lng': 32.8540482,
      'year': 1920,
      'wiki': 'Türkiye_Büyük_Millet_Meclisi',
    },
    {
      'id': 'sakarya',
      'title': '1921 - Sakarya Meydan Muharebesi',
      'lat': 39.7819,
      'lng': 31.1391,
      'year': 1921,
      'wiki': 'Sakarya_Meydan_Muharebesi',
    },
    {
      'id': 'izmir',
      'title': '1922 - Büyük Taarruz ve İzmir’in Kurtuluşu',
      'lat': 38.423734,
      'lng': 27.142826,
      'year': 1922,
      'wiki': 'Büyük_Taarruz',
    },
    {
      'id': 'cumhuriyet',
      'title': '1923 - Cumhuriyet’in İlanı',
      'lat': 39.9207886,
      'lng': 32.8540482,
      'year': 1923,
      'wiki': 'Türkiye_Cumhuriyeti\'nin_ilanı',
    },
    {
      'id': 'kadin_haklari',
      'title': '1934 - Kadınlara Seçme ve Seçilme Hakkı',
      'lat': 39.92,
      'lng': 32.85,
      'year': 1934,
      'wiki': 'Türk_kadınına_seçme_ve_seçilme_hakkı',
    },
    {
      'id': 'ataturk_olum',
      'title': '1938 - Atatürk’ün Vefatı (İstanbul)',
      'lat': 41.0082,
      'lng': 28.9784,
      'year': 1938,
      'wiki': 'Mustafa_Kemal_Atatürk\'ün_ölümü',
    },
  ];

  final Map<MarkerId, Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _buildMarkersForYear(_selectedYear);
    _buildGradientPolyline();
  }

  void _buildMarkersForYear(int year) {
    _markers.clear();
    for (final ev in _events) {
      if ((ev['year'] as int) <= year) {
        final id = MarkerId(ev['id'] as String);
        final marker = Marker(
          markerId: id,
          position: LatLng(ev['lat'], ev['lng']),
          infoWindow: InfoWindow(title: ev['title']),
          onTap: () => _onMarkerTapped(ev),
        );
        _markers[id] = marker;
      }
    }
    setState(() {});
  }

  /// 🔴⚪ Kırmızı-beyaz geçişli çizgi
  void _buildGradientPolyline() {
    final points =
        _events
            .map((ev) => LatLng(ev['lat'] as double, ev['lng'] as double))
            .toList();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('atatürk_yolu'),
        points: points,
        color: Colors.red.shade700,
        width: 5,
        patterns: [PatternItem.dash(12), PatternItem.gap(4)],
      ),
    );
  }

  Future<void> _onMarkerTapped(Map<String, dynamic> event) async {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(event['lat'], event['lng']), 8.5),
    );

    final wikiName = event['wiki'] as String;
    final bio = await WikipediaService.fetchBiography(wikiName);

    _showDetailBottomSheet(
      title: bio?['title'] ?? event['title'],
      content: bio?['description'] ?? 'Bilgi bulunamadı.',
      imageUrl: bio?['image'],
    );
  }

  void _showDetailBottomSheet({
    required String title,
    required String content,
    String? imageUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.4), // 🌫️ Transparan görünüm
      barrierColor: Colors.black.withOpacity(0.2),
      builder:
          (_) => DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.25,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, controller) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(content, style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Kapat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  CameraPosition get _initialCamera =>
      const CameraPosition(target: LatLng(39.0, 35.0), zoom: 5.3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atatürk’ün Yolculuğu'),
        backgroundColor: Colors.red.shade100,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Yıl: $_selectedYear',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedYear = 1919;
                      _buildMarkersForYear(_selectedYear);
                    });
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(_initialCamera),
                    );
                  },
                  child: const Text('Sıfırla'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Slider(
              activeColor: Colors.red.shade400,
              inactiveColor: Colors.red.shade100,
              value: (_selectedYear - 1919).toDouble(),
              min: 0,
              max: (1938 - 1919).toDouble(),
              divisions: 19,
              label: '$_selectedYear',
              onChanged: (v) async {
                final year = 1919 + v.toInt();
                setState(() {
                  _selectedYear = year;
                  _buildMarkersForYear(_selectedYear);
                });
                final currentEvent = _events.lastWhere(
                  (ev) => ev['year'] <= year,
                  orElse: () => _events.first,
                );
                await _mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(currentEvent['lat'], currentEvent['lng']),
                    7.8,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialCamera,
              mapType: MapType.terrain, // 🏞️ Terrain tipi harita
              onMapCreated: (controller) {
                _mapController = controller;
                _controllerCompleter.complete(controller);
              },
              markers: Set<Marker>.of(_markers.values),
              polylines: _polylines,
              zoomControlsEnabled: false, // 🔧 Zoom butonlarını kaldır
              mapToolbarEnabled: false, // 🔧 Harita araç çubuğunu kaldır
              myLocationButtonEnabled: false, // 🔧 Konum butonunu kaldır
              compassEnabled: false, // 🔧 Pusula kaldır
            ),
          ),
        ],
      ),
    );
  }
}

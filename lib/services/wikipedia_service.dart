import 'dart:convert';
import 'package:http/http.dart' as http;

class WikipediaService {
  static Future<Map<String, dynamic>?> fetchBiography(String name) async {
    final encodedName = Uri.encodeComponent(name);
    final url =
        'https://tr.wikipedia.org/api/rest_v1/page/summary/$encodedName';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'title': data['title'] ?? '',
        'description': data['extract'] ?? 'Açıklama bulunamadı.',
        'image':
            data['thumbnail']?['source'] ??
            'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg',
      };
    } else {
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String _baseUrl = 'https://swapi.dev/api';

  Future<Map<String, dynamic>> fetchCharacters(int page) async {
    final uri = Uri.parse('$_baseUrl/people/?page=$page');
    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final characters = (data['results'] as List)
          .map((json) => Character.fromJson(json))
          .toList();
      return {
        'characters': characters,
        'hasNext': data['next'] != null,
        'count': data['count'],
      };
    } else {
      throw Exception('Failed to load characters (${response.statusCode})');
    }
  }
}

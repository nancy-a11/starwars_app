import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  const ApiService();

  Future<Map<String, dynamic>> fetchCharacters(int page) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.peopleEndpoint}?page=$page',
    );
    final response = await http.get(uri).timeout(ApiConstants.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'characters': (data['results'] as List)
            .map((j) => Character.fromJson(j))
            .toList(),
        'hasNext': data['next'] != null,
        'count': data['count'] as int,
      };
    }
    throw Exception('Server error (${response.statusCode})');
  }
}

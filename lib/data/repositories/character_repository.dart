import '../models/character.dart';
import '../services/api_service.dart';

/// Sits between the provider and ApiService.
/// In future: add caching, offline support, or swap data source here
/// without touching any UI code.
class CharacterRepository {
  const CharacterRepository(this._apiService);

  final ApiService _apiService;

  Future<({List<Character> characters, bool hasNext, int count})> getCharacters(
    int page,
  ) async {
    final result = await _apiService.fetchCharacters(page);
    return (
      characters: result['characters'] as List<Character>,
      hasNext: result['hasNext'] as bool,
      count: result['count'] as int,
    );
  }
}

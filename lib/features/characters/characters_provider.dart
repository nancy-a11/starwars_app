import 'package:flutter/foundation.dart';
import '../../data/models/character.dart';
import '../../data/repositories/character_repository.dart';

enum LoadingStatus { idle, loading, loadingMore, success, error }

class CharactersProvider extends ChangeNotifier {
  CharactersProvider(this._repository);

  final CharacterRepository _repository;

  List<Character> _characters = [];
  LoadingStatus _status = LoadingStatus.idle;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  int _totalCount = 0;

  List<Character> get characters => _characters;
  LoadingStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get hasNextPage => _hasNextPage;
  int get totalCount => _totalCount;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get isLoadingMore => _status == LoadingStatus.loadingMore;

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _characters = [];
      _hasNextPage = true;
    }
    if (_status == LoadingStatus.loading ||
        _status == LoadingStatus.loadingMore) return;
    if (!_hasNextPage && !refresh) return;

    _status =
        _currentPage == 1 ? LoadingStatus.loading : LoadingStatus.loadingMore;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _repository.getCharacters(_currentPage);
      _characters.addAll(result.characters);
      _hasNextPage = result.hasNext;
      _totalCount = result.count;
      _currentPage++;
      _status = LoadingStatus.success;
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }

  String _parseError(String error) {
    if (error.contains('SocketException') ||
        error.contains('NetworkException')) {
      return 'No internet connection. Please check your network.';
    } else if (error.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}

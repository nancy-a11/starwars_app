import 'package:flutter/material.dart';
import '../features/characters/characters_screen.dart';


class AppRouter {
  static const String characters = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characters:
        return MaterialPageRoute(
          builder: (_) => const CharactersScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}

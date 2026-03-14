import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/character_repository.dart';
import 'data/services/api_service.dart';
import 'features/characters/characters_provider.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const StarWarsApp());
}

class StarWarsApp extends StatelessWidget {
  const StarWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       
        Provider(create: (_) => const ApiService()),
        ProxyProvider<ApiService, CharacterRepository>(
          update: (_, api, __) => CharacterRepository(api),
        ),
        ChangeNotifierProxyProvider<CharacterRepository, CharactersProvider>(
          create: (ctx) => CharactersProvider(
            ctx.read<CharacterRepository>(),
          ),
          update: (_, repo, prev) => prev ?? CharactersProvider(repo),
        ),
      ],
      child: MaterialApp(
        title: 'Star Wars Characters',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        initialRoute: AppRouter.characters,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

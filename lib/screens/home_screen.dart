import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/characters_provider.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharactersProvider>().fetchCharacters();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharactersProvider>().fetchCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(cs),
          _buildBody(cs),
        ],
      ),
    );
  }

  Widget _buildAppBar(ColorScheme cs) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: cs.background,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Consumer<CharactersProvider>(
          builder: (_, provider, __) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'STAR WARS',
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (provider.totalCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        '${provider.totalCount}',
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                'Characters',
                style: TextStyle(
                  color: cs.onBackground.withOpacity(0.5),
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    return Consumer<CharactersProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SliverFillRemaining(child: _LoadingView(color: cs.primary));
        }

        if (provider.status == LoadingStatus.error && provider.characters.isEmpty) {
          return SliverFillRemaining(
            child: _ErrorView(
              message: provider.errorMessage,
              color: cs.primary,
              onRetry: () => provider.fetchCharacters(refresh: true),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == provider.characters.length) {
                if (provider.isLoadingMore) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: cs.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                if (provider.status == LoadingStatus.error) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () => provider.fetchCharacters(),
                        icon: Icon(Icons.refresh, color: cs.primary),
                        label: Text('Retry', style: TextStyle(color: cs.primary)),
                      ),
                    ),
                  );
                }
                if (!provider.hasNextPage) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '— End of the galaxy —',
                        style: TextStyle(
                          color: cs.onBackground.withOpacity(0.3),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final character = provider.characters[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(16, index == 0 ? 8 : 6, 16, 6),
                child: CharacterCard(character: character, index: index),
              );
            },
            childCount: provider.characters.length + 1,
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  final Color color;
  const _LoadingView({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: color, strokeWidth: 2.5),
        const SizedBox(height: 20),
        Text(
          'Loading characters…',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Color color;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.color, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56, color: cs.onBackground.withOpacity(0.25)),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onBackground.withOpacity(0.6), fontSize: 15),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

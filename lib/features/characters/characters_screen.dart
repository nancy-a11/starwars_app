import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'characters_provider.dart';
import 'widgets/character_card.dart';
import '../../shared/widgets/error_view.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: cs.primary.withOpacity(0.3)),
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
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5),
                  const SizedBox(height: 20),
                  Text(
                    'Loading characters…',
                    style: TextStyle(
                        color: cs.onBackground.withOpacity(0.4), fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.status == LoadingStatus.error &&
            provider.characters.isEmpty) {
          return SliverFillRemaining(
            child: ErrorView(
              message: provider.errorMessage,
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
                          color: cs.primary, strokeWidth: 2),
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
                        label: Text('Retry',
                            style: TextStyle(color: cs.primary)),
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

              return Padding(
                padding: EdgeInsets.fromLTRB(
                    16, index == 0 ? 8 : 6, 16, 6),
                child: CharacterCard(
                  character: provider.characters[index],
                  index: index,
                ),
              );
            },
            childCount: provider.characters.length + 1,
          ),
        );
      },
    );
  }
}

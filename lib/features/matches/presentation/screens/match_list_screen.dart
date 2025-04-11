import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart'; // Import providers
import '../../domain/match.dart' as domain; // Import custom Match with prefix
import '../widgets/match_list_item.dart'; // Import list item widget
import '../../../favorites/application/favorites_notifier.dart'; // Import favorites notifier

// Displays lists of upcoming and previous matches using Tabs
class MatchListScreen extends ConsumerStatefulWidget {
  const MatchListScreen({super.key});

  @override
  ConsumerState<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends ConsumerState<MatchListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showOnlyFavorites = false; // State for the filter toggle

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 Tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'), // Changed title
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Previous')],
          // Theme styling is applied via tabBarTheme in AppTheme
        ),
        actions: [
          // Add filter chip to AppBar actions
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: const Text('Favorites'),
              selected: _showOnlyFavorites,
              onSelected: (selected) {
                setState(() {
                  _showOnlyFavorites = selected;
                  // TODO: Trigger data refresh/refiltering if necessary
                  // This might involve ref.refresh() on providers or passing
                  // the filter state down to the _buildMatchList helper.
                });
              },
              // Theme styling is applied via chipTheme in AppTheme
              showCheckmark: false, // Keep checkmark off for toggle style
              // selectedColor is now handled by the theme
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Matches List
          _buildMatchList(upcomingMatchesProvider),
          // Previous Matches List
          _buildMatchList(previousMatchesProvider),
        ],
      ),
    );
  }

  // Helper widget to build a list based on a provider
  Widget _buildMatchList(
    AutoDisposeFutureProvider<List<domain.Match>> provider,
  ) {
    final asyncMatches = ref.watch(provider);
    return asyncMatches.when(
      data: (matches) {
        if (matches.isEmpty) {
          // Use more specific message based on provider?
          return const Center(child: Text('No matches found for this view.'));
        }

        // --- Filtering Logic ---
        final favoriteIds =
            ref.watch(favoritesNotifierProvider).asData?.value ?? [];
        final filteredMatches =
            _showOnlyFavorites
                ? matches.where((match) {
                  // Simple filter: show match if home OR away team is favorite
                  // TODO: Make filtering logic more robust/configurable
                  return favoriteIds.contains(match.homeTeam.id.toString()) ||
                      favoriteIds.contains(match.awayTeam.id.toString());
                }).toList()
                : matches; // Show all if filter is off

        if (filteredMatches.isEmpty && _showOnlyFavorites) {
          return const Center(
            child: Text('No matches found for your favorite teams.'),
          );
        }
        if (filteredMatches.isEmpty && !_showOnlyFavorites) {
          return const Center(child: Text('No matches found for this view.'));
        }
        // --- End Filtering Logic ---

        // Display the list of matches
        // Display the filtered list of matches
        return ListView.builder(
          itemCount: filteredMatches.length, // Use filtered list length
          itemBuilder: (context, index) {
            final match = filteredMatches[index]; // Use filtered list item
            return MatchListItem(match: match);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        // TODO: Improve error display
        print('Error loading matches: $error');
        print(stackTrace);
        return Center(child: Text('Error loading matches: $error'));
      },
    );
  }
}

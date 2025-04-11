import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart'; // Import providers
import '../../domain/match.dart' as domain; // Import custom Match with prefix
import '../widgets/match_list_item.dart'; // Import list item widget
import '../../../selection/presentation/selection_screen.dart'; // Import SelectionScreen for navigation
import '../../../favorites/domain/favorite.dart'; // Import Favorite model
import '../../../../shared/widgets/shared_loading_indicator.dart'; // Import shared loading
import '../../../../shared/widgets/shared_error_message.dart'; // Import shared error

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
        title: const Text('Matches'),
        centerTitle: true, // Center the title
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
          IconButton(
            icon: const Icon(Icons.edit_note), // Or Icons.settings, Icons.tune
            tooltip: 'Change League Selection',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        // Restore TabBarView
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
        // Watch the stream of Favorite objects
        final asyncFavorites = ref.watch(favoritesStreamProvider);
        final List<Favorite> favorites = asyncFavorites.asData?.value ?? [];
        // Extract just the IDs for efficient lookup
        final favoriteTeamIds = favorites.map((fav) => fav.teamId).toSet();

        final filteredMatches =
            _showOnlyFavorites
                ? matches.where((match) {
                  // Check if either team's ID is in the set of favorite IDs
                  return favoriteTeamIds.contains(match.homeTeam.id) ||
                      favoriteTeamIds.contains(match.awayTeam.id);
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
      // Use shared loading indicator
      loading: () => const SharedLoadingIndicator(),
      // Use shared error message widget with retry callback
      error:
          (error, stackTrace) => SharedErrorMessage(
            error: 'Failed to load matches: $error',
            onRetry:
                () =>
                    ref.refresh(provider), // Use the passed provider for retry
          ),
    );
  }
}

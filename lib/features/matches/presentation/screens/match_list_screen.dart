import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart'; // Import providers
import '../../../../app/theme/app_theme.dart'; // Import AppTheme
import '../../domain/match.dart' as domain; // Import custom Match with prefix
import '../widgets/match_list_item.dart'; // Import list item widget
import '../../../selection/presentation/selection_screen.dart'; // Import SelectionScreen for navigation
import '../../../favorites/domain/favorite.dart'; // Import Favorite model
import '../../../favorites/application/favorites_notifier.dart'; // Import for DragTarget

// import '../../../../shared/widgets/shared_loading_indicator.dart'; // No longer needed
import 'package:skeletonizer/skeletonizer.dart'; // Import skeletonizer
import '../../../../shared/widgets/shared_error_message.dart'; // Import shared error

// Placeholder for custom action buttons in the header
class _CustomActionButtonPlaceholder extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool? isSelected; // Optional for toggle buttons

  const _CustomActionButtonPlaceholder({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isSelected == true
            ? theme
                .primaryColor // Highlight if selected
            : theme.iconTheme.color ?? theme.primaryColor;

    return IconButton(
      icon: Icon(icon, color: color, size: 28), // Use theme color, larger size
      tooltip: tooltip,
      onPressed: onTap,
      // Add padding/constraints if needed for larger tap area
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    );
  }
}

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
    final theme = Theme.of(context); // Get theme

    return Scaffold(
      // Remove standard AppBar
      backgroundColor: theme.scaffoldBackgroundColor, // Apply theme background
      body: Container(
        // Add Container for gradient
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient, // Apply gradient
        ),
        child: SafeArea(
          // Original SafeArea is now child of Container
          // Ensure content doesn't overlap status bar/notches
          child: Column(
            // Use Column for custom header/tabs + TabBarView
            children: [
              // --- Custom Header Area ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Placeholder for Filter Button
                    _CustomActionButtonPlaceholder(
                      icon: Icons.filter_list_rounded,
                      tooltip: 'Filter Favorites',
                      isSelected: _showOnlyFavorites,
                      onTap: () {
                        setState(() {
                          _showOnlyFavorites = !_showOnlyFavorites;
                          // TODO: Add visual feedback/animation
                        });
                      },
                    ),
                    // Title Placeholder (can be more elaborate later)
                    Text(
                      'Matches',
                      style: theme.textTheme.headlineSmall, // Use theme
                    ),
                    // Placeholder for Edit League Button
                    _CustomActionButtonPlaceholder(
                      icon: Icons.edit_rounded,
                      tooltip: 'Change League',
                      onTap: () {
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
              ),

              // --- Custom TabBar Placeholder ---
              // TODO: Replace with custom glossy TabBar widget
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBar(
                  // Keep standard TabBar for now, style via theme
                  controller: _tabController,
                  tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Previous')],
                  // Theme styling is applied via tabBarTheme in AppTheme
                ),
              ),
              const Divider(height: 1, thickness: 1), // Optional separator
              // --- TabBarView (Expanded to fill remaining space) ---
              // --- TabBarView wrapped in DragTarget ---
              Expanded(
                child: DragTarget<Favorite>(
                  builder: (context, candidateData, rejectedData) {
                    // Provide visual feedback when dragging over
                    final isHovering = candidateData.isNotEmpty;
                    return Container(
                      color:
                          isHovering
                              ? theme.primaryColor.withOpacity(
                                0.1,
                              ) // Highlight when hovering
                              : null, // Default background
                      child: TabBarView(
                        // Original TabBarView
                        controller: _tabController,
                        children: [
                          _buildMatchList(upcomingMatchesProvider),
                          _buildMatchList(previousMatchesProvider),
                        ],
                      ),
                    );
                  },
                  onWillAcceptWithDetails: (details) {
                    // Can add logic here to decide if the target should accept the data
                    return true; // Accept any Favorite object for now
                  },
                  onAcceptWithDetails: (details) {
                    final favorite = details.data;
                    print(
                      'Accepted favorite: ${favorite.teamName} (${favorite.teamId})',
                    );
                    // Add the favorite using the notifier
                    final notifier = ref.read(
                      favoritesNotifierProvider.notifier,
                    );
                    notifier.addFavorite(favorite);
                    // Invalidate the provider for the specific team to update its star icon
                    ref.invalidate(isFavoriteProvider(favorite.teamId));
                    // Optional: Show a snackbar confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${favorite.teamName} added to favorites!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  // Optional: Add onLeave callback if needed
                ),
              ),
            ],
          ),
        ), // Close SafeArea
      ), // Close Container
    ); // Close Scaffold
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
      loading: () {
        // Create dummy match data for the skeleton layout
        final dummyMatch = domain.Match(
          id: 0, // Dummy ID
          utcDate: DateTime.now(),
          status: 'SCHEDULED',
          competitionRef: domain.CompetitionRef(id: 0, name: 'League Name'),
          homeTeam: domain.TeamRef(id: 1, name: 'Home Team Name'),
          awayTeam: domain.TeamRef(id: 2, name: 'Away Team Name'),
          score: domain.Score(
            // Provide dummy score structure
            winner: null,
            // duration: 'REGULAR', // Removed - not a parameter in Score constructor
            fullTime: domain.ScoreTime(homeScore: null, awayScore: null),
            halfTime: domain.ScoreTime(homeScore: null, awayScore: null),
          ),
        );

        // Return a Skeletonizer wrapping a list of dummy MatchListItems
        return Skeletonizer(
          // Optional: Customize effect (e.g., shimmer: true)
          // effect: ShimmerEffect(),
          child: ListView.builder(
            itemCount: 8, // Show several skeleton items
            itemBuilder: (context, index) {
              return MatchListItem(match: dummyMatch); // Use dummy data
            },
          ),
        );
      },
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

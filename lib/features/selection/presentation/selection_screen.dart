import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart'; // Import AppTheme
import '../../matches/domain/match.dart'
    show CompetitionRef; // Only import CompetitionRef
import '../domain/user_selection.dart';
import '../../matches/presentation/screens/match_list_screen.dart'; // For navigation
// import '../../../shared/widgets/shared_loading_indicator.dart'; // No longer needed
import 'package:skeletonizer/skeletonizer.dart'; // Import skeletonizer
import '../../../shared/widgets/shared_error_message.dart'; // Import shared error
import 'widgets/league_selector_card.dart'; // Import the new card widget

class SelectionScreen extends ConsumerStatefulWidget {
  const SelectionScreen({super.key});

  @override
  ConsumerState<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends ConsumerState<SelectionScreen>
    with SingleTickerProviderStateMixin {
  CompetitionRef? _selectedLeague;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Quick animation
      reverseDuration: const Duration(milliseconds: 100),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      // Scale down slightly
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncLeagues = ref.watch(availableLeaguesProvider);
    final selectionNotifier = ref.read(
      selectionRepositoryProvider,
    ); // For saving

    // Apply new background color from theme
    final theme = Theme.of(context);

    return Scaffold(
      // No standard AppBar - will use custom header in body
      backgroundColor:
          theme.scaffoldBackgroundColor, // Ensure background matches theme
      body: Container(
        // Add Container for gradient
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient, // Apply gradient
        ),
        child: Center(
          // Original Center widget is now child of Container
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: asyncLeagues.when(
              data: (leagues) {
                if (leagues.isEmpty) {
                  return const Text('No leagues available to select.');
                  // TODO: Add a retry button?
                }
                // Use ListView to allow scrolling if content overflows vertically
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ), // Add vertical padding
                  children: [
                    // Placeholder for Custom Header
                    Container(
                      height: 80, // Example height
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Choose Your League!',
                        style: theme.textTheme.headlineMedium, // Use theme
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Visual League Selector (Horizontal List)
                    SizedBox(
                      height:
                          150, // Adjust height as needed for card size + padding
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leagues.length,
                        itemBuilder: (context, index) {
                          final league = leagues[index];
                          final bool isSelected =
                              _selectedLeague?.id == league.id;
                          return Padding(
                            padding: EdgeInsets.only(
                              left:
                                  index == 0
                                      ? 20.0
                                      : 8.0, // Add padding left for first item
                              right:
                                  index == leagues.length - 1
                                      ? 20.0
                                      : 8.0, // Add padding right for last item
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: SizedBox(
                              // Constrain width of the card
                              width: 120, // Adjust width as needed
                              child: LeagueSelectorCard(
                                league: league,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedLeague = league;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Placeholder for Custom Save Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      child: GestureDetector(
                        onTapDown: (_) {
                          // Add onTapDown
                          if (_selectedLeague != null) {
                            _buttonAnimationController.forward();
                          }
                        },
                        onTapUp: (_) {
                          // Add onTapUp
                          if (_buttonAnimationController.isAnimating ||
                              _buttonAnimationController.value > 0) {
                            _buttonAnimationController.reverse();
                          }
                        },
                        onTapCancel: () {
                          // Add onTapCancel
                          if (_buttonAnimationController.isAnimating ||
                              _buttonAnimationController.value > 0) {
                            _buttonAnimationController.reverse();
                          }
                        },
                        onTap: // Keep existing onTap for the main action
                            _selectedLeague == null
                                ? null // Disable visually or prevent tap if needed
                                : () async {
                                  // --- SAVE LOGIC (unchanged) ---
                                  if (_selectedLeague != null) {
                                    final selection = UserSelection(
                                      selectedLeagueId:
                                          _selectedLeague!.id.toString(),
                                      selectedLeagueName: _selectedLeague!.name,
                                    );
                                    try {
                                      await selectionNotifier.saveSelection(
                                        selection,
                                      );
                                      ref.invalidate(userSelectionProvider);
                                      if (mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const MatchListScreen(),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error saving selection: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  // --- END SAVE LOGIC ---
                                },
                        child: ScaleTransition(
                          // Wrap button content in ScaleTransition
                          scale: _buttonScaleAnimation,
                          child: Opacity(
                            // Indicate disabled state visually
                            opacity: _selectedLeague == null ? 0.5 : 1.0,
                            child: Container(
                              height: 60, // Large button height
                              decoration: BoxDecoration(
                                color: theme.primaryColor, // Use theme color
                                borderRadius: BorderRadius.circular(
                                  30,
                                ), // Very rounded
                                // TODO: Add gradient/glossy effect later
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Save & Continue',
                                style:
                                    theme
                                        .textTheme
                                        .labelLarge, // Use theme style
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              // Use shared loading indicator
              loading: () {
                // Build a dummy structure resembling the screen content
                final dummyContent = ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  children: [
                    // Header Placeholder
                    Container(
                      height: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Choose Your League!',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    // League Selector Placeholder (Simulate horizontal list area)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        // Use ListView to get structure
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Show a few skeleton cards
                        itemBuilder:
                            (context, index) => Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 20.0 : 8.0,
                                right: 8.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: SizedBox(
                                width: 120,
                                // Use a simple Card or Container as the base for skeleton
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shield,
                                          size: 40,
                                        ), // Icon placeholder
                                        SizedBox(height: 8),
                                        Text(
                                          'League Name',
                                          style: theme.textTheme.bodyMedium,
                                        ), // Text placeholder
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Save Button Placeholder
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Save & Continue',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                );

                // Wrap the dummy content structure with Skeletonizer
                return Skeletonizer(
                  // effect: ShimmerEffect(), // Optional: Customize effect
                  child: dummyContent,
                );
              },
              // Use shared error message widget with retry callback
              error:
                  (error, stack) => SharedErrorMessage(
                    error: 'Failed to load available leagues: $error',
                    onRetry: () => ref.refresh(availableLeaguesProvider),
                  ),
            ),
          ),
        ), // Close Center
      ), // Close Container
    ); // Close Scaffold
  }
}

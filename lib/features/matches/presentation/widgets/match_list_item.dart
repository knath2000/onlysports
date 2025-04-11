import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:intl/intl.dart';
import 'dart:ui'; // Import for ImageFilter
import '../../domain/match.dart' as domain;
import '../../../../app/providers.dart'; // Import global providers
import '../../../favorites/application/favorites_notifier.dart'; // Import favorites notifier
import '../../../favorites/domain/favorite.dart'; // Import Favorite model
// import '../screens/match_detail_screen.dart'; // No longer needed
import 'match_detail_modal.dart'; // Import the new modal widget

// Widget for displaying a single match in a list
// Change to ConsumerWidget to access providers
class MatchListItem extends ConsumerStatefulWidget {
  // Change to StatefulWidget
  final domain.Match match;

  const MatchListItem({super.key, required this.match});

  @override
  ConsumerState<MatchListItem> createState() => _MatchListItemState(); // Create state
}

// Create the State class
class _MatchListItemState extends ConsumerState<MatchListItem>
    with SingleTickerProviderStateMixin {
  // Add mixin
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Faster tap feedback
      reverseDuration: const Duration(milliseconds: 50),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      // Subtle scale
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep WidgetRef access via 'ref'
    final domain.Match match = widget.match; // Access match via widget
    // Basic date and time formatting
    final localDate = match.utcDate.toLocal();
    final timeFormat = DateFormat.jm(); // e.g., 5:08 PM
    final dateFormat = DateFormat.yMMMd(); // e.g., Apr 11, 2025

    // Determine score display based on status
    String scoreOrTime;
    if (match.status == 'FINISHED') {
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}';
    } else if (match.status == 'SCHEDULED' || match.status == 'TIMED') {
      scoreOrTime = timeFormat.format(localDate);
    } else {
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'} (${match.status})';
    }

    final theme = Theme.of(context); // Get theme data

    // TODO: Integrate Rive animations for interactions/status changes

    // --- Rewritten Widget Tree ---
    // Data to be passed when dragged (Home team favorite info)
    final favoriteData = Favorite(
      teamId: match.homeTeam.id,
      teamName: match.homeTeam.name,
    );

    // The widget that is shown while dragging
    final feedbackWidget = Material(
      // Need Material for theme styles during drag
      elevation: 4.0,
      child: ConstrainedBox(
        // Limit size during drag
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ), // Example constraint
        child: Opacity(
          opacity: 0.7,
          child: _buildCardContent(
            context,
            theme,
            match,
            localDate,
            dateFormat,
            timeFormat,
            ref,
          ),
        ), // Reuse card content logic
      ),
    );

    // The widget left behind in the list
    final childWhenDraggingWidget = Opacity(
      opacity: 0.4,
      child: Card(
        child: _buildCardContent(
          context,
          theme,
          match,
          localDate,
          dateFormat,
          timeFormat,
          ref,
        ),
      ), // Show faded item
    );

    return Draggable<Favorite>(
      // Wrap with Draggable
      data: favoriteData,
      feedback: feedbackWidget,
      childWhenDragging: childWhenDraggingWidget,
      child: ScaleTransition(
        // Original ScaleTransition is the child
        scale: _scaleAnimation,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () {
              // Show the modal dialog using showGeneralDialog for blur effect
              showGeneralDialog(
                context: context,
                barrierDismissible: true, // Allow dismissing by tapping outside
                barrierLabel:
                    MaterialLocalizations.of(
                      context,
                    ).modalBarrierDismissLabel, // Accessibility
                barrierColor: Colors.black.withOpacity(
                  0.3,
                ), // Dimmed background
                transitionDuration: const Duration(
                  milliseconds: 200,
                ), // Animation duration
                pageBuilder: (
                  BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  // This builds the primary content of the dialog
                  return MatchDetailModal(matchId: match.id.toString());
                },
                transitionBuilder: (
                  BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  // Restore BackdropFilter and wrap FadeTransition
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ), // Apply blur
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                      child:
                          child, // The child is the MatchDetailModal built by pageBuilder
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  // --- Left Column: Team Logos ---
                  Column(
                    children: [
                      _TeamLogoPlaceholder(teamColor: theme.primaryColor),
                      const SizedBox(height: 8),
                      _TeamLogoPlaceholder(
                        teamColor: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // --- Center Column: Match Info ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${match.homeTeam.name} vs ${match.awayTeam.name}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.competitionRef.name,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(localDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // --- Right Column: Score/Time & Favorite ---
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        scoreOrTime,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          final teamId = match.homeTeam.id;
                          final asyncIsFav = ref.watch(
                            isFavoriteProvider(teamId),
                          );
                          final isFav = asyncIsFav.maybeWhen(
                            data: (isFavoriteResult) => isFavoriteResult,
                            orElse: () => false,
                          );
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isFav
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color:
                                  isFav
                                      ? theme.colorScheme.secondary
                                      : theme.iconTheme.color,
                              size: 28,
                            ),
                            onPressed: () {
                              final notifier = ref.read(
                                favoritesNotifierProvider.notifier,
                              );
                              final teamIdInt = match.homeTeam.id;
                              final teamName = match.homeTeam.name;
                              if (isFav) {
                                notifier.removeFavorite(teamIdInt);
                              } else {
                                final favoriteToAdd = Favorite(
                                  teamId: teamIdInt,
                                  teamName: teamName,
                                );
                                notifier.addFavorite(favoriteToAdd);
                              }
                              ref.invalidate(isFavoriteProvider(teamIdInt));
                            },
                          );
                        },
                      ), // End Consumer
                    ],
                  ), // End Right Column
                ],
              ), // End Row
            ), // End Padding
          ), // End InkWell
        ), // End Card
      ), // End ScaleTransition
    ); // End Draggable
  }

  // Helper method to build the card content, reused for feedback/childWhenDragging
  Widget _buildCardContent(
    BuildContext context,
    ThemeData theme,
    domain.Match match,
    DateTime localDate,
    DateFormat dateFormat,
    DateFormat timeFormat,
    WidgetRef ref,
  ) {
    // Determine score display based on status (copied from original build)
    String scoreOrTime;
    if (match.status == 'FINISHED') {
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}';
    } else if (match.status == 'SCHEDULED' || match.status == 'TIMED') {
      scoreOrTime = timeFormat.format(localDate);
    } else {
      scoreOrTime =
          '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'} (${match.status})';
    }

    return InkWell(
      // Note: InkWell interaction might be slightly different in feedback/childWhenDragging
      // Keep onTap logic simple or disable for feedback if needed
      onTap: () {
        // Show the modal dialog (same as in main build method)
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return MatchDetailModal(matchId: match.id.toString());
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Row(
          children: [
            // --- Left Column: Team Logos ---
            Column(
              children: [
                _TeamLogoPlaceholder(teamColor: theme.primaryColor),
                const SizedBox(height: 8),
                _TeamLogoPlaceholder(teamColor: theme.colorScheme.secondary),
              ],
            ),
            const SizedBox(width: 12),

            // --- Center Column: Match Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${match.homeTeam.name} vs ${match.awayTeam.name}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    match.competitionRef.name,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(localDate),
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // --- Right Column: Score/Time & Favorite ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  scoreOrTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Consumer(
                  // Keep Consumer for favorite button state
                  builder: (context, ref, child) {
                    final teamId = match.homeTeam.id;
                    final asyncIsFav = ref.watch(isFavoriteProvider(teamId));
                    final isFav = asyncIsFav.maybeWhen(
                      data: (isFavoriteResult) => isFavoriteResult,
                      orElse: () => false,
                    );
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isFav ? Icons.star_rounded : Icons.star_border_rounded,
                        color:
                            isFav
                                ? theme.colorScheme.secondary
                                : theme.iconTheme.color,
                        size: 28,
                      ),
                      onPressed: () {
                        // Keep favorite toggle logic
                        final notifier = ref.read(
                          favoritesNotifierProvider.notifier,
                        );
                        final teamIdInt = match.homeTeam.id;
                        final teamName = match.homeTeam.name;
                        if (isFav) {
                          notifier.removeFavorite(teamIdInt);
                        } else {
                          final favoriteToAdd = Favorite(
                            teamId: teamIdInt,
                            teamName: teamName,
                          );
                          notifier.addFavorite(favoriteToAdd);
                        }
                        ref.invalidate(isFavoriteProvider(teamIdInt));
                      },
                    );
                  },
                ), // End Consumer
              ],
            ), // End Right Column
          ],
        ), // End Row
      ), // End Padding
    ); // End InkWell
  }
}

// Helper widget for team logo placeholder
class _TeamLogoPlaceholder extends StatelessWidget {
  final Color teamColor;
  const _TeamLogoPlaceholder({required this.teamColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, // Adjust size as needed
      height: 36,
      decoration: BoxDecoration(
        color: teamColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: teamColor, width: 1.5),
      ),
      child: Icon(
        Icons.shield, // Placeholder icon
        color: teamColor,
        size: 20,
      ),
    );
  }
}

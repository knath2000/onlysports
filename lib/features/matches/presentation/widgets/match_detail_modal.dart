import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/providers.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage
import '../../../../app/theme/app_theme.dart'; // Import theme for gradient
// import '../../../../shared/widgets/shared_loading_indicator.dart'; // No longer needed
import 'package:skeletonizer/skeletonizer.dart'; // Import skeletonizer
import '../../../../shared/widgets/shared_error_message.dart';
import '../../domain/match.dart' as domain; // Use prefix

// Modal widget to display match details
class MatchDetailModal extends ConsumerStatefulWidget {
  final String matchId;

  const MatchDetailModal({super.key, required this.matchId});

  @override
  ConsumerState<MatchDetailModal> createState() => _MatchDetailModalState();
}

class _MatchDetailModalState extends ConsumerState<MatchDetailModal> {
  @override
  Widget build(BuildContext context) {
    final matchDetailsAsync = ref.watch(
      liveMatchStreamProvider(widget.matchId),
    );
    final theme = Theme.of(context);

    // Use a Dialog for the modal popup
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent, // Make dialog background transparent
      child: Container(
        // Apply gradient to the container inside the dialog
        decoration: BoxDecoration(
          // Use a LinearGradient with the same colors as the main background
          gradient: const LinearGradient(
            colors: [
              Color(0xFF8B008B), // Dark Magenta (Dark Pink)
              Color(0xFF8A2BE2), // Blue Violet
              Colors.black, // Black
            ],
            begin: Alignment.topCenter, // Example: Gradient from top to bottom
            end: Alignment.bottomCenter,
            // stops: [0.0, 0.5, 1.0], // Can use same stops if needed
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          // Limit the height of the dialog content
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: matchDetailsAsync.when(
            data: (match) {
              if (match == null) {
                return _buildContent(
                  context,
                  theme,
                  const Center(child: Text('Match details not found.')),
                );
              }

              // Formatting
              final localDate = match.utcDate.toLocal();
              final timeFormat = DateFormat.jm();
              final dateFormat = DateFormat.yMMMd();

              // Build the details view within the modal
              return _buildContent(
                context,
                theme,
                ListView(
                  // Use ListView for scrollable content
                  shrinkWrap: true, // Make ListView take minimum height
                  children: [
                    // Header (Teams)
                    // --- Add Crests Row ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          // Constrain size
                          width: 50,
                          height: 50,
                          child:
                              (match.homeTeam.crest != null &&
                                      match.homeTeam.crest!.isNotEmpty)
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        '/api/crestProxy?url=${Uri.encodeComponent(match.homeTeam.crest!)}',
                                    placeholder:
                                        (context, url) =>
                                            _ModalTeamLogoPlaceholder(
                                              teamColor: theme.primaryColor,
                                            ),
                                    errorWidget:
                                        (context, url, error) =>
                                            _ModalTeamLogoPlaceholder(
                                              teamColor: theme.primaryColor,
                                            ),
                                    fit: BoxFit.contain,
                                  )
                                  : _ModalTeamLogoPlaceholder(
                                    // Show placeholder directly
                                    teamColor: theme.primaryColor,
                                  ),
                        ),
                        SizedBox(
                          // Constrain size
                          width: 50,
                          height: 50,
                          child:
                              (match.awayTeam.crest != null &&
                                      match.awayTeam.crest!.isNotEmpty)
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        '/api/crestProxy?url=${Uri.encodeComponent(match.awayTeam.crest!.trim())}',
                                    placeholder:
                                        (context, url) =>
                                            _ModalTeamLogoPlaceholder(
                                              teamColor:
                                                  theme.colorScheme.secondary,
                                            ),
                                    errorWidget: (context, url, error) {
                                      print(
                                        "Error loading image via proxy: $url, Error: $error",
                                      );
                                      return _ModalTeamLogoPlaceholder(
                                        teamColor: theme.colorScheme.secondary,
                                      );
                                    },
                                    fit: BoxFit.contain,
                                  )
                                  : _ModalTeamLogoPlaceholder(
                                    // Show placeholder directly
                                    teamColor: theme.colorScheme.secondary,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ), // Spacing between crests and names
                    Text(
                      '${match.homeTeam.name} vs ${match.awayTeam.name}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Competition
                    Text(
                      match.competitionRef.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Date & Time
                    _buildDetailRow(
                      theme,
                      icon: Icons.calendar_today_rounded,
                      text:
                          '${dateFormat.format(localDate)} at ${timeFormat.format(localDate)}',
                    ),
                    const SizedBox(height: 8),

                    // Status
                    _buildDetailRow(
                      theme,
                      icon: Icons.info_outline_rounded,
                      text: 'Status: ${match.status}',
                    ),
                    const SizedBox(height: 8),

                    // Venue
                    if (match.venue != null) ...[
                      _buildDetailRow(
                        theme,
                        icon: Icons.location_on_outlined,
                        text: 'Venue: ${match.venue}',
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Score (if finished)
                    if (match.status == 'FINISHED') ...[
                      const Divider(color: Colors.white30, height: 24),
                      Text(
                        'Full Time Result',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${match.score.fullTime.homeScore ?? '-'} : ${match.score.fullTime.awayScore ?? '-'}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ), // Use accent color
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '(Half Time: ${match.score.halfTime.homeScore ?? '-'} : ${match.score.halfTime.awayScore ?? '-'})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    // TODO: Add other details if needed
                  ],
                ),
              );
            },
            loading: () {
              // Build a dummy structure resembling the modal content for Skeletonizer
              // Build a dummy structure resembling the actual modal content layout
              final dummyContent = ListView(
                shrinkWrap: true,
                children: [
                  // Header (Teams) - Centered
                  Text(
                    'Home Team Name vs Away Team Name', // Use placeholder text
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.transparent,
                    ), // Keep style for size, hide text color
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Competition - Centered
                  Text(
                    'Competition Name', // Use placeholder text
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.transparent,
                    ), // Keep style for size, hide text color
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Detail Rows - Left aligned (match _buildDetailRow structure)
                  _buildDetailRow(
                    theme,
                    icon: Icons.calendar_today_rounded,
                    text: 'Date at Time', // Use placeholder text
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    theme,
                    icon: Icons.info_outline_rounded,
                    text: 'Status: STATUS', // Use placeholder text
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    // Assume venue might exist
                    theme,
                    icon: Icons.location_on_outlined,
                    text: 'Venue: Venue Name', // Use placeholder text
                  ),
                  const SizedBox(height: 8),

                  // Score (if finished) - Centered (Assume it might be finished)
                  const Divider(color: Colors.white30, height: 24),
                  Text(
                    'Full Time Result',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.transparent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'H : A', // Use placeholder text
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.transparent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '(Half Time: H : A)', // Use placeholder text
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.transparent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              );

              // Wrap the dummy content structure with Skeletonizer inside _buildContent
              return _buildContent(
                context,
                theme,
                Skeletonizer(
                  // effect: ShimmerEffect(), // Optional: Customize effect
                  child: dummyContent,
                ),
              );
            },
            error:
                (error, stack) => _buildContent(
                  context,
                  theme,
                  SharedErrorMessage(
                    error: 'Failed to load details: $error',
                    onRetry:
                        () => ref.refresh(
                          liveMatchStreamProvider(widget.matchId),
                        ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  // Helper to build consistent content structure with close button
  Widget _buildContent(BuildContext context, ThemeData theme, Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Take minimum vertical space
      children: [
        Expanded(child: child), // Make the main content scrollable if needed
        const SizedBox(height: 16),
        TextButton(
          child: Text(
            'Close',
            style: TextStyle(color: theme.colorScheme.secondary),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  // Helper for detail rows
  Widget _buildDetailRow(
    ThemeData theme, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Helper widget for team logo placeholder within the modal
class _ModalTeamLogoPlaceholder extends StatelessWidget {
  final Color teamColor;
  const _ModalTeamLogoPlaceholder({required this.teamColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Match SizedBox size
      height: 50,
      decoration: BoxDecoration(
        color: teamColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: teamColor, width: 1.5),
      ),
      child: Icon(
        Icons.shield, // Placeholder icon
        color: teamColor,
        size: 28, // Adjust icon size within placeholder
      ),
    );
  }
}

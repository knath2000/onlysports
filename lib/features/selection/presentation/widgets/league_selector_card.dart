import 'package:flutter/material.dart';
import '../../../matches/domain/match.dart' show CompetitionRef;

class LeagueSelectorCard extends StatelessWidget {
  final CompetitionRef league;
  final bool isSelected;
  final VoidCallback onTap;

  const LeagueSelectorCard({
    super.key,
    required this.league,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor =
        isSelected
            ? theme.primaryColor.withOpacity(0.15) // Highlight selected
            : theme.cardTheme.color ??
                theme.colorScheme.surface; // Use card theme color
    final borderColor =
        isSelected
            ? theme.primaryColor
            : theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder)
                .side
                .color // Use card border color if defined
            : Colors.transparent; // Default to no border

    return GestureDetector(
      onTap: onTap,
      child: Card(
        // Use CardTheme defaults where possible
        elevation: isSelected ? 4.0 : (theme.cardTheme.elevation ?? 2.0),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Consistent rounding
          side: BorderSide(color: borderColor, width: isSelected ? 2.0 : 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for League Icon/Logo
              Icon(
                Icons.shield, // Placeholder icon
                size: 40,
                color:
                    isSelected
                        ? theme.primaryColor
                        : theme.colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                league.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected
                          ? theme.primaryColor
                          : theme.textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

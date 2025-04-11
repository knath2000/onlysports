import 'package:flutter/material.dart';

// Simple skeleton loader mimicking the MatchListItem structure
class MatchListItemSkeleton extends StatelessWidget {
  const MatchListItemSkeleton({super.key});

  // Helper to create a shimmering placeholder box
  Widget _buildPlaceholder({double? width, double height = 16.0}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade800, // Use a dark skeleton color
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add shimmer effect package later for better visuals
    return ListTile(
      // Simulate the layout of MatchListItem
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceholder(width: 60, height: 12), // Date placeholder
          const SizedBox(height: 4),
          _buildPlaceholder(width: 40, height: 18), // Score/Time placeholder
        ],
      ),
      title: _buildPlaceholder(height: 18), // Team names placeholder
      subtitle: _buildPlaceholder(
        width: 100,
        height: 14,
      ), // Competition placeholder
      trailing: _buildPlaceholder(width: 24, height: 24), // Icon placeholder
    );
  }
}

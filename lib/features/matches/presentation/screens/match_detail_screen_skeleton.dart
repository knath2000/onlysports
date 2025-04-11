import 'package:flutter/material.dart';

// Simple skeleton loader mimicking the MatchDetailScreen structure
class MatchDetailScreenSkeleton extends StatelessWidget {
  const MatchDetailScreenSkeleton({super.key});

  // Helper to create a shimmering placeholder box
  Widget _buildPlaceholder({
    double? width,
    double height = 16.0,
    double marginBottom = 8.0,
  }) {
    return Container(
      width: width ?? double.infinity, // Default to full width
      height: height,
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        color: Colors.grey.shade800, // Use a dark skeleton color
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add shimmer effect package later for better visuals
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceholder(height: 28, width: 250), // Title placeholder
          const SizedBox(height: 8),
          _buildPlaceholder(height: 16, width: 150), // Competition placeholder
          const SizedBox(height: 8),
          _buildPlaceholder(height: 16, width: 200), // Date/Time placeholder
          const SizedBox(height: 8),
          _buildPlaceholder(height: 16, width: 100), // Status placeholder
          const SizedBox(height: 8),
          _buildPlaceholder(height: 16, width: 180), // Venue placeholder
          const SizedBox(height: 16),
          _buildPlaceholder(height: 24, width: 120), // Score placeholder
          const SizedBox(height: 4),
          _buildPlaceholder(
            height: 14,
            width: 100,
          ), // Half-time score placeholder
          // Add placeholders for other details if needed
        ],
      ),
    );
  }
}

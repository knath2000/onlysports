import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Placeholder - add dependency later
import 'theme/app_theme.dart';
import '../features/matches/presentation/screens/match_list_screen.dart'; // Import the screen

// Placeholder for the main application widget
// This will likely be a ConsumerWidget or StatelessWidget that sets up MaterialApp
// and potentially routing.

class MyApp extends ConsumerWidget {
  // Example using Riverpod
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement MaterialApp setup
    // TODO: Define routes
    // TODO: Apply theme from AppTheme
    return MaterialApp(
      title: 'Dynamic Sports Match Tracker',
      theme: AppTheme.lightTheme, // Placeholder
      darkTheme: AppTheme.darkTheme, // Use the dark theme
      themeMode: ThemeMode.dark, // Enforce dark mode initially
      home: const MatchListScreen(), // Set MatchListScreen as home
    );
  }
}

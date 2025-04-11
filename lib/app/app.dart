import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Placeholder - add dependency later
import 'theme/app_theme.dart';
import 'initial_route_dispatcher.dart'; // Import the new initial router

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
      theme: AppTheme().gradientTheme, // Use the new gradient theme
      // darkTheme: AppTheme.darkTheme, // Keep the old dark theme stub if needed for reference
      themeMode:
          ThemeMode.dark, // Use dark mode to ensure gradientTheme is selected
      home:
          const InitialRouteDispatcher(), // Use the dispatcher to decide initial screen
    );
  }
}

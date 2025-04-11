import 'package:flutter/material.dart';

// Application Theme Configuration
class AppTheme {
  static ThemeData get darkTheme {
    const Color darkBackground = Color(0xFF121212); // Standard dark background
    const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter surface
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Colors.white70;
    // Accent color for animations/interactions (placeholder - define vibrant colors later)
    const Color accentColor = Colors.tealAccent;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      // Use accentColor for primary interaction elements if needed, but sparingly for static UI
      primaryColor: accentColor,

      colorScheme: const ColorScheme.dark(
        primary: accentColor, // Used for primary interactive elements
        secondary:
            accentColor, // Used for secondary interactive elements (e.g., FAB)
        background: darkBackground, // Background of scaffolds
        surface: darkSurface, // Background of cards, dialogs, etc.
        onPrimary: Colors.black, // Text/icon color on primary color
        onSecondary: Colors.black, // Text/icon color on secondary color
        onBackground: primaryTextColor, // Text/icon color on background
        onSurface: primaryTextColor, // Text/icon color on surface
        error: Colors.redAccent,
        onError: Colors.black,
      ),

      // Define basic Text Theme
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
        // Titles
        titleLarge: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.w600,
        ), // Semi-bold
        titleMedium: TextStyle(color: primaryTextColor),
        titleSmall: TextStyle(color: secondaryTextColor),
        // Body text
        bodyLarge: TextStyle(color: primaryTextColor),
        bodyMedium: TextStyle(color: primaryTextColor),
        bodySmall: TextStyle(color: secondaryTextColor),
        // Labels (e.g., for buttons)
        labelLarge: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(color: primaryTextColor),
        labelSmall: TextStyle(color: secondaryTextColor),
      ).apply(
        // Apply default font family if needed (e.g., SF Pro via platform checks or custom font)
        // fontFamily: 'YourFontFamily',
      ),

      // Define AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface, // Use surface color for AppBar
        elevation: 0, // Clean look
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20, // Example size
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ), // Ensure icons are visible
      ),

      // Define TabBar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: primaryTextColor, // Color of selected tab text
        unselectedLabelColor:
            secondaryTextColor, // Color of unselected tab text
        indicatorColor: accentColor, // Color of the indicator line
        // Use indicatorSize: TabBarIndicatorSize.label for smaller indicator
      ),

      // Define ListTile Theme (Example)
      listTileTheme: const ListTileThemeData(
        iconColor: secondaryTextColor,
        // Customize further as needed
      ),

      // Define Button Themes (Example for ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor, // Use accent for primary buttons
          foregroundColor: Colors.black, // Text color on button
        ),
      ),

      // Define Chip Theme (Example for FilterChip)
      chipTheme: ChipThemeData(
        backgroundColor: darkSurface,
        disabledColor: Colors.grey.shade800,
        selectedColor: accentColor.withOpacity(
          0.3,
        ), // Subtle selection indication
        secondarySelectedColor: accentColor,
        labelStyle: const TextStyle(color: secondaryTextColor),
        secondaryLabelStyle: const TextStyle(color: primaryTextColor),
        shape: const StadiumBorder(), // Rounded chip
        iconTheme: const IconThemeData(color: secondaryTextColor, size: 18),
        checkmarkColor: primaryTextColor,
      ),

      // TODO: Define other component themes (Card, Dialog, etc.)
      // TODO: Define custom component themes for unique widgets
    );
  }

  // Placeholder for light theme if ever needed
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      // Define light theme specifics if required later
    );
  }
}

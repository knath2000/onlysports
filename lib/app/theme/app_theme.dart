import 'package:flutter/material.dart';

// Application Theme Configuration - Child-Focused Redesign
class AppTheme {
  // --- New Bright Color Palette ---
  static const Color lightBackground = Color(
    0xFFF0F8FF,
  ); // AliceBlue - Light &amp; Airy
  static const Color lightSurface = Colors.white; // Cards, Dialogs background
  static const Color primaryColor = Color(
    0xFF00AEEF,
  ); // Bright Sky Blue - Primary Actions
  static const Color accentColor = Color(
    0xFFFFD700,
  ); // Sunny Yellow/Gold - Secondary Actions, Highlights
  static const Color primaryTextColor = Color(
    0xFF333333,
  ); // Dark Grey - Readable Text
  static const Color secondaryTextColor = Color(
    0xFF666666,
  ); // Medium Grey - Subtle Text
  static const Color errorColor = Color(0xFFE53935); // Standard Red for errors

  // --- Gradient Definition ---
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.bottomRight, // Change center to bottom right
    radius:
        0.8, // Adjust radius as needed (0.5 is default, larger spreads it more)
    colors: [
      Color(0xFF8B008B), // Dark Magenta (Dark Pink)
      Color(0xFF8A2BE2), // Blue Violet
      Colors.black, // Black
    ],
    stops: [
      0.0, // Start with pink at the center
      0.5, // Transition to violet halfway
      1.0, // End with black at the edges
    ],
  );

  // --- Font Settings (Font family applied later in Phase 1, Step 2) ---
  // TODO: Define specific font family name once integrated
  // static const String primaryFontFamily = 'YourRoundedFont';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryColor,

      colorScheme: const ColorScheme.light(
        primary: primaryColor, // Primary interactive elements
        secondary: accentColor, // Secondary interactive elements
        surface: lightSurface, // Overall background
        error: errorColor,
        onPrimary: Colors.white, // Text/icon on primary color
        onSecondary: primaryTextColor, // Text/icon on secondary color
        onSurface: primaryTextColor, // Text/icon on background
        onError: Colors.white, // Text/icon on error color
      ),

      // --- Text Theme (Larger, Simpler) ---
      textTheme: const TextTheme(
        // Headlines (Adjust sizes as needed for target font)
        headlineLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 34, // Larger
          fontWeight: FontWeight.w600, // Slightly bolder for clarity
        ),
        headlineMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 28, // Larger
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: primaryTextColor,
          fontSize: 24, // Larger
          fontWeight: FontWeight.w600,
        ),
        // Titles
        titleLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 22, // Larger
          fontWeight: FontWeight.w500, // Medium weight
        ),
        titleMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 18, // Larger
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 16, // Larger
          fontWeight: FontWeight.w400, // Regular weight
        ),
        // Body text
        bodyLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 18, // Larger
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 16, // Larger
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        // Labels (e.g., for buttons)
        labelLarge: TextStyle(
          color: Colors.white, // Assuming labels on colored buttons
          fontSize: 18, // Larger &amp; Tappable
          fontWeight: FontWeight.w600, // Bold for button clarity
        ),
        labelMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ).apply(fontFamily: 'Nunito'), // Apply Nunito font family globally
      // --- Component Themes ---

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface, // Clean white AppBar
        foregroundColor: primaryTextColor, // Icons and Title text color
        elevation: 1.0, // Subtle shadow
        centerTitle: true, // Center title for simpler look
        titleTextStyle: TextStyle(
          // fontFamily: primaryFontFamily, // Apply font later
          color: primaryTextColor,
          fontSize: 22, // Larger title
          fontWeight: FontWeight.w600, // Bold title
        ),
        iconTheme: IconThemeData(
          color: primaryColor, // Use primary color for AppBar icons
          size: 28, // Larger icons
        ),
      ),

      // TabBar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor, // Selected tab text color
        unselectedLabelColor: secondaryTextColor, // Unselected tab text color
        indicatorColor: primaryColor, // Indicator line color
        indicatorSize: TabBarIndicatorSize.tab, // Full width indicator
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ), // Larger tab labels
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        // TODO: Consider custom glossy indicator later
      ),

      // ListTile Theme (Will be replaced by custom widget, but set defaults)
      listTileTheme: const ListTileThemeData(
        iconColor: primaryColor, // Use primary color for icons
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: primaryTextColor,
        ), // Larger text
        subtitleTextStyle: TextStyle(fontSize: 14, color: secondaryTextColor),
        dense: false, // Ensure generous spacing
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 12.0,
        ), // More padding
      ),

      // Button Themes (Large, Rounded, Glossy - Placeholder for Glossy)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Use primary color
          foregroundColor: Colors.white, // Text color on button
          minimumSize: const Size(64, 52), // Larger height for tappability
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26), // Very rounded corners
          ),
          textStyle: const TextStyle(
            // fontFamily: primaryFontFamily, // Apply font later
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          // TODO: Add gradient/glossy effect later
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // Text color
          textStyle: const TextStyle(
            // fontFamily: primaryFontFamily, // Apply font later
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // TODO: Define OutlinedButtonTheme if needed

      // Chip Theme (Rounded, Clear Selection)
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        disabledColor: Colors.grey.shade300,
        selectedColor: primaryColor.withOpacity(0.2), // Light primary selection
        secondarySelectedColor: primaryColor, // Checkmark color?
        labelStyle: const TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: primaryTextColor,
        ), // Style when selected?
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded chip
          side: BorderSide(
            color: Colors.grey.shade400,
          ), // Add border for definition
        ),
        iconTheme: const IconThemeData(color: secondaryTextColor, size: 18),
        checkmarkColor: primaryColor, // Checkmark on selected chip
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Card Theme (Rounded)
      cardTheme: CardTheme(
        elevation: 2.0,
        color: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded cards
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),

      // Input Decoration Theme (Rounded Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), // Rounded input fields
          borderSide: BorderSide.none, // No border by default
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2.0,
          ), // Highlight focus
        ),
        labelStyle: const TextStyle(color: secondaryTextColor, fontSize: 16),
        hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 16),
      ),

      // TODO: Define DialogTheme (Rounded)
      // TODO: Define BottomSheetTheme (Rounded)
      // TODO: Define custom component themes for unique widgets (e.g., glossy buttons, score cards)
    );
  }

  // Keep dark theme stub in case needed for testing/comparison later
  static ThemeData get darkTheme {
    // This is the OLD theme, kept for reference/potential toggle
    const Color darkBackground = Color(0xFF121212);
    const Color darkSurface = Color(0xFF1E1E1E);
    const Color primaryTextColor = Colors.white;
    const Color secondaryTextColor = Colors.white70;
    const Color accentColor = Colors.tealAccent; // Old accent

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: accentColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: darkSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: primaryTextColor,
        error: Colors.redAccent,
        onError: Colors.black,
      ),
      // Keep other old theme definitions if needed for reference...
    );
  }

  // --- New Theme for Gradient Background ---
  ThemeData get gradientTheme {
    // Define colors suitable for the dark gradient background
    const Color gradPrimaryTextColor = Colors.white;
    const Color gradSecondaryTextColor = Colors.white70;
    const Color gradSurfaceColor = Color(
      0x44FFFFFF,
    ); // Semi-transparent white for cards/surfaces
    const Color gradPrimaryColor = Color(
      0xFF00AEEF,
    ); // Keep bright blue from light theme
    const Color gradAccentColor = Color(
      0xFFFFD700,
    ); // Keep bright yellow from light theme
    const Color gradErrorColor = Color(
      0xFFFF5252,
    ); // Bright red for errors on dark background

    return ThemeData(
      brightness: Brightness.dark, // Base brightness
      scaffoldBackgroundColor:
          Colors.transparent, // IMPORTANT: Scaffold needs to be transparent
      primaryColor: gradPrimaryColor,

      colorScheme: const ColorScheme.dark(
        primary: gradPrimaryColor,
        secondary: gradAccentColor,
        surface: gradSurfaceColor, // Underlying background color (though gradient covers it)
        error: gradErrorColor,
        onPrimary: Colors.black, // Text on primary buttons (blue)
        onSecondary: Colors.black, // Text on accent elements (yellow)
        onSurface: gradPrimaryTextColor, // Text directly on background (less common)
        onError: Colors.black, // Text on error color
      ),

      // --- Text Theme (Using Nunito, bright colors) ---
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 34,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: gradSecondaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: gradSecondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ), // Text on buttons
        labelMedium: TextStyle(
          color: gradPrimaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: gradSecondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ).apply(fontFamily: 'Nunito'),

      // --- Component Themes (Adapted for dark gradient) ---
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent AppBar
        foregroundColor: gradPrimaryTextColor, // White icons/title
        elevation: 0, // No shadow
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          color: gradPrimaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: gradPrimaryTextColor, size: 28),
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: gradAccentColor, // Use accent for selected tab
        unselectedLabelColor: gradSecondaryTextColor,
        indicatorColor: gradAccentColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: gradAccentColor,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 18,
          color: gradPrimaryTextColor,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: gradSecondaryTextColor,
        ),
        dense: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gradPrimaryColor, // Blue button
          foregroundColor: Colors.black, // Black text on blue button
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: gradAccentColor, // Yellow text for text buttons
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: gradSurfaceColor, // Semi-transparent surface
        disabledColor: Colors.grey.shade800,
        selectedColor: gradAccentColor.withOpacity(0.7), // Yellow selection
        secondarySelectedColor: gradAccentColor,
        labelStyle: const TextStyle(
          fontFamily: 'Nunito',
          color: gradPrimaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Nunito',
          color: Colors.black,
        ), // Text on selected chip
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade700,
          ), // Slightly visible border
        ),
        iconTheme: const IconThemeData(color: gradSecondaryTextColor, size: 18),
        checkmarkColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      cardTheme: CardTheme(
        elevation: 4.0, // Slightly more elevation for contrast
        color: gradSurfaceColor, // Semi-transparent surface
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gradSurfaceColor.withOpacity(
          0.5,
        ), // More transparency for input
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: gradAccentColor, width: 2.0),
        ), // Focus with accent
        labelStyle: const TextStyle(
          fontFamily: 'Nunito',
          color: gradSecondaryTextColor,
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Nunito',
          color: gradSecondaryTextColor,
          fontSize: 16,
        ),
      ),

      iconTheme: const IconThemeData(
        // Default icon theme
        color: gradSecondaryTextColor, // Grey icons by default
        size: 24,
      ),

      // TODO: Define DialogTheme, BottomSheetTheme etc. adapting for dark gradient
    );
  }
}

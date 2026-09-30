import 'package:flutter/material.dart';

class AppTheme {
  // Shiny Gold Gradient 2 Palette Colors
  static const Color goldHighlight = Color(0xFFFFEB87); // #FFEB87 - Light Gold
  static const Color goldDarkShadow = Color(0xFF824E00); // #824E00 - Deep Bronze
  static const Color goldMidtone = Color(0xFFCC9900); // #CC9900 - Rich Gold
  static const Color goldVibrant = Color(0xFFFFC900); // #FFC900 - Vibrant Gold Accent
  static const Color goldShadow = Color(0xFF825900); // #825900 - Warm Dark Gold

  // Dark Theme Base (60% Dominant Background)
  static const Color dominantDark = Color(0xFF111318); // Dark Sleek Charcoal
  static const Color cardBgDark = Color(0xFF1C1F26); // Elevated Metallic Surface
  static const Color chipBgDark = Color(0xFF2B261A);

  // Light Theme Base (60% Dominant Light Cream)
  static const Color dominantLight = Color(0xFFFBF9F5); // Warm Cream White
  static const Color cardBgLight = Color(0xFFFFFFFF); // Clean White Surface
  static const Color chipBgLight = Color(0xFFFFF7DB);

  // Shiny Gold Linear Gradients
  static const LinearGradient shinyGoldGradient = LinearGradient(
    colors: [
      goldHighlight,
      goldDarkShadow,
      goldMidtone,
      goldVibrant,
      goldShadow,
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    colors: [
      goldHighlight,
      goldVibrant,
      goldMidtone,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: dominantDark,
      colorScheme: const ColorScheme.dark(
        primary: goldVibrant,
        onPrimary: dominantDark,
        secondary: goldHighlight,
        onSecondary: dominantDark,
        surface: cardBgDark,
        onSurface: goldHighlight,
        tertiary: goldMidtone,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: dominantDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: goldVibrant),
        titleTextStyle: TextStyle(
          color: goldHighlight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBgDark,
        elevation: 4,
        shadowColor: Colors.black.withAlpha(120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: goldMidtone, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldVibrant,
          foregroundColor: dominantDark,
          elevation: 4,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldVibrant,
          side: const BorderSide(color: goldVibrant, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBgDark,
        selectedColor: goldVibrant,
        secondarySelectedColor: goldVibrant,
        labelStyle: const TextStyle(color: goldHighlight),
        secondaryLabelStyle: const TextStyle(color: dominantDark, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: goldMidtone, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dominantDark,
        indicatorColor: goldVibrant,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: dominantDark);
          }
          return const IconThemeData(color: goldHighlight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: goldVibrant, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: goldHighlight, fontSize: 12);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBgDark,
        labelStyle: const TextStyle(color: goldHighlight),
        hintStyle: TextStyle(color: goldHighlight.withAlpha(150)),
        prefixIconColor: goldVibrant,
        suffixIconColor: goldVibrant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldDarkShadow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldShadow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldVibrant, width: 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return goldVibrant;
            }
            return cardBgDark;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return dominantDark;
            }
            return goldHighlight;
          }),
        ),
      ),
    );
  }

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: dominantLight,
      colorScheme: const ColorScheme.light(
        primary: goldMidtone,
        onPrimary: Colors.white,
        secondary: dominantDark,
        onSecondary: Colors.white,
        surface: cardBgLight,
        onSurface: dominantDark,
        tertiary: goldVibrant,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: dominantLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: goldMidtone),
        titleTextStyle: TextStyle(
          color: dominantDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBgLight,
        elevation: 3,
        shadowColor: Colors.black.withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: goldHighlight, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldVibrant,
          foregroundColor: dominantDark,
          elevation: 3,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldMidtone,
          side: const BorderSide(color: goldMidtone, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBgLight,
        selectedColor: goldVibrant,
        secondarySelectedColor: goldVibrant,
        labelStyle: const TextStyle(color: dominantDark),
        secondaryLabelStyle: const TextStyle(color: dominantDark, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: goldHighlight, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dominantLight,
        indicatorColor: goldVibrant,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: dominantDark);
          }
          return const IconThemeData(color: dominantDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: goldShadow, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: dominantDark, fontSize: 12);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBgLight,
        labelStyle: const TextStyle(color: dominantDark),
        hintStyle: TextStyle(color: dominantDark.withAlpha(120)),
        prefixIconColor: goldMidtone,
        suffixIconColor: goldMidtone,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldHighlight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldHighlight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldMidtone, width: 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return goldVibrant;
            }
            return cardBgLight;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return dominantDark;
            }
            return dominantDark;
          }),
        ),
      ),
    );
  }
}

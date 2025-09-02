import 'package:flutter/material.dart';

class AppTheme {
  // UNDP Brand Colors
  static const Color primaryColor = Color(0xFF0066CC); // UNDP Blue
  static const Color primaryLightColor = Color(0xFF1A75D1);
  static const Color primaryDarkColor = Color(0xFF0052A3);
  
  static const Color secondaryColor = Color(0xFF00A651); // UNDP Green
  static const Color secondaryLightColor = Color(0xFF1AB366);
  static const Color secondaryDarkColor = Color(0xFF008A44);
  
  static const Color accentColor = Color(0xFFFF6B35); // UNDP Orange
  static const Color accentLightColor = Color(0xFFFF8A5C);
  static const Color accentDarkColor = Color(0xFFE55A2B);
  
  // Supporting Colors
  static const Color successColor = Color(0xFF00A651); // UNDP Green
  static const Color warningColor = Color(0xFFFF6B35); // UNDP Orange
  static const Color errorColor = Color(0xFFDC3545); // Professional Red
  static const Color infoColor = Color(0xFF0066CC); // UNDP Blue
  
  // Neutral Colors
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF6C757D);
  static const Color textTertiaryColor = Color(0xFFADB5BD);
  
  // Border and Divider Colors
  static const Color dividerColor = Color(0xFFE9ECEF);
  static const Color borderColor = Color(0xFFDEE2E6);

    
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    color: textPrimaryColor,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: textPrimaryColor,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: textSecondaryColor,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: textPrimaryColor,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textPrimaryColor,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textSecondaryColor,
  );

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE6F3FF),
        onPrimaryContainer: primaryDarkColor,
        
        secondary: secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFE6F7ED),
        onSecondaryContainer: secondaryDarkColor,
        
        tertiary: accentColor,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFFFF0EB),
        onTertiaryContainer: accentDarkColor,
        
        error: errorColor,
        onError: Colors.white,
        errorContainer: Color(0xFFFFEBEE),
        onErrorContainer: Color(0xFFB71C1C),
        
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        surfaceVariant: Color(0xFFF8F9FA),
        onSurfaceVariant: textSecondaryColor,
        
        background: backgroundColor,
        onBackground: textPrimaryColor,
        
        outline: borderColor,
        outlineVariant: dividerColor,
        
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF1A1A1A),
        onInverseSurface: Colors.white,
        inversePrimary: Color(0xFFB3D9FF),
        surfaceTint: primaryColor,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black, size: 24),
        actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: const Color(0xFF000000).withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: labelLarge.copyWith(color: Colors.white),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: labelLarge,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: labelLarge,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: bodyMedium.copyWith(color: textTertiaryColor),
        labelStyle: bodyMedium.copyWith(color: textSecondaryColor),
        errorStyle: bodySmall.copyWith(color: errorColor),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF8F9FA),
        selectedColor: primaryColor,
        disabledColor: const Color(0xFFF8F9FA),
        labelStyle: labelMedium,
        secondaryLabelStyle: labelMedium.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: borderColor),
        elevation: 0,
        pressElevation: 2,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: labelSmall,
        unselectedLabelStyle: labelSmall,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondaryColor,
        size: 24,
      ),
      
      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return const Color(0xFFDEE2E6);
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return borderColor;
        }),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: const Color(0xFFE9ECEF),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
        valueIndicatorColor: primaryColor,
        valueIndicatorTextStyle: labelMedium.copyWith(color: Colors.white),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE9ECEF),
        circularTrackColor: Color(0xFFE9ECEF),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        titleTextStyle: titleLarge,
        contentTextStyle: bodyMedium,
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimaryColor,
        contentTextStyle: bodyMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: textPrimaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: bodySmall.copyWith(color: Colors.white),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 2),
      ),
      
      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: titleMedium,
        subtitleTextStyle: bodyMedium,
        leadingAndTrailingTextStyle: bodySmall,
        iconColor: textSecondaryColor,
        textColor: textPrimaryColor,
      ),
      
      // Tab Bar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: labelMedium,
        unselectedLabelStyle: labelMedium,
      ),
    );
  }
}

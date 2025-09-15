import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ThemeExtension for shimmer / custom tokens not represented by ThemeData.
@immutable
class AppShimmerStyle extends ThemeExtension<AppShimmerStyle> {
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  const AppShimmerStyle({
    required this.baseColor,
    required this.highlightColor,
    required this.period,
  });

  @override
  AppShimmerStyle copyWith({
    Color? baseColor,
    Color? highlightColor,
    Duration? period,
  }) {
    return AppShimmerStyle(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      period: period ?? this.period,
    );
  }

  @override
  AppShimmerStyle lerp(ThemeExtension<AppShimmerStyle>? other, double t) {
    if (other is! AppShimmerStyle) return this;
    return AppShimmerStyle(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      period: Duration(
        milliseconds:
            (period.inMilliseconds +
                    (other.period.inMilliseconds - period.inMilliseconds) * t)
                .round(),
      ),
    );
  }
}

class AppTheme {
  // Light tokens (from design-tokens.json)
  static const _lightPrimary = Color(0xFF4A4E69);
  static const _lightPrimaryContainer = Color(0xFFE6E3F2);
  static const _lightOnPrimary = Color(0xFFFFFFFF);
  static const _lightSecondary = Color(0xFF9A8C98);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightOnSurface = Color(0xFF1F1D2B);
  static const _lightError = Color(0xFFB00020);

  // Dark tokens
  static const _darkPrimary = Color(0xFFBFC4FF);
  static const _darkPrimaryContainer = Color(0xFF303047);
  static const _darkOnPrimary = Color(0xFF0F1724);
  static const _darkSecondary = Color(0xFFC5B7C1);
  static const _darkSurface = Color(0xFF111318);
  static const _darkOnSurface = Color(0xFFE6E7EB);
  static const _darkError = Color(0xFFFF6B6B);

  // Spacing & radii
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double radiusChip = 8.0;
  static const double radiusCard = 12.0;
  static const double radiusDialog = 20.0;

  // Motion durations
  static const Duration motionShort = Duration(milliseconds: 120);
  static const Duration motionMedium = Duration(milliseconds: 240);
  static const Duration motionLong = Duration(milliseconds: 420);

  /// Returns the light ThemeData
  static ThemeData lightTheme([BuildContext? context]) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimaryContainer,
      secondary: _lightSecondary,
      onSecondary: _lightOnPrimary,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      error: _lightError,
      onError: Colors.white,
    );

    final textTheme = TextTheme(
      displayLarge: GoogleFonts.merriweather(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.merriweather(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleLarge: GoogleFonts.merriweather(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 2,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        margin: EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          padding: EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurface,
        contentPadding: EdgeInsets.all(spaceMd),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppShimmerStyle(
          baseColor: Color(0xFFECE9F8),
          highlightColor: Color(0xFFF7F5FF),
          period: Duration(milliseconds: 1400),
        ),
      ],
    );
  }

  /// Returns the dark ThemeData
  static ThemeData darkTheme([BuildContext? context]) {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimaryContainer,
      secondary: _darkSecondary,
      onSecondary: _darkOnPrimary,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      error: _darkError,
      onError: Colors.black,
    );

    final textTheme = TextTheme(
      displayLarge: GoogleFonts.merriweather(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: _darkOnSurface,
      ),
      headlineLarge: GoogleFonts.merriweather(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: _darkOnSurface,
      ),
      titleLarge: GoogleFonts.merriweather(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: _darkOnSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: _darkOnSurface,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: _darkOnSurface,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: _darkOnSurface,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        margin: EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip),
          ),
          padding: EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceSm),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurface,
        contentPadding: EdgeInsets.all(spaceMd),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppShimmerStyle(
          baseColor: Color(0xFF1B1A23),
          highlightColor: Color(0xFF2B2A35),
          period: Duration(milliseconds: 1400),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemes {
  // 1. Corporate Blue Theme - Professional business look
  static final ThemeData corporateBlue = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1565C0),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2D2D2D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF424242),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
    ),
  );

  // 2. Emerald Professional Theme - Modern green corporate
  static final ThemeData emeraldProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF059669),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF0FDF4),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF059669),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: const Color(0xFF059669).withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF059669),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF064E3B),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF065F46),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF047857),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF374151),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF10B981),
      foregroundColor: Colors.white,
    ),
  );

  // 3. Midnight Professional Theme - Dark theme with purple accents
  static final ThemeData midnightProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C3AED),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F23),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF16213E),
      shadowColor: const Color(0xFF7C3AED).withOpacity(0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFE5E7EB),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFD1D5DB),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFFD1D5DB),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1F2937),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF374151)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
      ),
    ),
  );

  // 4. Rose Gold Executive Theme - Elegant and luxurious
  static final ThemeData roseGoldExecutive = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFBFE),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFAD1457),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      shadowColor: const Color(0xFFE91E63).withOpacity(0.2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFAD1457),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 2,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF2D2D2D),
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF424242),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF424242),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF616161),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE91E63),
      foregroundColor: Colors.white,
      elevation: 6,
    ),
  );

  // 5. Slate Professional Theme - Modern monochrome
  static final ThemeData slateProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF475569),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      shadowColor: const Color(0xFF475569).withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF475569),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF334155),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF475569),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF64748B),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    dividerColor: const Color(0xFFE2E8F0),
  );

  // 6. Ocean Professional Theme - Calming blue-green
  static final ThemeData oceanProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0891B2),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F9FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0891B2),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: const Color(0xFF0891B2).withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF0C4A6E),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF075985),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF0369A1),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF06B6D4),
      foregroundColor: Colors.white,
    ),
  );

  // 7. Amber Professional Theme - Warm and welcoming
  static final ThemeData amberProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF59E0B),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFBEB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD97706),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: const Color(0xFFF59E0B).withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF92400E),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFB45309),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFD97706),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF59E0B),
      foregroundColor: Colors.white,
    ),
  );

  // 8. Indigo Executive Theme - Deep and sophisticated
  static final ThemeData indigoExecutive = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4338CA),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: const Color(0xFF4F46E5).withOpacity(0.15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        elevation: 2,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF1E1B4B),
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF312E81),
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF3730A3),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6366F1),
      foregroundColor: Colors.white,
    ),
  );

  // 9. Charcoal Professional Theme - Dark sophisticated theme
  static final ThemeData charcoalProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF64748B),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF1E293B),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF475569),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFFF8FAFC),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFE2E8F0),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFFCBD5E1),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF64748B),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF64748B),
      foregroundColor: Colors.white,
    ),
  );

  // 10. Teal Professional Theme - Fresh and modern
  static final ThemeData tealProfessional = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D9488),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF0FDFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F766E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: const Color(0xFF0D9488).withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF134E4A),
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF115E59),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF0F766E),
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF4B5563),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF14B8A6),
      foregroundColor: Colors.white,
    ),
  );

  // Helper method to get all themes
  static List<ThemeData> getAllThemes() {
    return [
      corporateBlue,
      emeraldProfessional,
      midnightProfessional,
      roseGoldExecutive,
      slateProfessional,
      oceanProfessional,
      amberProfessional,
      indigoExecutive,
      charcoalProfessional,
      tealProfessional,
    ];
  }

  // Helper method to get theme names
  static List<String> getThemeNames() {
    return [
      'Corporate Blue',
      'Emerald Professional',
      'Midnight Professional',
      'Rose Gold Executive',
      'Slate Professional',
      'Ocean Professional',
      'Amber Professional',
      'Indigo Executive',
      'Charcoal Professional',
      'Teal Professional',
    ];
  }
}

// class ThemeNotifier extends ChangeNotifier {
//   ThemeData _currentTheme = AppThemes.corporateBlue;

//   ThemeData get currentTheme => _currentTheme;

//   void switchTheme(ThemeData theme) {
//     _currentTheme = theme;
//     notifyListeners();
//   }
// }

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.corporateBlue;
  int _currentThemeIndex = 0;

  ThemeData get currentTheme => _currentTheme;
  int get currentThemeIndex => _currentThemeIndex;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  void switchThemeByIndex(int index) async {
    _currentTheme = AppThemes.getAllThemes()[index];
    _currentThemeIndex = index;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selected_theme_index', index);
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('selected_theme_index') ?? 0;
    _currentTheme = AppThemes.getAllThemes()[index];
    _currentThemeIndex = index;
    notifyListeners();
  }
}

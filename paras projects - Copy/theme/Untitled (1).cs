class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: _customTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
    textTheme: _customTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  // Customizing Base TextTheme
  static TextTheme _customTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: 57.0, fontWeight: FontWeight.bold),
      displayMedium: base.displayMedium?.copyWith(fontSize: 45.0, fontWeight: FontWeight.w600),
      displaySmall: base.displaySmall?.copyWith(fontSize: 36.0, fontWeight: FontWeight.w500),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 28.0, fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 24.0, fontWeight: FontWeight.w500),
      titleLarge: base.titleLarge?.copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
      titleMedium: base.titleMedium?.copyWith(fontSize: 18.0, fontWeight: FontWeight.w600),
      titleSmall: base.titleSmall?.copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 18.0, color: Colors.black),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 16.0, color: Colors.black54),
      bodySmall: base.bodySmall?.copyWith(fontSize: 14.0, color: Colors.black38),
      labelLarge: base.labelLarge?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
      labelMedium: base.labelMedium?.copyWith(fontSize: 12.0, fontWeight: FontWeight.w600),
      labelSmall: base.labelSmall?.copyWith(fontSize: 10.0, fontWeight: FontWeight.w500),
    );
  }
}
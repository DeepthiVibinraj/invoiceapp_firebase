import 'package:flutter/material.dart';
import 'package:toptalents/constants/constants.dart';

class AppThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 104, 97, 152),
          //backgroundColor: Colors.indigo,
          iconTheme: IconThemeData(
              color: Color.fromARGB(250, 253, 180, 27), size: 28)),
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(
        color: Colors.indigo[100],
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: _textTheme.labelLarge?.copyWith(color: Colors.grey),
        errorStyle: const TextStyle(color: Colors.red),
        prefixIconColor: colorScheme.secondary,
        suffixIconColor: const Color.fromARGB(250, 253, 180, 27),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        filled: true,
        fillColor: Colors.indigo[50],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 104, 97, 152).withOpacity(0.3),
              width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black26,
            width: 1,
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xF9FDB41B), size: 28),
      primaryColor: const Color.fromARGB(255, 104, 97, 152),

      //scaffoldBackgroundColor: Colors.white,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.titleMedium!.apply(color: _darkFillColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              const Color.fromARGB(255, 104, 97, 152), // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.secondary,
        textColor: colorScheme.onSurface,
        tileColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.surface,
        headerHeadlineStyle: TextStyle(
          color: colorScheme.surface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headerHelpStyle: TextStyle(
          color: colorScheme.surface.withOpacity(0.7),
          fontSize: 12,
        ),
        weekdayStyle: TextStyle(
          color: colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
        dayStyle: TextStyle(
          color: colorScheme.onSurface,
        ),
        // dayBackgroundColor:
        //     MaterialStateProperty.all<Color>(colorScheme.tertiary),
        todayBackgroundColor:
            MaterialStateProperty.all<Color>(colorScheme.secondary),
        todayForegroundColor:
            MaterialStateProperty.all<Color>(colorScheme.surface),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.primary,
        titleTextStyle:
            _textTheme.titleLarge?.copyWith(color: colorScheme.secondary),
        contentTextStyle:
            _textTheme.bodyMedium?.copyWith(color: colorScheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultPadding),
        ),
      ),

      //////////

      canvasColor: colorScheme.background,

      highlightColor: Colors.transparent,
      focusColor: focusColor,
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: const Color.fromARGB(255, 104, 97, 152),
    secondary: const Color.fromARGB(250, 253, 180, 27),
    tertiary: const Color.fromARGB(255, 104, 97, 152).withOpacity(0.2),
    onSecondary: const Color.fromARGB(250, 253, 180, 27).withOpacity(0.2),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xDD000000),

///////////////
    background: const Color(0xFFFEA074),
    brightness: Brightness.light,
    // primary: Color(0xFFFB9851),
    onPrimary: _lightFillColor,
    primaryContainer: const Color(0xFFFEE0D0),
    onPrimaryContainer: const Color(0xFFFEE0D0),
    //secondary: Color.fromARGB(255, 230, 233, 233),
    //onSecondary: const Color.fromARGB(255, 230, 233, 233),
    secondaryContainer: const Color(0xFFFEE0D0),
    onSecondaryContainer: const Color.fromARGB(255, 149, 149, 151),
    // tertiary: Colors.grey,
    onTertiary: const Color(0xFFFFFFFF),
    tertiaryContainer: const Color(0xFFFEE0D0),
    onTertiaryContainer: const Color(0xFFFEE0D0),
    error: const Color.fromARGB(255, 243, 24, 24),
    onError: _lightFillColor,
    errorContainer: _lightFillColor,
    onErrorContainer: _lightFillColor,
    onBackground: const Color(0xFFFAEEE5),
    // surface: Color(0xFFFFFFFF),
    // onSurface: Colors.black87,
    surfaceVariant: const Color(0xFFFFFFFF),
    onSurfaceVariant: Colors.black54,
    outline: const Color(0xFFFFFFFF),
    outlineVariant: const Color(0xFFFFFFFF),
    shadow: const Color(0xFFFFFFFF),
    scrim: const Color(0xFFFFFFFF),
    inverseSurface: const Color(0xFFFFFFFF),
    onInverseSurface: const Color(0xFFFFFFFF),
    inversePrimary: const Color(0xFFFFFFFF),
    surfaceTint: const Color(0xFFFFFFFF),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    background: Color.fromARGB(255, 66, 53, 98),
    brightness: Brightness.light,
    primary: Color(0xFFFB9851),
    onPrimary: _lightFillColor,
    primaryContainer: Color.fromARGB(255, 93, 81, 126),
    onPrimaryContainer: Color(0xFFFEE0D0),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 105, 92, 141),
    secondaryContainer: Color.fromARGB(255, 74, 52, 120),
    onSecondaryContainer: Color(0xFFFEE0D0),
    tertiary: Colors.grey,
    onTertiary: Color.fromARGB(255, 66, 53, 98),
    tertiaryContainer: Color(0xFFFEE0D0),
    onTertiaryContainer: Color(0xFFFEE0D0),
    error: Color.fromARGB(255, 244, 103, 103),
    onError: _lightFillColor,
    errorContainer: _lightFillColor,
    onErrorContainer: _lightFillColor,
    onBackground: Color.fromARGB(255, 93, 81, 126),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    surfaceVariant: Color.fromARGB(255, 93, 81, 126),
    onSurfaceVariant: Colors.black54,
    outline: Color(0xFFFFFFFF),
    outlineVariant: Color(0xFFFFFFFF),
    shadow: Color(0xFFFFFFFF),
    scrim: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFFFFFFFF),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFFFFFFF),
    surfaceTint: Color(0xFFFFFFFF),
  );

  static const _thin = FontWeight.w100;
  static const _light = FontWeight.w300;
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _bold = FontWeight.w700;
  static const _black = FontWeight.w900;

  static const TextTheme _textTheme = TextTheme(
      headlineLarge: TextStyle(
          fontSize: 26.0,
          fontFamily: 'Roboto',
          fontWeight: _bold,
          color: Colors.black87),
      headlineMedium: TextStyle(
          fontSize: 26.0,
          fontFamily: 'Roboto',
          fontWeight: _medium,
          color: Colors.black87),
      headlineSmall: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Roboto',
          fontWeight: _regular,
          color: Colors.black87),
      titleLarge: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Roboto',
          fontWeight: _bold,
          color: Colors.black87),
      titleMedium: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Roboto',
          fontWeight: _medium,
          color: Colors.black87),
      titleSmall: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          fontWeight: _medium,
          color: Colors.black87),
      labelSmall: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Roboto',
          fontWeight: _medium,
          color: Colors.black87),
      labelLarge: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          fontWeight: _thin,
          color: Colors.black87),
      bodyLarge: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Roboto',
          fontWeight: _medium,
          color: Colors.black87),
      bodyMedium: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Roboto',
          fontWeight: _regular,
          color: Colors.black87),
      bodySmall: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Roboto',
          fontWeight: _thin,
          color: Colors.black87));
}

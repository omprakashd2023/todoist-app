import 'package:flutter/material.dart';

class Colours {
  static const Color primary = Color(0xffFCA140);
  static const Color secondary = Color(0xFF4A258F);
  static const Color tertiary = Color(0xffF7B858);

  static const Color red = Color(0xFFDA4040);
  static const Color green = Color(0xFF4CAF50);
  static const Color blue = Color(0xFF5F52EE);

  static const Color black = Color(0xFF3A3A3A);
  static const Color grey = Color(0xFF717171);
  static const Color white = Color(0xFFFFFFFF);

  static const Color bgColor = Color(0xFFE5E5E5);

  static ThemeData customTheme = ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xffFCA140),
    primaryColorDark: const Color(0xffF7B858),
    scaffoldBackgroundColor: bgColor,
    appBarTheme: AppBarTheme(
      color: const Color(0xffFCA140),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).titleLarge,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xffFCA140),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF4A258F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xffFCA140),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: secondary,
      error: red,
      tertiary: tertiary,
      primaryContainer: green,
    ),
  );
}

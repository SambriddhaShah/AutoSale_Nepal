import 'package:flutter/material.dart';

// CustomColors class contains custom color constants used throughout the application.
class CustomColors {
  static const apiKey = "AIzaSyAwtJp_yVU7ilw4gIFdNALiUz3yy4ehxXA";
  static const primaryColour = Color(0xFF1D0103);
  static const secondaryColor = Color(0xFFF8EDED);
  static const thirdColor = Color.fromARGB(255, 255, 255, 255);
  static const shadowColor = Color(0xFF564142);
  // appColor: Custom application color.
  static const appColor = Color(0xFF1D0103);
  static const inputTextBoarder = Color(0xFFF4F3F3);
  static const inputTextErrorBoarder = Color(0xFFF94018);
  static const differentColor = const Color.fromARGB(255, 0, 33, 59);

  // orange: Custom MaterialColor for shades of orange.
  static MaterialColor orange = MaterialColor(
    orangePrimaryValue,
    <int, Color>{
      50: generateShade(orangePrimaryValue, 0.9),
      100: generateShade(orangePrimaryValue, 0.8),
      200: generateShade(orangePrimaryValue, 0.7),
      300: generateShade(orangePrimaryValue, 0.6),
      400: generateShade(orangePrimaryValue, 0.5),
      500: Color(orangePrimaryValue), // Primary color
      600: generateShade(orangePrimaryValue, 0.4),
      700: generateShade(orangePrimaryValue, 0.3),
      800: generateShade(orangePrimaryValue, 0.2),
      900: generateShade(orangePrimaryValue, 0.1),
    },
    // <int, Color>{
    //   50: Color(0xFFFFF3E0),
    //   100: Color(0xFFFFE0B2),
    //   200: Color(0xFFFFCC80),
    //   300: Color(0xFFFFB74D),
    //   400: Color(0xFFFFA726),
    //   500: Color(orangePrimaryValue),
    //   600: Color(0xFFFB8C00),
    //   700: Color(0xFFF57C00),
    //   800: Color(0xFFEF6C00),
    //   900: Color(0xFFE65100),
    // },
  );

  static const int orangePrimaryValue = 0xFF1D0103;
}

Color generateShade(int primaryValue, double factor) {
  int red = ((primaryValue >> 16) & 0xFF);
  int green = ((primaryValue >> 8) & 0xFF);
  int blue = (primaryValue & 0xFF);

  red = (red * factor).round().clamp(0, 255);
  green = (green * factor).round().clamp(0, 255);
  blue = (blue * factor).round().clamp(0, 255);

  return Color.fromARGB(255, red, green, blue);
}

// Theme-aware versions of the custom widgets

import 'package:flutter/material.dart';

class ThemeColors {
  final List<Color> backgroundGradient;
  final Color buttonColor;
  final Color textColor;
  final Color fieldFillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color iconColor;
  final Color errorcolor;

  ThemeColors({
    required this.backgroundGradient,
    required this.buttonColor,
    required this.textColor,
    required this.fieldFillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.iconColor,
    required this.errorcolor,
  });
}

ThemeColors getThemeColors(String userType) {
  switch (userType.toLowerCase()) {
    case 'client':
      return ThemeColors(
          backgroundGradient: [Color(0xFF0A0F2C), Color(0xFF000814)],
          buttonColor: Color(0xFF1E88E5),
          textColor: Colors.white,
          fieldFillColor: Color(0xFF1A1A2E),
          borderColor: Colors.blueAccent.shade100,
          focusedBorderColor: Colors.cyanAccent.shade200,
          iconColor: Colors.grey.shade300,
          errorcolor: Colors.redAccent.shade100);

    case 'freelancer':
      return ThemeColors(
          backgroundGradient: [Color(0xFF2C0A00), Color(0xFF120700)],
          buttonColor: Color(0xFFEF6C00),
          textColor: Colors.white,
          fieldFillColor: Color(0xFF1A0A00),
          borderColor: Colors.deepOrange.shade700,
          focusedBorderColor: Colors.orange.shade400,
          iconColor: Colors.orange.shade200,
          errorcolor: Colors.white70);

    case 'both':
      return ThemeColors(
        // backgroundGradient: [Color(0xFF1D0033), Color(0xFF0D001A)],
        // buttonColor: Color(0xFFE040FB),
        // textColor: Colors.white,
        backgroundGradient: [
          Color(0xFF1D0033),
          Color(0xFF0D001A)
        ], // rich dark purple/pink
        buttonColor: Color(0xFF6A1B9A), // deep royal purple
        textColor: Colors.white,
        fieldFillColor: Color(0xFF1A1A2E),
        borderColor: Colors.purple.shade200,
        focusedBorderColor: Colors.pink.shade300,
        iconColor: Colors.purple.shade100,
        errorcolor: Colors.pinkAccent.shade100,
      );

    case 'login':
      return ThemeColors(
        backgroundGradient: [
          Color(0xFF1A0026),
          Color(0xFF0B0014)
        ], // deep plum to dark violet
        buttonColor: Color(0xFF8E24AA), // strong purple (Amethyst)
        textColor: Colors.white,
        fieldFillColor: Color(0xFF24003E), // very dark purple fill
        borderColor: Colors.deepPurple.shade200,
        focusedBorderColor: Colors.purpleAccent.shade100,
        iconColor: Colors.deepPurple.shade100,
        errorcolor: Colors.pinkAccent.shade100,
      );
  }

  // Optional: throw an error if unknown userType is passed
  throw ArgumentError('Unknown userType: $userType');
}

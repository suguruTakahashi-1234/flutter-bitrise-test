import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: _kPurpleSwatch,
  backgroundColor: Colors.white,
  dividerTheme: DividerThemeData(
    thickness: 1,
  ),
);

const int _kPurplePrimaryValue = 0xFF1853B5;
const MaterialColor _kPurpleSwatch =
    MaterialColor(_kPurplePrimaryValue, <int, Color>{
  50: Color(0xFFE3EAF6),
  100: Color(0xFFBACBE9),
  200: Color(0xFF8CA9DA),
  300: Color(0xFF5D87CB),
  400: Color(0xFF3B6DC0),
  500: Color(_kPurplePrimaryValue),
  600: Color(0xFF154CAE),
  700: Color(0xFF1142A5),
  800: Color(0xFF0E399D),
  900: Color(0xFF08298D),
});

import 'package:flutter/material.dart';

class C {
  static const brown = Color(0xFFA0680F);
  static const cream = Color(0xFFF8EFDC);
  static const sand = Color(0xFFEFE2C6);
  static const gold = Color(0xFFF2B632);
  static const ink = Color(0xFF2B1D0E);
  static const muted = Color(0xFF8A7A62);
  static const green = Color(0xFF2E7D5B);
  static const red = Color(0xFFC0392B);
}

TextStyle h(double size, [Color color = C.ink]) => TextStyle(
    fontFamily: 'serif', fontWeight: FontWeight.w800, fontSize: size, color: color);

TextStyle t(double size, {Color color = C.ink, FontWeight w = FontWeight.w500}) =>
    TextStyle(fontSize: size, color: color, fontWeight: w);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: C.cream,
      colorScheme: ColorScheme.fromSeed(seedColor: C.brown, primary: C.brown),
    );

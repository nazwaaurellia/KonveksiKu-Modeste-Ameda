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

/// Skala font global (1.0 = ukuran asli).
/// Ubah angka ini untuk memperbesar / memperkecil SEMUA teks di aplikasi.
const double kFontScale = 1.0;
const double kMinFont = 11;
double _fs(double s) => s * kFontScale < kMinFont ? kMinFont : s * kFontScale;

TextStyle h(double size, [Color color = C.ink]) => TextStyle(
    fontWeight: FontWeight.w800, height: 1.2, fontSize: _fs(size) * 0.88, color: color);

TextStyle t(double size, {Color color = C.ink, FontWeight w = FontWeight.w500}) =>
    TextStyle(fontSize: _fs(size), color: color, fontWeight: w, height: 1.3);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: C.cream,
      colorScheme: ColorScheme.fromSeed(seedColor: C.brown, primary: C.brown),
    );

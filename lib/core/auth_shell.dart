import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'floral_bg.dart';
import 'theme.dart';
import 'welcome_assets.dart';
import 'widgets.dart';

final Uint8List _logoBytes = base64Decode(kLogoBase64);

/// Kerangka layar Masuk / Daftar / Lupa kata sandi: logo di tengah,
/// tanpa header coklat, di atas latar bunga samar.
class AuthShell extends StatelessWidget {
  final String sub; // dipertahankan agar pemanggilan lama tetap jalan
  final List<Widget> body;
  const AuthShell(this.sub, this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    final p = pad(context);
    final logoW = math.min(MediaQuery.sizeOf(context).width * 0.42, 170.0);
    return Scaffold(
      body: FloralBg(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(p, MediaQuery.paddingOf(context).top + 36, p, 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Image.memory(_logoBytes, width: logoW, fit: BoxFit.contain)),
                const SizedBox(height: 18),
                ...body,
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Judul layar auth yang rata tengah (judul besar + keterangan kecil).
class AuthTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const AuthTitle(this.title, {this.subtitle, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Text(title, textAlign: TextAlign.center, style: h(24)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(subtitle!, textAlign: TextAlign.center, style: t(12, color: C.muted)),
              ),
          ]),
        ),
      );
}

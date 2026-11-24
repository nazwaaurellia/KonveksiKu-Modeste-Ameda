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
  final Widget? footer; // ditempel di dasar layar (mis. "Belum punya akun? Daftar")
  const AuthShell(this.sub, this.body, {this.footer, super.key});

  @override
  Widget build(BuildContext context) {
    final p = pad(context);
    final logoW = math.min(MediaQuery.sizeOf(context).width * 0.40, 160.0);
    return Scaffold(
      body: FloralBg(
        opacity: 2.4,
        scale: 1.6,
        outline: false,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(p + 4, 24, p + 4, 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight - 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Center(child: Image.memory(_logoBytes, width: logoW, fit: BoxFit.contain)),
                          const SizedBox(height: 22),
                          ...body,
                        ]),
                        if (footer != null) Padding(padding: const EdgeInsets.only(top: 24), child: footer!),
                      ],
                    ),
                  ),
                ),
              ),
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
            Text(title, textAlign: TextAlign.center, style: h(25)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(subtitle!, textAlign: TextAlign.center, style: t(13, color: C.muted)),
              ),
          ]),
        ),
      );
}

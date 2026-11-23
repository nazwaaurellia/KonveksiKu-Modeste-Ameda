import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/floral_bg.dart' show FloralPainter;
import '../../core/theme.dart' show C;
import '../../core/welcome_assets.dart';

// Gambar tertanam di kode -> tidak perlu folder assets / pubspec.
final Uint8List _logo = base64Decode(kLogoBase64);
final Uint8List _dress = base64Decode(kPhotoDress);
final Uint8List _tote = base64Decode(kPhotoTote);
final Uint8List _pouch = base64Decode(kPhotoPouch);
final Uint8List _cardigan = base64Decode(kPhotoCardigan);
final Uint8List _pants = base64Decode(kPhotoPants);
final Uint8List _bag = base64Decode(kPhotoBag);

/// Layar sambutan setelah login. Tampil beberapa detik, lalu otomatis
/// pindah ke halaman utama ([next]). Ketuk layar untuk melewati.
class WelcomeScreen extends StatefulWidget {
  final Widget next;
  final Duration duration;
  const WelcomeScreen({
    super.key,
    required this.next,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  Timer? _timer;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300))
      ..forward();
    _timer = Timer(widget.duration, _goNext);
  }

  void _goNext() {
    if (_done || !mounted) return;
    _done = true;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => widget.next,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    super.dispose();
  }

  // Animasi muncul bertahap untuk tiap foto.
  Widget _appear(int i, Widget child) {
    final a = CurvedAnimation(
      parent: _intro,
      curve: Interval(0.08 * i, math.min(1.0, 0.45 + 0.08 * i),
          curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(a),
        child: child,
      ),
    );
  }

  Widget _photo(Uint8List bytes, double angle, int i) => _appear(
        i,
        Transform.rotate(
          angle: angle,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.28),
                    blurRadius: 14,
                    offset: Offset(0, 6)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox.expand(
                child: Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _goNext,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB98215), C.brown, Color(0xFF86570B)],
              ),
            ),
            child: CustomPaint(
              painter: const FloralPainter(color: Colors.white, leaf: Color(0xFFF7D37A)),
              child: SafeArea(
                child: LayoutBuilder(builder: (context, box) {
                  final w = box.maxWidth;
                  final logoW = math.min(w * 0.58, 280.0);
                  return Column(children: [
                    const SizedBox(height: 10),
                    // Logo (PNG transparan) + cahaya krem lembut agar terbaca
                    _appear(
                      0,
                      SizedBox(
                        width: logoW * 1.25,
                        height: logoW * 1.2,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                C.cream.withOpacity(0.95),
                                C.cream.withOpacity(0.80),
                                C.cream.withOpacity(0.0),
                              ], stops: const [0.0, 0.62, 1.0]),
                            ),
                          ),
                          Image.memory(_logo, width: logoW, fit: BoxFit.contain),
                        ]),
                      ),
                    ),
                    // Kolase foto: 2 kolom, selang-seling
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                        child: LayoutBuilder(builder: (context, c) {
                          const gap = 14.0;
                          const stagger = 28.0;
                          final colW = (c.maxWidth - gap) / 2;
                          final tileH = (c.maxHeight - stagger - gap * 2) / 3;
                          Widget tile(int col, int row, Uint8List b, double a, int i) =>
                              Positioned(
                                left: col * (colW + gap),
                                top: (col == 1 ? stagger : 0) + row * (tileH + gap),
                                width: colW,
                                height: tileH,
                                child: _photo(b, a, i),
                              );
                          return Stack(children: [
                            tile(0, 0, _dress, -0.035, 1),
                            tile(1, 0, _tote, 0.03, 2),
                            tile(0, 1, _pouch, 0.03, 3),
                            tile(1, 1, _cardigan, -0.03, 4),
                            tile(0, 2, _pants, -0.025, 5),
                            tile(1, 2, _bag, 0.025, 6),
                          ]);
                        }),
                      ),
                    ),
                    // Bar loading + teks
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 14, 40, 18),
                      child: Column(children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: widget.duration,
                          builder: (_, v, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: v,
                              minHeight: 4,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Menyiapkan halaman Anda…',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                  ]);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

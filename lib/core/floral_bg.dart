import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

/// Latar bunga samar-samar (motif bordir). Taruh sebagai `body` Scaffold:
/// bunga digambar di belakang, [child] tampil di atasnya.
class FloralBg extends StatelessWidget {
  final Widget child;
  final Color color;
  final double opacity, scale;
  final bool outline;
  const FloralBg({
    super.key,
    required this.child,
    this.color = C.brown,
    this.opacity = 1.4,
    this.scale = 1.0,
    this.outline = true,
  });

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(painter: FloralPainter(color: color, opacity: opacity, scale: scale, outline: outline)),
            ),
          ),
          child,
        ],
      );
}

/// Menggambar bunga & daun langsung di canvas (tanpa file gambar).
class FloralPainter extends CustomPainter {
  final Color color;
  final Color leaf;
  final double opacity, scale;
  final bool outline;
  const FloralPainter({
    required this.color,
    this.leaf = const Color(0xFFF2B632),
    this.opacity = 1.0,
    this.scale = 1.0,
    this.outline = true,
  });

  // (x, y, radius, rotasi) sebagai pecahan lebar/tinggi layar.
  static const _flowers = <List<double>>[
    [0.10, 0.07, 0.17, 0.3],
    [0.93, 0.18, 0.13, 1.0],
    [0.05, 0.38, 0.12, 0.7],
    [0.96, 0.50, 0.18, 0.1],
    [0.08, 0.70, 0.16, 0.5],
    [0.90, 0.86, 0.14, 0.9],
    [0.45, 0.98, 0.12, 0.2],
  ];

  @override
  void paint(Canvas canvas, Size s) {
    final fill = Paint()..color = color.withOpacity((0.07 * opacity).clamp(0.0, 1.0));
    final line = Paint()
      ..color = color.withOpacity(outline ? (0.10 * opacity).clamp(0.0, 1.0) : 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final leafPaint = Paint()..color = leaf.withOpacity((0.08 * opacity).clamp(0.0, 1.0));

    for (final f in _flowers) {
      final o = Offset(s.width * f[0], s.height * f[1]);
      final r = s.width * f[2] * scale;
      _flower(canvas, o, r, f[3], fill, line);
      _leaves(canvas, o, r, f[3], leafPaint);
    }
  }

  void _flower(Canvas c, Offset o, double r, double rot, Paint fill, Paint line) {
    for (var i = 0; i < 6; i++) {
      c.save();
      c.translate(o.dx, o.dy);
      c.rotate(rot + i * math.pi / 3);
      final petal = Rect.fromCenter(center: Offset(0, -r * 0.55), width: r * 0.62, height: r * 1.0);
      c.drawOval(petal, fill);
      c.drawOval(petal, line);
      c.restore();
    }
    c.drawCircle(o, r * 0.2, fill);
    c.drawCircle(o, r * 0.2, line);
  }

  void _leaves(Canvas c, Offset o, double r, double rot, Paint leafPaint) {
    for (var i = 0; i < 3; i++) {
      c.save();
      c.translate(o.dx, o.dy);
      c.rotate(rot + math.pi / 6 + i * 2 * math.pi / 3);
      c.drawOval(Rect.fromCenter(center: Offset(0, -r * 1.35), width: r * 0.34, height: r * 0.7), leafPaint);
      c.restore();
    }
  }

  @override
  bool shouldRepaint(covariant FloralPainter old) =>
      old.color != color || old.leaf != leaf || old.opacity != opacity || old.scale != scale || old.outline != outline;
}

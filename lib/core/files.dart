import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

/// Berkas hasil pilihan pengguna.
class PickedFile {
  final String name;
  final Uint8List? bytes;
  final int size;
  const PickedFile(this.name, this.bytes, this.size);
  String get ext => name.contains('.') ? name.split('.').last.toLowerCase() : '';
  bool get isImage => const ['png', 'jpg', 'jpeg', 'webp', 'gif'].contains(ext);
}

const kDesignExt = ['png', 'jpg', 'jpeg', 'webp', 'pdf', 'svg', 'ai', 'psd', 'cdr', 'eps'];
const kProofExt = ['png', 'jpg', 'jpeg', 'webp', 'pdf'];

/// Buka pemilih berkas perangkat. [image] = hanya gambar; [ext] = batasi ekstensi.
Future<PickedFile?> pickFile({bool image = false, List<String>? ext}) async {
  try {
    final r = await FilePicker.platform.pickFiles(
      type: image ? FileType.image : (ext != null ? FileType.custom : FileType.any),
      allowedExtensions: image ? null : ext,
      withData: true,
    );
    if (r == null || r.files.isEmpty) return null;
    final f = r.files.first;
    return PickedFile(f.name, f.bytes, f.size);
  } catch (_) {
    return null;
  }
}

/// Simpan berkas ke perangkat (dialog simpan / unduhan).
Future<bool> saveBytes(String name, Uint8List bytes) async {
  try {
    final r = await FilePicker.platform.saveFile(dialogTitle: 'Simpan berkas', fileName: name, bytes: bytes);
    return r != null || true;
  } catch (_) {
    return false;
  }
}

/// Foto profil pelanggan (disimpan selama aplikasi terbuka).
final ValueNotifier<Uint8List?> kAvatar = ValueNotifier<Uint8List?>(null);

class UserAvatar extends StatelessWidget {
  final double radius;
  final String name;
  final Color bg, fg;
  const UserAvatar({this.radius = 20, required this.name, this.bg = C.brown, this.fg = Colors.white, super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Uint8List?>(
        valueListenable: kAvatar,
        builder: (_, bytes, __) => CircleAvatar(
          radius: radius,
          backgroundColor: bg,
          backgroundImage: bytes != null ? MemoryImage(bytes) : null,
          child: bytes != null
              ? null
              : Text(name.isEmpty ? '?' : name[0].toUpperCase(),
                  style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: radius * 0.8)),
        ),
      );
}

/// Ikon chat bulat dengan ekor di kiri bawah (sama seperti desain).
class ChatIcon extends StatelessWidget {
  final double size;
  final Color color;
  const ChatIcon({this.size = 22, this.color = C.brown, super.key});
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _ChatPainter(color)));
}

class _ChatPainter extends CustomPainter {
  final Color color;
  _ChatPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final path = Path()
      ..moveTo(7.9 * s, 20 * s)
      ..arcToPoint(Offset(4 * s, 16.1 * s), radius: Radius.circular(9 * s), largeArc: true, clockwise: false)
      ..lineTo(2 * s, 22 * s)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ChatPainter old) => old.color != color;
}

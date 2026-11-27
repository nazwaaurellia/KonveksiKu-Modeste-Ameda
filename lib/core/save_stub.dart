import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

/// Simpan berkas di Android / iOS / desktop lewat dialog simpan.
Future<bool> saveBytesImpl(String name, Uint8List bytes, String mime) async {
  final r = await FilePicker.platform.saveFile(dialogTitle: 'Simpan berkas', fileName: name, bytes: bytes);
  return r != null;
}

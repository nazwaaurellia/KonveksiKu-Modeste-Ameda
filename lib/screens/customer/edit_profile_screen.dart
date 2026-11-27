import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final s = AppStore.I;
  late final name = TextEditingController(text: s.userName);
  late final email = TextEditingController(text: s.userEmail);
  late final phone = TextEditingController(text: s.userPhone);
  Uint8List? photo; // foto baru (belum disimpan)

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final f = await pickFile(image: true);
    if (f?.bytes != null) setState(() => photo = f!.bytes);
  }

  Future<bool> _verifyEmail(String e) async {
    final c = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: C.cream,
        title: Text('Verifikasi email', style: h(20)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Kami mengirim kode 6 angka ke $e. Masukkan kodenya di bawah.', style: t(13, color: C.muted)),
          const SizedBox(height: 4),
          Text('Mode demo: kode verifikasi 123456', style: t(12, color: C.brown, w: FontWeight.w700)),
          const SizedBox(height: 10),
          TextField(controller: c, autofocus: true, keyboardType: TextInputType.number, maxLength: 6, decoration: const InputDecoration(hintText: 'Kode verifikasi')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal', style: t(13, color: C.muted))),
          TextButton(
            onPressed: () => Navigator.pop(context, c.text.trim() == '123456'),
            child: Text('Verifikasi', style: t(13, color: C.brown, w: FontWeight.w800)),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _save() async {
    final n = name.text.trim();
    final e = email.text.trim();
    if (n.isEmpty) return toast(context, 'Nama tidak boleh kosong');
    if (!e.contains('@') || !e.contains('.')) return toast(context, 'Format email belum benar');
    if (e != s.userEmail) {
      final ok = await _verifyEmail(e);
      if (!ok) {
        if (mounted) toast(context, 'Kode verifikasi salah, email tidak diubah');
        return;
      }
    }
    s.updateProfile(name: n, email: e, phone: phone.text);
    if (photo != null) kAvatar.value = photo;
    if (mounted) {
      toast(context, 'Profil disimpan');
      Navigator.pop(context);
    }
  }

  Widget _label(String x) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(x, style: t(13, w: FontWeight.w700)));
  Widget _help(String x) => Padding(padding: const EdgeInsets.only(top: 6, bottom: 4), child: Text(x, style: t(12, color: C.muted).copyWith(height: 1.4)));

  Widget _field(TextEditingController c, {String? hint, TextInputType? type}) => TextField(
        controller: c,
        keyboardType: type,
        style: t(14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: t(14, color: C.muted.withOpacity(.7)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFE6D7B5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: C.brown, width: 1.4)),
        ),
      );

  @override
  Widget build(BuildContext context) => Screen(
        title: 'Edit profil',
        back: true,
        bottom: Column(mainAxisSize: MainAxisSize.min, children: [
          Btn('Simpan perubahan', _save),
          const SizedBox(height: 8),
          Btn('Batal', () => Navigator.pop(context), light: true),
        ]),
        children: [
          const SizedBox(height: 4),
          Center(
            child: GestureDetector(
              onTap: _pick,
              child: Stack(clipBehavior: Clip.none, children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: C.brown,
                  backgroundImage: photo != null ? MemoryImage(photo!) : (kAvatar.value != null ? MemoryImage(kAvatar.value!) : null),
                  child: (photo != null || kAvatar.value != null)
                      ? null
                      : Text(name.text.isEmpty ? '?' : name.text[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800)),
                ),
                Positioned(
                  right: -2,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE6D7B5))),
                    child: const Icon(Icons.photo_camera_outlined, size: 18, color: C.brown),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: OutlinedButton(
              onPressed: _pick,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: C.brown),
                shape: const StadiumBorder(),
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 22),
              ),
              child: Text('Ganti foto', style: t(13, color: C.brown, w: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 22),
          _label('Nama lengkap'),
          _field(name),
          const SizedBox(height: 18),
          _label('Email'),
          _field(email, type: TextInputType.emailAddress),
          _help('Mengganti email perlu verifikasi lewat kode yang kami kirim.'),
          const SizedBox(height: 14),
          _label('Nomor HP'),
          _field(phone, hint: '08xx xxxx xxxx', type: TextInputType.phone),
          _help('Dipakai admin untuk menghubungi soal pesananmu.'),
        ],
      );
}

import 'package:flutter/material.dart';
import '../../core/auth_shell.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(), email = TextEditingController();
  final phone = TextEditingController(), pass = TextEditingController();

  @override
  void dispose() {
    for (final c in [name, email, phone, pass]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (name.text.trim().isEmpty || email.text.trim().isEmpty) return toast(context, 'Nama dan email wajib diisi');
    if (pass.text.length < 8) return toast(context, 'Kata sandi minimal 8 karakter');
    AppStore.I.register(name.text, email.text);
    toast(context, 'Akun dibuat. Silakan masuk.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => AuthShell('Buat akun pelanggan', [
        const AuthTitle('Daftar', subtitle: 'Buat akun pelanggan baru'),
        Fld('Nama lengkap', 'Sari Wulandari', ctrl: name),
        Fld('Email', 'sari@email.com', ctrl: email, keyboard: TextInputType.emailAddress),
        Fld('Nomor HP / WhatsApp', '0812 3456 7890', ctrl: phone, keyboard: TextInputType.phone),
        Fld('Kata sandi', '••••••••••', ctrl: pass, obscure: true),
        Text('Minimal 8 karakter, kombinasi huruf dan angka', style: t(10, color: C.muted)),
        const SizedBox(height: 14),
        Btn('Daftar', _submit),
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Sudah punya akun? Masuk', style: t(12, color: C.brown, w: FontWeight.w700)),
            ),
          ),
        ),
      ]);
}

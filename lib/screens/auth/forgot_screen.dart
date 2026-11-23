import 'package:flutter/material.dart';
import '../../core/auth_shell.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final email = TextEditingController(), code = TextEditingController();
  bool sent = false;

  @override
  void dispose() {
    email.dispose();
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthShell('Pemulihan akun', [
        const AuthTitle('Lupa kata sandi',
            subtitle: 'Masukkan email atau nomor HP. Kami kirim kode verifikasi 6 digit.'),
        Fld('Email atau nomor HP', 'sari@email.com', ctrl: email),
        Btn(sent ? 'Kirim ulang kode' : 'Kirim kode', () {
          if (email.text.trim().isEmpty) return toast(context, 'Isi email atau nomor HP dulu');
          setState(() => sent = true);
          toast(context, 'Kode verifikasi dikirim (demo)');
        }),
        if (sent) ...[
          const SizedBox(height: 16),
          Fld('Masukkan kode', '6 digit', ctrl: code, keyboard: TextInputType.number),
          Btn('Verifikasi', () {
            if (code.text.trim().length != 6) return toast(context, 'Kode harus 6 digit');
            toast(context, 'Kode benar. Silakan atur ulang kata sandi.');
            Navigator.pop(context);
          }),
        ],
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Ingat sandi? Masuk', style: t(12, color: C.brown, w: FontWeight.w700)),
            ),
          ),
        ),
      ]);
}

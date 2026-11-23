import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'admin_screens.dart';
import 'customer_screens.dart';

class _AuthShell extends StatelessWidget {
  final String sub;
  final List<Widget> body;
  const _AuthShell(this.sub, this.body);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              decoration: const BoxDecoration(
                color: C.brown,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(children: [
                CircleAvatar(radius: 28, backgroundColor: C.cream, child: Text('MA', style: h(18, C.brown))),
                const SizedBox(height: 10),
                Text('MODESTE AMEDA', style: t(15, color: Colors.white, w: FontWeight.w800)),
                Text(sub, style: t(11, color: Colors.white70)),
              ]),
            ),
            Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: body)),
          ]),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  bool remember = true;

  void _login() {
    // Demo: email mengandung "admin" -> masuk sebagai admin, selain itu pelanggan.
    final admin = email.text.toLowerCase().contains('admin');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => admin ? const AdminShell() : const CustomerShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => _AuthShell('Konveksi & Bordir', [
        Text('Masuk', style: h(24)),
        Text('Selamat datang kembali', style: t(11, color: C.muted)),
        const SizedBox(height: 14),
        Fld('Email atau nomor HP', 'sari@email.com', ctrl: email),
        const Fld('Kata sandi', '••••••••••', obscure: true),
        Row(children: [
          Checkbox(value: remember, activeColor: C.brown, onChanged: (v) => setState(() => remember = v!)),
          Text('Ingat saya', style: t(12)),
          const Spacer(),
          GestureDetector(
            onTap: () => go(context, const ForgotScreen()),
            child: Text('Lupa kata sandi?', style: t(12, color: C.brown, w: FontWeight.w700)),
          ),
        ]),
        Btn('Masuk', _login),
        const SizedBox(height: 10),
        Btn('Lanjutkan dengan Google', _login, light: true),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => go(context, const RegisterScreen()),
            child: Text('Belum punya akun? Daftar', style: t(12, color: C.brown, w: FontWeight.w700)),
          ),
        ),
      ]);
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => _AuthShell('Buat akun pelanggan', [
        Text('Daftar', style: h(24)),
        const SizedBox(height: 10),
        const Fld('Nama lengkap', 'Sari Wulandari'),
        const Fld('Email', 'sari@email.com'),
        const Fld('Nomor HP / WhatsApp', '0812 3456 7890'),
        const Fld('Kata sandi', '••••••••••', obscure: true),
        Text('Minimal 8 karakter, kombinasi huruf dan angka', style: t(10, color: C.muted)),
        const SizedBox(height: 14),
        Btn('Daftar', () => Navigator.pop(context)),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Sudah punya akun? Masuk', style: t(12, color: C.brown, w: FontWeight.w700)),
          ),
        ),
      ]);
}

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});
  @override
  Widget build(BuildContext context) => _AuthShell('Pemulihan akun', [
        Text('Lupa kata sandi', style: h(24)),
        Text('Masukkan email atau nomor HP. Kami kirim kode verifikasi 6 digit.', style: t(11, color: C.muted)),
        const SizedBox(height: 14),
        const Fld('Email atau nomor HP', 'sari@email.com'),
        Btn('Kirim kode', () {}),
        const SizedBox(height: 16),
        Center(child: Text('Masukkan kode', style: t(11, color: C.muted))),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < 6; i++)
            Container(
              width: 38, height: 44, margin: const EdgeInsets.all(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: C.sand, borderRadius: BorderRadius.circular(10)),
              child: Text(i < 3 ? '${[4, 8, 2][i]}' : '', style: h(18)),
            ),
        ]),
        const SizedBox(height: 14),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Ingat sandi? Masuk', style: t(12, color: C.brown, w: FontWeight.w700)),
          ),
        ),
      ]);
}

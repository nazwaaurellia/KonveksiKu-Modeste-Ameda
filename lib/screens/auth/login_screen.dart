import 'package:flutter/material.dart';
import '../../core/auth_shell.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../admin/admin_shell.dart';
import '../customer/customer_shell.dart';
import 'forgot_screen.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  bool remember = true;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  void _login([String? forced]) {
    final s = AppStore.I;
    s.login(forced ?? (email.text.trim().isEmpty ? 'sari@email.com' : email.text));
    // Demo: email berisi "admin" -> masuk sebagai admin, selain itu pelanggan.
    // Tampilkan layar sambutan dulu, lalu otomatis ke halaman utama.
    goReplaceAll(
      context,
      WelcomeScreen(next: s.isAdmin ? const AdminShell() : const CustomerShell()),
    );
  }

  @override
  Widget build(BuildContext context) => AuthShell('Konveksi & Bordir', [
        const AuthTitle('Masuk', subtitle: 'Selamat datang kembali'),
        Fld('Email atau nomor HP', 'sari@email.com', ctrl: email, keyboard: TextInputType.emailAddress),
        const Fld('Kata sandi', '••••••••••', obscure: true),
        Row(children: [
          Checkbox(value: remember, activeColor: C.brown, onChanged: (v) => setState(() => remember = v ?? false)),
          Expanded(child: Text('Ingat saya', style: t(12))),
          InkWell(
            onTap: () => go(context, const ForgotScreen()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Lupa kata sandi?', style: t(12, color: C.brown, w: FontWeight.w700)),
            ),
          ),
        ]),
        Btn('Masuk', _login),
        const SizedBox(height: 10),
        Btn('Lanjutkan dengan Google', () => _login('sari@email.com'), light: true),
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            onTap: () => go(context, const RegisterScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Belum punya akun? Daftar', style: t(12, color: C.brown, w: FontWeight.w700)),
            ),
          ),
        ),
        Center(
          child: Text('Tips demo: email berisi "admin" untuk masuk sebagai admin.',
              textAlign: TextAlign.center, style: t(10, color: C.muted)),
        ),
      ]);
}

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
  Widget build(BuildContext context) => AuthShell(
        'Konveksi & Bordir',
        [
          const AuthTitle('Masuk', subtitle: 'Selamat datang kembali'),
          Fld('Email atau nomor HP', 'sari@email.com', ctrl: email, keyboard: TextInputType.emailAddress),
          const Fld('Kata sandi', '••••••••••', obscure: true),
          Row(children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: remember,
                activeColor: C.brown,
                side: const BorderSide(color: C.brown, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (v) => setState(() => remember = v ?? false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('Ingat saya', style: t(13))),
            InkWell(
              onTap: () => go(context, const ForgotScreen()),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Lupa kata sandi?', style: t(13, color: C.brown, w: FontWeight.w600)),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Btn('Masuk', _login, large: true),
        ],
        footer: Center(
          child: InkWell(
            onTap: () => go(context, const RegisterScreen()),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text.rich(TextSpan(style: t(13, color: C.brown), children: [
                const TextSpan(text: 'Belum punya akun? '),
                TextSpan(text: 'Daftar', style: t(13, color: C.brown, w: FontWeight.w800)),
              ])),
            ),
          ),
        ),
      );
}

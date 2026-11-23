import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../auth/login_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Live((context, s) => Screen(title: 'Akun', children: [
        Box(
          child: Row(children: [
            CircleAvatar(
              backgroundColor: C.brown,
              child: Text(s.userName.isEmpty ? '?' : s.userName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.userName, style: t(14, w: FontWeight.w800)),
                Text(s.userEmail, style: t(11, color: C.muted), overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
        Box(
          onTap: () => go(context, const HistoryScreen()),
          child: Row(children: [
            Expanded(child: Text('Riwayat pesanan', style: t(13))),
            const Icon(Icons.chevron_right, color: C.muted),
          ]),
        ),
        const SizedBox(height: 8),
        Btn('Keluar', () => goReplaceAll(context, const LoginScreen()), light: true),
      ]));
}

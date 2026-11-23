import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../auth/login_screen.dart';
import 'report_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Live((context, s) => Screen(title: 'Akun admin', children: [
        Box(
          child: Row(children: [
            const CircleAvatar(backgroundColor: C.brown, child: Text('A', style: TextStyle(color: Colors.white))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Admin', style: t(14, w: FontWeight.w800)),
                Text(s.userEmail, style: t(11, color: C.muted), overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
        Box(
          onTap: () => go(context, const ReportScreen()),
          child: Row(children: [
            Expanded(child: Text('Laporan keuangan', style: t(13))),
            const Icon(Icons.chevron_right, color: C.muted),
          ]),
        ),
        const SizedBox(height: 8),
        Btn('Keluar', () => goReplaceAll(context, const LoginScreen()), light: true),
      ]));
}

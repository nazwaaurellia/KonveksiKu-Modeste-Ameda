import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../auth/login_screen.dart';
import 'chat_screen.dart';
import 'edit_profile_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _row(IconData? icon, String title, String sub, VoidCallback onTap, {Widget? lead, int? badge, bool last = false}) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: C.sand))),
          child: Row(children: [
            SizedBox(width: 26, child: Center(child: lead ?? Icon(icon, size: 22, color: C.brown))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: t(14, w: FontWeight.w700)),
                const SizedBox(height: 1),
                Text(sub, style: t(12, color: C.muted)),
              ]),
            ),
            if (badge != null && badge > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF1DFB5), borderRadius: BorderRadius.circular(10)),
                child: Text('$badge', style: t(11, color: C.brown, w: FontWeight.w800)),
              ),
            const Icon(Icons.chevron_right, color: C.ink),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Live((context, s) {
        return Screen(title: 'Akun', back: true, children: [
          Box(
            child: Row(children: [
              UserAvatar(radius: 24, name: s.userName),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.userName, style: t(15, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(s.userEmail, style: t(12, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
              OutlinedButton(
                onPressed: () => go(context, const EditProfileScreen()),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: C.brown),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: Text('Edit', style: t(13, color: C.brown, w: FontWeight.w700)),
              ),
            ]),
          ),
          const Label('Pesanan'),
          Box(
            child: Column(children: [
              _row(Icons.history, 'Riwayat pesanan', 'Pesanan yang sudah selesai', () => go(context, const HistoryScreen()), last: true),
            ]),
          ),
          const Label('Bantuan'),
          Box(
            child: _row(null, 'Chat admin', 'Online', () => go(context, ChatScreen(order: s.activeMine)), lead: const ChatIcon(size: 22), last: true),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                goReplaceAll(context, const LoginScreen());
              },
              icon: const Icon(Icons.logout, size: 18, color: C.brown),
              label: Text('Keluar', style: t(14, color: C.brown, w: FontWeight.w700)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: C.brown), shape: const StadiumBorder()),
            ),
          ),
        ]);
      });
}

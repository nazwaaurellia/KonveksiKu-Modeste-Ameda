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

  /// Satu menu: kartu terpisah dengan ikon bulat, teks, dan jarak yang lega.
  Widget _tile(Widget icon, String title, String sub, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 14),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: C.ink.withOpacity(.05)),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Color(0xFFF6EBD2), shape: BoxShape.circle),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: t(14, w: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(sub, style: t(12, color: C.muted)),
                  ]),
                ),
                const Icon(Icons.chevron_right, color: C.muted, size: 22),
              ]),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Live((context, s) => Screen(title: 'Akun', back: true, children: [
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
        _tile(const Icon(Icons.history, size: 20, color: C.brown), 'Riwayat pesanan', 'Pesanan yang sudah selesai',
            () => go(context, const HistoryScreen())),
        const Label('Bantuan'),
        _tile(const ChatIcon(size: 20), 'Chat admin', 'Online', () => go(context, ChatScreen(order: s.activeMine))),
        const SizedBox(height: 10),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => goReplaceAll(context, const LoginScreen()),
                icon: const Icon(Icons.logout, size: 19, color: C.red),
                label: Text('Keluar', style: t(13.5, color: C.red, w: FontWeight.w600)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: C.red, width: 1.2), shape: const StadiumBorder()),
              ),
            ),
          ),
        ),
      ]));
}

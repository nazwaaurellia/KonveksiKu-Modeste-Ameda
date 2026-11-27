import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/order_ui.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../auth/login_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'track_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _photo(BuildContext context) async {
    final f = await pickFile(image: true);
    if (f?.bytes != null) {
      kAvatar.value = f!.bytes;
      if (context.mounted) toast(context, 'Foto profil diperbarui');
    }
  }

  Future<void> _rename(BuildContext context, AppStore s) async {
    final v = await askText(context, 'Ubah nama', 'Nama lengkap', initial: s.userName);
    if (v != null && v.isNotEmpty) {
      s.rename(v);
      if (context.mounted) toast(context, 'Nama diperbarui');
    }
  }

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
        final running = s.mine.where((o) => !o.isDone).length;
        return Screen(title: 'Akun', back: true, children: [
          Box(
            child: Row(children: [
              GestureDetector(
                onTap: () => _photo(context),
                child: Stack(clipBehavior: Clip.none, children: [
                  UserAvatar(radius: 34, name: s.userName),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE6D7B5)),
                      ),
                      child: const Icon(Icons.photo_camera_outlined, size: 15, color: C.brown),
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Flexible(child: Text(s.userName, style: t(17, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    IconButton(
                      onPressed: () => _rename(context, s),
                      tooltip: 'Ubah nama',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.edit_outlined, size: 18, color: C.brown),
                    ),
                  ]),
                  Text(s.userEmail, style: t(12.5, color: C.muted)),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () => _photo(context),
                    child: Text('Ganti foto', style: t(12, color: C.brown, w: FontWeight.w700)),
                  ),
                ]),
              ),
            ]),
          ),
          const Label('Pesanan'),
          Box(
            child: Column(children: [
              _row(Icons.place_outlined, 'Pesanan berjalan', 'Lihat status terbaru', () => go(context, const TrackScreen(back: true)), badge: running),
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

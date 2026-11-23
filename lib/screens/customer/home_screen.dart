import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step1_screen.dart';
import 'track_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _start(BuildContext context, String service) {
    AppStore.I.draft = OrderDraft()..service = service;
    go(context, const NewOrderStep1Screen());
  }

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = s.activeMine;
        return Screen(children: [
          Row(children: [
            Expanded(child: Text('Selamat siang, ${s.userName}', style: t(12, color: C.muted))),
            CircleAvatar(
              radius: 16,
              backgroundColor: C.gold,
              child: Text(s.userName.isEmpty ? '?' : s.userName[0].toUpperCase(), style: t(12, w: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 4),
          Text('Mau pesan apa hari ini?', style: h(26)),
          const SizedBox(height: 14),
          if (o != null)
            Box(
              color: C.sand,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(
                    backgroundColor: C.brown,
                    child: Text('${(o.progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(o.title, style: t(15, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('#${o.id} · ${o.label}', style: t(10, color: C.muted)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 10),
                Text('${o.step} dari 6 tahap selesai', style: t(10, color: C.muted)),
                const SizedBox(height: 8),
                SizedBox(width: 170, child: Btn('Lacak pesanan ›', () => go(context, TrackScreen(order: o)))),
              ]),
            )
          else
            Box(color: C.sand, child: Text('Belum ada pesanan aktif. Pilih layanan di bawah untuk mulai.', style: t(12))),
          const Label('Pilih layanan'),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _ServiceCard('Jahit Baju', 'Jahit sesuai ukuranmu', Icons.checkroom, C.green, () => _start(context, 'Jahit Baju'))),
            const SizedBox(width: 12),
            Expanded(child: _ServiceCard('Bordir', 'Logo dan nama di atas kain', Icons.workspace_premium, C.red, () => _start(context, 'Bordir Saja'))),
          ]),
        ]);
      });
}

class _ServiceCard extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;
  const _ServiceCard(this.title, this.sub, this.icon, this.tint, this.onTap);
  @override
  Widget build(BuildContext context) => Box(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(color: tint.withOpacity(.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 40, color: tint),
          ),
          const SizedBox(height: 8),
          Text(title, style: t(14, w: FontWeight.w800)),
          Text(sub, style: t(10, color: C.muted)),
          const SizedBox(height: 8),
          Btn('Pesan', onTap),
        ]),
      );
}

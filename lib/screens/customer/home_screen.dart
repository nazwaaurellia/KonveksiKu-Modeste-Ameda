import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step1_screen.dart';
import 'services.dart';
import 'track_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _start(BuildContext context, ServiceInfo s) {
    s.startDraft();
    go(context, const NewOrderStep1Screen());
  }

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = s.activeMine;
        return Screen(children: [
          Row(children: [
            Expanded(child: Text('Selamat siang, ${s.userName}', style: t(14, color: C.muted))),
            CircleAvatar(
              radius: 20,
              backgroundColor: C.gold,
              child: Text(s.userName.isEmpty ? '?' : s.userName[0].toUpperCase(), style: t(16, w: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 2),
          Text('Mau pesan apa hari ini?', style: h(26)),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: C.ink.withOpacity(.07)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: C.brown,
                  child: o == null
                      ? const Icon(Icons.view_in_ar_outlined, color: Colors.white, size: 26)
                      : Text('${(o.progress * 100).round()}%',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(o == null ? 'Belum ada pesanan' : o.title,
                        style: t(17.5, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(o == null ? 'Pesanan kamu akan muncul di sini' : '#${o.id} · ${o.label} · ${o.step} dari 6 tahap',
                        style: t(12, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ]),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => go(context, TrackScreen(order: o, back: true)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.brown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Lacak pesanan', style: t(15, color: Colors.white, w: FontWeight.w800)),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 20, color: Colors.white),
                  ]),
                ),
              ),
            ]),
          ),
          const Label('Pilih layanan'),
          // Dua kartu per baris; tinggi kartu disamakan.
          for (var i = 0; i < kPesanServices.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: IntrinsicHeight(
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Expanded(child: _ServiceCard(kPesanServices[i], () => _start(context, kPesanServices[i]))),
                  const SizedBox(width: 14),
                  Expanded(
                    child: i + 1 < kPesanServices.length
                        ? _ServiceCard(kPesanServices[i + 1], () => _start(context, kPesanServices[i + 1]))
                        : const SizedBox(),
                  ),
                ]),
              ),
            ),
        ]);
      });
}

class _ServiceCard extends StatelessWidget {
  final ServiceInfo s;
  final VoidCallback onTap;
  const _ServiceCard(this.s, this.onTap);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 14, offset: Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ServiceImage(s),
          const SizedBox(height: 12),
          Text(s.title, style: t(16, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Expanded(
            child: Text(s.sub, style: t(12, color: C.muted).copyWith(height: 1.45), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 10),
          Btn('Pesan', onTap, compact: true),
        ]),
      );
}

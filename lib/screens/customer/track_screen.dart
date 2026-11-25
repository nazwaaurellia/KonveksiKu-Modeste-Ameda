import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'payment_screen.dart';

/// Lacak pesanan. Dipakai sebagai tab (menampilkan pesanan aktif) atau
/// dibuka untuk pesanan tertentu lewat [order].
class TrackScreen extends StatelessWidget {
  final Order? order;
  final bool back;
  const TrackScreen({this.order, this.back = false, super.key});

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = order ?? s.activeMine ?? (s.mine.isEmpty ? null : s.mine.first);
        if (o == null) {
          return Screen(title: 'Lacak Pesanan', centerTitle: true, back: back, children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
            Center(
              child: Container(
                width: 132,
                height: 132,
                decoration: const BoxDecoration(color: Color(0xFFF1E4C8), shape: BoxShape.circle),
                child: const Icon(Icons.view_in_ar_outlined, size: 52, color: C.brown),
              ),
            ),
            const SizedBox(height: 22),
            Text('Belum ada pesanan', textAlign: TextAlign.center, style: h(21)),
            const SizedBox(height: 8),
            Text('Setelah kamu memesan, status pesananmu\nakan muncul di sini.',
                textAlign: TextAlign.center, style: t(13, color: C.muted).copyWith(height: 1.5)),
          ]);
        }
        return Screen(
          title: 'Lacak pesanan',
          back: back || order != null,
          action: Tag(o.label),
          bottom: o.status == St.menungguDp
              ? Btn('Bayar DP ${rp(o.dp)}', () => go(context, PaymentScreen(order: o)))
              : Btn('Chat admin', () => toast(context, 'Chat admin belum tersedia di versi demo')),
          children: [
            Text(o.title, style: h(18)),
            Text('#${o.id} · ${o.qty} pcs · dibuat ${o.created}', style: t(10, color: C.muted)),
            const SizedBox(height: 12),
            Timeline(o.timeline, o.step),
            if (o.revisi)
              Box(color: const Color(0xFFFBE3DF), child: Text('Admin meminta revisi desain. Hubungi admin lewat chat.', style: t(12))),
            Box(
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: t(11, color: C.muted)),
                  Text(rp(o.total), style: t(11)),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('DP dibayar', style: t(11, color: C.muted)),
                  Text(rp(o.dpPaid), style: t(11)),
                ]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Sisa tagihan', style: t(13, w: FontWeight.w700)),
                  Text(rp(o.remaining), style: h(15, o.remaining > 0 ? C.red : C.green)),
                ]),
              ]),
            ),
            if (o.status == St.dibordir)
              Box(
                child: Row(children: [
                  Expanded(child: Text('Foto progress\nDikirim operator ${o.operator}', style: t(11))),
                  const Tag('Lihat'),
                ]),
              ),
          ],
        );
      });
}

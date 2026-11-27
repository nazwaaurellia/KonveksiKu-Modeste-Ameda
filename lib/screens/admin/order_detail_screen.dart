import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'design_review_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({required this.order, super.key});

  Widget? _action(BuildContext context, AppStore s, Order o) {
    void done(String msg, VoidCallback f) {
      f();
      toast(context, msg);
      Navigator.pop(context);
    }

    switch (o.status) {
      case St.menungguDp:
        return null;
      case St.menungguVerifikasi:
        return Btn('Verifikasi DP ${rp(o.dp)}', () => done('DP terverifikasi', () => s.verifyDp(o)));
      case St.menungguDesain:
        return Btn('Review desain', () => go(context, DesignReviewScreen(order: o)));
      case St.dibordir:
        final more = o.prodStage < o.prodSteps.length - 1;
        return Btn(more ? 'Lanjut: ${o.prodSteps[o.prodStage + 1]}' : 'Tandai selesai',
            () => done(more ? 'Pesanan masuk tahap ${o.prodSteps[o.prodStage + 1]}' : 'Pesanan selesai', () => s.advanceStage(o)));
      case St.selesai:
        return Btn('Tandai diambil & lunas', () => done('Pesanan diambil, pembayaran lunas', () => s.markPickedUp(o)));
      case St.diambil:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = order;
        return Screen(
          title: o.title,
          back: true,
          action: Tag(o.label),
          bottom: _action(context, s, o),
          children: [
            Text('#${o.id} · ${o.customer} · ${o.qty} pcs', style: t(10, color: C.muted)),
            const SizedBox(height: 10),
            Timeline(o.timeline, o.step),
            Box(
              child: Column(children: [
                _row('Layanan', o.service),
                _row('Kain', o.fabric),
                _row('Warna', o.colors),
                _row('Ukuran bordir', o.bsize),
                _row('Operator', o.operator),
              ]),
            ),
            Box(
              child: Column(children: [
                _row('Total', rp(o.total)),
                _row('DP dibayar', rp(o.dpPaid)),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Sisa tagihan', style: t(13, w: FontWeight.w700)),
                  Text(rp(o.remaining), style: h(16)),
                ]),
              ]),
            ),
          ],
        );
      });

  Widget _row(String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(child: Text(a, style: t(11, color: C.muted))),
          Flexible(child: Text(b, style: t(11, w: FontWeight.w700), textAlign: TextAlign.right)),
        ]),
      );
}

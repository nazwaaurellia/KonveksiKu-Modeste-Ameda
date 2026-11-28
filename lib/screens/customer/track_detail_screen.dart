import 'package:flutter/material.dart';
import '../../core/order_ui.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'chat_screen.dart';
import 'invoice_screen.dart';
import 'payment_screen.dart';

/// Detail satu pesanan: progres, tahapan, ringkasan pembayaran.
class TrackDetailScreen extends StatelessWidget {
  final Order order;
  const TrackDetailScreen(this.order, {super.key});

  String _estimate(Order o) {
    final p = o.created.split(' ');
    final m = p.length == 2 ? kMonths.indexOf(p[1]) : -1;
    final d = int.tryParse(p.first);
    if (m < 0 || d == null) return '-';
    final e = DateTime(DateTime.now().year, m + 1, d).add(const Duration(days: 8));
    return '${e.day} ${kMonths[e.month - 1]}';
  }

  Widget _step(BuildContext context, Order o, int i) {
    final cur = i == o.step && o.status != St.diambil;
    final photo = cur && o.status == St.dibordir; // foto progress ikut tahap produksi yang aktif
    final last = o.stepCount - 1;
    final done = i < o.step;
    final info = o.timeline[i][1];
    final est = _estimate(o);
    final circle = Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? C.green : (cur ? Colors.white : Colors.transparent),
        border: done ? null : Border.all(color: cur ? C.brown : const Color(0xFFD9C9A3), width: 2.5),
      ),
      child: done
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : (cur ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: C.brown, shape: BoxShape.circle))) : null),
    );
    final body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(o.steps[i], style: t(15, w: (done || cur) ? FontWeight.w800 : FontWeight.w500, color: (done || cur) ? C.ink : C.muted)),
      if (info.isNotEmpty || photo)
        Text(photo ? 'Sedang berjalan · estimasi $est' : info, style: t(12, color: C.muted)),
      if (photo) ...[
        const SizedBox(height: 12),
        Row(children: [
          for (var k = 0; k < 3; k++)
            Expanded(
              child: Container(
                height: 72,
                margin: EdgeInsets.only(right: k < 2 ? 10 : 0),
                decoration: BoxDecoration(color: const Color(0xFFEBDDBC), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.image_outlined, color: C.brown),
              ),
            ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: Text('Foto progress · dikirim operator ${o.operator}', style: t(12, color: C.muted))),
          const SizedBox(width: 8),
          OutChip('Lihat semua', () => toast(context, 'Belum ada foto lainnya')),
        ]),
      ],
    ]);
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Column(children: [
          circle,
          if (i < last) Expanded(child: Container(width: 3, color: i < o.step ? C.green : const Color(0xFFE6D7B5))),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: i < last ? 14 : 0),
            child: body,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = order;
        final ready = o.dpPaid > 0 && o.remaining > 0;
        return Screen(
          title: 'Lacak pesanan',
          back: true,
          action: Tag(o.label, o.isDone ? C.green : C.gold),
          bottom: Column(mainAxisSize: MainAxisSize.min, children: [
            if (o.status == St.menungguDp)
              Btn('Bayar DP', () => go(context, PaymentScreen(order: o)))
            else if (ready)
              Btn('Bayar sisa', () => go(context, PaymentScreen(order: o, remainder: true))),
            HelpLink(order: o),
          ]),
          children: [
            Text(o.title, style: h(24)),
            const SizedBox(height: 4),
            Text('#${o.id} · ${o.qty} pcs · dibuat ${o.created}', style: t(12.5, color: C.muted)),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: Text('${o.step} dari ${o.stepCount} tahap selesai', style: t(12.5, w: FontWeight.w800))),
              Text('Estimasi ${_estimate(o)}', style: t(12.5, color: C.brown, w: FontWeight.w800)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: o.progress, minHeight: 7, color: C.green, backgroundColor: C.sand),
            ),
            const SizedBox(height: 16),
            Box(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [for (var i = 0; i < o.stepCount; i++) _step(context, o, i)]),
              ),
            ),
            Box(
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Total', style: t(13.5)),
                  Text(rp(o.total), style: t(13.5)),
                ]),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('DP dibayar', style: t(13.5)),
                  Text(rp(o.dpPaid), style: t(13.5)),
                ]),
                Divider(height: 24, color: C.sand),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sisa tagihan', style: t(13.5, w: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Tag(o.remaining == 0 ? 'Lunas' : 'Belum lunas', o.remaining == 0 ? C.green : C.gold),
                    ]),
                  ),
                  Text(rp(o.remaining), style: h(24)),
                ]),
                Divider(height: 24, color: C.sand),
                InkWell(
                  onTap: () => go(context, InvoiceScreen(o)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(children: [
                      const Icon(Icons.description_outlined, size: 20, color: C.brown),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Lihat invoice', style: t(14, w: FontWeight.w700))),
                      const Icon(Icons.chevron_right, color: C.ink),
                    ]),
                  ),
                ),
              ]),
            ),
          ],
        );
      });
}

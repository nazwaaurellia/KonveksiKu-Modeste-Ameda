import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class DesignReviewScreen extends StatelessWidget {
  final Order order;
  const DesignReviewScreen({required this.order, super.key});

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final o = order;
        return Screen(
          title: o.title,
          back: true,
          action: Tag(o.revisi ? 'Perlu revisi' : 'Menunggu desain', C.red),
          bottom: Row(children: [
            Expanded(
              child: Btn('Minta revisi', () {
                s.requestRevision(o);
                toast(context, 'Permintaan revisi dikirim ke pelanggan');
                Navigator.pop(context);
              }, light: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Btn('Setujui desain', () {
                s.approveDesign(o);
                toast(context, 'Desain disetujui. Pesanan masuk tahap bordir.');
                Navigator.pop(context);
              }),
            ),
          ]),
          children: [
            Text('#${o.id} · ${o.customer} · ${o.qty} pcs', style: t(10, color: C.muted)),
            const SizedBox(height: 10),
            Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Label('Spesifikasi'),
                for (final r in [
                  ['Layanan', o.service],
                  ['Produk', o.product],
                  ['Kain', o.fabric],
                  ['Warna', o.colors],
                  ['Ukuran baju', o.size],
                  ['Ukuran bordir', o.bsize],
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Expanded(child: Text(r[0], style: t(11, color: C.muted))),
                      Flexible(child: Text(r[1], style: t(11, w: FontWeight.w700), textAlign: TextAlign.right)),
                    ]),
                  ),
              ]),
            ),
            Box(
              child: Row(children: [
                const Icon(Icons.image_outlined, color: C.brown),
                const SizedBox(width: 10),
                Expanded(child: Text(o.hasDesign ? 'File desain\nlogo.png · diunggah ${o.created}' : 'Belum ada file desain', style: t(11))),
                if (o.hasDesign) const Tag('Lihat'),
              ]),
            ),
            Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Label('Catatan pelanggan'),
                Text(o.note.isEmpty ? '-' : o.note, style: t(12)),
              ]),
            ),
          ],
        );
      });
}

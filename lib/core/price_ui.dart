import 'package:flutter/material.dart';
import 'store.dart';
import 'theme.dart';
import 'widgets.dart';

/// Satu baris rincian harga (per pcs).
class PriceLine {
  final String label, sub;
  final int unit;
  final Color color;
  const PriceLine(this.label, this.sub, this.unit, this.color);
}

/// Rincian dari isian form. Baris Bahan hilang jika pelanggan membawa bahan sendiri.
List<PriceLine> draftLines(OrderDraft d) => [
      if (d.bahanUnit > 0) PriceLine('Bahan', '${d.fabric} · ${d.meterText}', d.bahanUnit, C.green),
      if (d.jahitUnit > 0) PriceLine(d.kind == 'jahit' ? 'Ongkos jahit' : 'Ongkos produksi', d.product, d.jahitUnit, C.brown),
      if (d.bordirUnit > 0) PriceLine('Bordir', '${d.positions.join(', ')} · ${d.bsize}', d.bordirUnit, C.gold),
    ];

/// Rincian dari pesanan yang sudah dibuat (dipakai di admin dan halaman pelanggan).
List<PriceLine> orderLines(Order o) {
  final l = [
    if (o.bahanUnit > 0) PriceLine('Bahan', o.bahanSub, o.bahanUnit, C.green),
    if (o.jahitUnit > 0) PriceLine(o.kind == 'jahit' ? 'Ongkos jahit' : 'Ongkos produksi', o.jahitSub, o.jahitUnit, C.brown),
    if (o.bordirUnit > 0) PriceLine('Bordir', o.bordirSub, o.bordirUnit, C.gold),
  ];
  return l.isEmpty ? [PriceLine('Harga satuan', o.title, o.unit, C.brown)] : l;
}

/// Tautan "Lihat rincian harga ›".
class PriceLink extends StatelessWidget {
  final VoidCallback onTap;
  const PriceLink(this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Lihat rincian harga', style: t(13, color: C.brown, w: FontWeight.w700)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 18, color: C.brown),
            ]),
          ),
        ),
      );
}

void showPriceSheet(BuildContext context,
    {required String subtitle, required List<PriceLine> lines, required int qty, required int dp}) {
  final total = lines.fold<int>(0, (a, l) => a + l.unit) * qty;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: C.cream,
    constraints: const BoxConstraints(maxWidth: 520),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('Rincian harga', style: h(22))),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close), visualDensity: VisualDensity.compact),
          ]),
          Text(subtitle, style: t(12.5, color: C.muted)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(children: [
              for (final l in lines) Expanded(flex: l.unit <= 0 ? 1 : l.unit, child: Container(height: 8, color: l.color)),
            ]),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 16, runSpacing: 6, children: [
            for (final l in lines)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 9, height: 9, decoration: BoxDecoration(color: l.color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(l.label, style: t(12, color: C.muted)),
              ]),
          ]),
          const SizedBox(height: 16),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.label, style: t(15, w: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(l.sub, style: t(12, color: C.muted)),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(rp(l.unit * qty), style: t(15, w: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('${rp(l.unit)} / pcs', style: t(12, color: C.muted)),
                ]),
              ]),
            ),
          Divider(height: 26, color: C.sand),
          Row(children: [
            Expanded(child: Text('Total', style: t(15, w: FontWeight.w800))),
            Text(rp(total), style: h(26)),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(child: Text('DP 50% dibayar sekarang', style: t(13, color: C.muted))),
            Text(rp(dp), style: t(15, color: C.brown, w: FontWeight.w800)),
          ]),
        ]),
      ),
    ),
  );
}

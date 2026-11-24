import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final w = s.weekly;
        final mx = w.fold<int>(1, (a, b) => b > a ? b : a);
        final pending = s.pendingVerify;
        return Screen(title: 'Laporan keuangan', back: true, action: const Tag('Nov 2026'), children: [
          Row(children: [
            Expanded(
              child: Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pemasukan', style: t(11, color: C.muted)),
                  FittedBox(fit: BoxFit.scaleDown, child: Text(jt(s.income), style: t(14, w: FontWeight.w700, color: C.green))),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Box(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Sisa tagihan', style: t(11, color: C.muted)),
                  FittedBox(fit: BoxFit.scaleDown, child: Text(jt(s.receivable), style: t(14, w: FontWeight.w700, color: C.red))),
                ]),
              ),
            ),
          ]),
          Box(
            child: SizedBox(
              height: 120,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for (var i = 0; i < 4; i++)
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        height: 4 + 86 * (w[i] / mx),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(color: i == 3 ? C.gold : C.brown, borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(height: 4),
                      Text('M${i + 1}', style: t(10, color: C.muted)),
                    ]),
                  ),
              ]),
            ),
          ),
          const Label('Menunggu verifikasi'),
          if (pending.isEmpty) Text('Tidak ada DP yang menunggu verifikasi.', style: t(12, color: C.muted)),
          for (final o in pending)
            Box(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o.customer, style: t(13, w: FontWeight.w700)),
                Text('DP #${o.id} · ${rp(o.dp)}', style: t(10, color: C.muted)),
                const SizedBox(height: 10),
                Btn('Verifikasi', () {
                  s.verifyDp(o);
                  toast(context, 'DP ${o.id} terverifikasi');
                }, compact: true),
              ]),
            ),
        ]);
      });
}

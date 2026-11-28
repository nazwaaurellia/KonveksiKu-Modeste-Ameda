import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/invoice_pdf.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

/// Invoice satu pesanan, bisa diunduh sebagai PDF, dicetak, atau dibagikan.
class InvoiceScreen extends StatelessWidget {
  final Order order;
  const InvoiceScreen(this.order, {super.key});

  String get _email => AppStore.I.userName == order.customer ? AppStore.I.userEmail : '';
  String get _file => 'Invoice-${order.id}.pdf';

  Future<void> _run(BuildContext context, Future<void> Function(Uint8List) job) async {
    try {
      await job(await buildInvoicePdf(order, _email));
    } catch (_) {
      if (context.mounted) toast(context, 'Gagal memproses invoice');
    }
  }

  Widget _kv(String a, String b, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(a, style: t(13, color: C.muted)),
          Flexible(child: Text(b, style: t(13, w: bold ? FontWeight.w800 : FontWeight.w500, color: bold ? C.ink : C.muted), textAlign: TextAlign.right)),
        ]),
      );

  Widget _div() => Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: C.sand));
  Widget _cap(String x) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(x, style: t(11, color: C.brown, w: FontWeight.w800).copyWith(letterSpacing: 1.2)),
      );

  @override
  Widget build(BuildContext context) {
    final i = InvoiceInfo.of(order, _email);
    final ok = i.status == 'Lunas';
    return Screen(
      title: 'Invoice',
      back: true,
      action: Tag(i.status, ok ? C.green : C.gold),
      bottom: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => _run(context, (b) async {
                final done = await saveBytes(_file, b, mime: 'application/pdf');
                if (context.mounted) toast(context, done ? 'Invoice diunduh' : 'Invoice gagal disimpan');
              }),
              icon: const Icon(Icons.file_download_outlined, size: 20),
              label: Text('Unduh PDF', style: t(14, color: Colors.white, w: FontWeight.w700)),
              style: ElevatedButton.styleFrom(backgroundColor: C.brown, foregroundColor: Colors.white, elevation: 0, shape: const StadiumBorder()),
            ),
          ),
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: C.ink.withOpacity(.05)),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 14, offset: Offset(0, 4))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ClipOval(
                child: Image.asset('assets/images/logo_mark.png', width: 46, height: 46, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(width: 46, height: 46)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Modeste Ameda', style: t(17, w: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('Bordir, jahit, dan perlengkapan seragam', style: t(12, color: C.muted)),
                ]),
              ),
              Text('INVOICE', style: t(12, color: C.brown, w: FontWeight.w800).copyWith(letterSpacing: 1.4)),
            ]),
            _div(),
            _kv('No. invoice', i.number, bold: true),
            _kv('Tanggal', i.date),
            _kv('No. pesanan', i.orderNo),
            _div(),
            _cap('DITAGIHKAN KEPADA'),
            Text(i.customer, style: t(15, w: FontWeight.w800)),
            if (i.email.isNotEmpty) Text(i.email, style: t(12.5, color: C.muted)),
            _div(),
            _cap('RINCIAN PESANAN'),
            Text(i.item, style: t(15, w: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(i.detail, style: t(12.5, color: C.muted)),
            const SizedBox(height: 8),
            for (final l in i.lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.sub.isEmpty ? l.label : '${l.label} · ${l.sub}', style: t(13, w: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(l.qty, style: t(12, color: C.muted)),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Text(rp(l.amount), style: t(13, w: FontWeight.w800)),
                ]),
              ),
            _div(),
            _kv('Total', rp(i.total), bold: true),
            if (i.dpPaid > 0) _kv('DP dibayar · ${order.created}', '− ${rp(i.dpPaid)}'),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Text('Sisa tagihan', style: t(14, w: FontWeight.w800))),
              Text(rp(i.remaining), style: h(26)),
            ]),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFBEFD5), borderRadius: BorderRadius.circular(14)),
              child: Text.rich(TextSpan(style: t(13).copyWith(height: 1.45), children: [
                const TextSpan(text: 'Bayar sisa tagihan ke '),
                TextSpan(text: kBankLine, style: t(13, w: FontWeight.w800)),
                const TextSpan(text: ' a.n. $kBankHolder.'),
              ])),
            ),
            const SizedBox(height: 16),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Center(child: Text('Terima kasih telah memesan.', style: t(12, color: C.muted)))),
              _Stamp(i.status, i.date, ok ? C.green : C.brown),
            ]),
          ]),
        ),
      ],
    );
  }
}

/// Stempel bundar "Modeste Ameda" dengan status pembayaran.
class _Stamp extends StatelessWidget {
  final String status, date;
  final Color color;
  const _Stamp(this.status, this.date, this.color);
  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: -0.2,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2.2)),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: .8)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('MODESTE AMEDA', style: TextStyle(fontSize: 7.5, color: color, fontWeight: FontWeight.w800, letterSpacing: .6)),
              const SizedBox(height: 4),
              Text(status.toUpperCase(), style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(date, style: TextStyle(fontSize: 7.5, color: color)),
            ]),
          ),
        ),
      );
}

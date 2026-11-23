import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'customer_shell.dart';

/// Pembayaran DP. Jika [order] diisi, pelanggan membayar DP untuk pesanan yang sudah ada.
class PaymentScreen extends StatefulWidget {
  final Order? order;
  const PaymentScreen({this.order, super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'Transfer bank';
  bool attached = false;

  void _send() {
    if (!attached) return toast(context, 'Unggah bukti transfer dulu');
    final s = AppStore.I;
    if (widget.order != null) {
      s.sendProof(widget.order!);
    } else {
      s.submitDraft(proof: true);
    }
    toast(context, 'Bukti terkirim. Admin akan memverifikasi.');
    goReplaceAll(context, const CustomerShell(initial: 2));
  }

  void _later() {
    AppStore.I.submitDraft(proof: false);
    toast(context, 'Pesanan dibuat. Bayar DP kapan saja dari menu Lacak.');
    goReplaceAll(context, const CustomerShell(initial: 2));
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final d = AppStore.I.draft;
    final title = o?.title ?? d.product;
    final qty = o?.qty ?? d.qty;
    final total = o?.total ?? d.total;
    final dp = o?.dp ?? d.dp;
    return Screen(
      title: 'Pembayaran DP',
      back: true,
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        Btn('Kirim bukti pembayaran', _send),
        if (o == null) ...[
          const SizedBox(height: 8),
          Btn('Bayar nanti', _later, light: true),
        ],
      ]),
      children: [
        Box(
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text('$title × $qty', style: t(12, color: C.muted))),
              Text(rp(total), style: t(12)),
            ]),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('DP 50%', style: t(14, w: FontWeight.w800)),
              Text(rp(dp), style: h(18, C.red)),
            ]),
          ]),
        ),
        const Label('Metode pembayaran'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final x in ['Transfer bank', 'QRIS', 'E-wallet']) Choice(x, method == x, () => setState(() => method = x)),
        ]),
        const SizedBox(height: 12),
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Transfer ke', style: t(10, color: C.muted)),
            Text('BCA 1234 5678 90', style: h(18)),
            Text('a.n. Konveksi Maju Jaya', style: t(11, color: C.muted)),
          ]),
        ),
        Box(
          onTap: () => setState(() => attached = !attached),
          child: Center(
            child: Text(
              attached ? '✓ bukti-transfer.jpg dilampirkan' : 'Unggah bukti transfer\nAdmin memverifikasi maksimal 1 jam',
              textAlign: TextAlign.center,
              style: t(11, color: attached ? C.green : C.muted),
            ),
          ),
        ),
      ],
    );
  }
}

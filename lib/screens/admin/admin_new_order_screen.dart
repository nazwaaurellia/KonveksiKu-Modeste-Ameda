import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class AdminNewOrderScreen extends StatefulWidget {
  const AdminNewOrderScreen({super.key});
  @override
  State<AdminNewOrderScreen> createState() => _AdminNewOrderScreenState();
}

class _AdminNewOrderScreenState extends State<AdminNewOrderScreen> {
  final name = TextEditingController();
  String product = 'Seragam', bsize = '8 cm';
  int qty = 48;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = kBordir[bsize] ?? 0;
    final total = unit * qty;
    return Screen(
      title: 'Pesanan baru',
      back: true,
      bottom: Btn('Simpan pesanan', () {
        if (name.text.trim().isEmpty) return toast(context, 'Nama pelanggan wajib diisi');
        AppStore.I.addAdminOrder(customer: name.text.trim(), product: product, bsize: bsize, qty: qty);
        toast(context, 'Pesanan disimpan');
        Navigator.pop(context);
      }),
      children: [
        Fld('Nama pelanggan', 'Ibu Sari', ctrl: name),
        const Label('Jenis produk'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final p in ['Seragam', 'Topi', 'Dasi', 'Jaket', 'Tas']) Choice(p, product == p, () => setState(() => product = p)),
        ]),
        const Label('Ukuran bordir'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final s in kBordir.keys) Choice(s, bsize == s, () => setState(() => bsize = s)),
        ]),
        const Label('Jumlah'),
        Counter(qty, (v) => setState(() => qty = v)),
        Box(
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Harga satuan ($bsize)', style: t(11)),
              Text(rp(unit), style: t(11)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total', style: t(14, w: FontWeight.w700)),
              Text(rp(total), style: h(16)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('DP 50% (diterima langsung)', style: t(11, color: C.muted)),
              Text(rp(total ~/ 2), style: t(11, color: C.muted)),
            ]),
          ]),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'payment_screen.dart';

class NewOrderStep2Screen extends StatefulWidget {
  const NewOrderStep2Screen({super.key});
  @override
  State<NewOrderStep2Screen> createState() => _NewOrderStep2ScreenState();
}

class _NewOrderStep2ScreenState extends State<NewOrderStep2Screen> {
  final d = AppStore.I.draft;
  late final note = TextEditingController(text: d.note);

  static const _colors = {
    'Hitam': Colors.black,
    'Kuning': Colors.amber,
    'Merah': Colors.red,
    'Putih': Colors.white,
    'Biru': Colors.indigo,
  };

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Screen(
        title: 'Desain & detail',
        action: Text('Langkah 2 dari 2', style: t(10, color: C.muted)),
        back: true,
        bottom: Row(children: [
          Expanded(
            flex: 4,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('Estimasi total', style: t(10, color: C.muted)),
              FittedBox(fit: BoxFit.scaleDown, child: Text(rp(d.total), style: t(15, w: FontWeight.w700))),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Btn('Lanjut ke pembayaran', () {
              d.note = note.text;
              go(context, const PaymentScreen());
            }),
          ),
        ]),
        children: [
          const Label('Desain'),
          Box(
            onTap: () => setState(() => d.hasDesign = !d.hasDesign),
            child: Center(
              child: Text(
                d.hasDesign ? '✓ logo.png dilampirkan (ketuk untuk batal)' : '⬆ Unggah desain atau logo\nPNG, JPG, atau file desain',
                textAlign: TextAlign.center,
                style: t(12, color: d.hasDesign ? C.green : C.muted),
              ),
            ),
          ),
          Label('Warna barang · ${d.colors.length} dipilih'),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final e in _colors.entries)
              GestureDetector(
                onTap: () => setState(() => d.colors.contains(e.key) ? d.colors.remove(e.key) : d.colors.add(e.key)),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: e.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: d.colors.contains(e.key) ? C.brown : C.sand, width: 3),
                  ),
                ),
              ),
          ]),
          if (d.jahit) ...[
            const Label('Ukuran'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in ['S', 'M', 'L', 'XL', 'XXL']) Choice(s, d.size == s, () => setState(() => d.size = s)),
            ]),
          ],
          if (d.bordir || !d.jahit) ...[
            const Label('Ukuran bordir'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in kBordir.keys) Choice(s, d.bsize == s, () => setState(() => d.bsize = s)),
            ]),
          ],
          const Label('Jumlah'),
          Counter(d.qty, (v) => setState(() => d.qty = v)),
          const SizedBox(height: 8),
          Fld('Catatan', 'Contoh: logo di dada kiri, benang emas.', ctrl: note, lines: 3),
          Box(
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Harga satuan', style: t(11, color: C.muted)),
                Text(rp(d.unit), style: t(11)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('DP 50%', style: t(11, color: C.muted)),
                Text(rp(d.dp), style: t(11)),
              ]),
            ]),
          ),
        ],
      );
}

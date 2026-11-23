import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step2_screen.dart';

class NewOrderStep1Screen extends StatefulWidget {
  const NewOrderStep1Screen({super.key});
  @override
  State<NewOrderStep1Screen> createState() => _NewOrderStep1ScreenState();
}

class _NewOrderStep1ScreenState extends State<NewOrderStep1Screen> {
  final d = AppStore.I.draft;

  @override
  Widget build(BuildContext context) => Screen(
        title: 'Pesanan baru',
        action: Text('Langkah 1 dari 2', style: t(10, color: C.muted)),
        back: true,
        bottom: Btn('Lanjut: desain & detail', () => go(context, const NewOrderStep2Screen())),
        children: [
          Box(
            color: C.sand,
            child: Text('Layanan: ${d.service}', style: t(13, w: FontWeight.w700)),
          ),
          const Label('Jenis produk'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final p in kBase.keys) Choice(p, d.product == p, () => setState(() => d.product = p)),
          ]),
          if (d.jahit) ...[
            const Label('Jenis kain'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final k in ['Katun', 'Drill', 'Polyester', 'Fleece', 'Denim', 'Baby terry'])
                Choice(k, d.fabric == k, () => setState(() => d.fabric = k)),
            ]),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: d.bordir,
              activeColor: C.brown,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('Tambahkan bordir pada baju', style: t(13)),
              onChanged: (v) => setState(() => d.bordir = v ?? false),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Layanan bordir saja: bawa bahanmu sendiri ke toko.', style: t(12, color: C.muted)),
            ),
        ],
      );
}

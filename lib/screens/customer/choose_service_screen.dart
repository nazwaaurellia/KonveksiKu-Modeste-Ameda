import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step1_screen.dart';

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen({super.key});
  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  int sel = 0;
  static const _items = [
    ('Jahit Baju', 'Pilih jenis kain dan ukuran S–XXL', Icons.checkroom, C.green),
    ('Bordir Saja', 'Bawa bahan sendiri, ukuran 5–10 cm', Icons.workspace_premium, C.red),
  ];

  @override
  Widget build(BuildContext context) => Screen(
        title: 'Mau pesan apa?',
        bottom: Btn('Lanjut', () {
          AppStore.I.draft = OrderDraft()..service = _items[sel].$1;
          go(context, const NewOrderStep1Screen());
        }),
        children: [
          Text('Pilih layanan dulu. Detail bahan dan desain diisi di langkah berikutnya.', style: t(11, color: C.muted)),
          const SizedBox(height: 12),
          for (final (i, s) in _items.indexed)
            GestureDetector(
              onTap: () => setState(() => sel = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: sel == i ? C.brown : Colors.transparent, width: 1.5),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 72,
                    width: double.infinity,
                    decoration: BoxDecoration(color: s.$4.withOpacity(.15), borderRadius: BorderRadius.circular(14)),
                    child: Icon(s.$3, size: 32, color: s.$4),
                  ),
                  const SizedBox(height: 8),
                  Text(s.$1, style: t(14, w: FontWeight.w700)),
                  Text(s.$2, style: t(11, color: C.muted)),
                ]),
              ),
            ),
        ],
      );
}

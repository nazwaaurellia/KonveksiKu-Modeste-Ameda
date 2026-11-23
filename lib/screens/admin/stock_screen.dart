import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String cat = 'Benang';

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final items = s.stock.where((e) => e.cat == cat).toList();
        return Screen(title: 'Stok', children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final c in ['Benang', 'Kain', 'Jarum', 'Aksesori']) Choice(c, cat == c, () => setState(() => cat = c)),
          ]),
          const SizedBox(height: 12),
          for (final i in items)
            Box(
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: i.color, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.sand)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(i.name, style: t(14, w: FontWeight.w800), overflow: TextOverflow.ellipsis)),
                      if (i.low) const Tag('Hampir habis', C.red),
                    ]),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(value: i.qty / i.max, color: i.low ? C.red : C.green, backgroundColor: C.sand, minHeight: 5),
                    const SizedBox(height: 4),
                    Text('Sisa ${i.qty} ${i.unit}', style: t(10, color: C.muted)),
                  ]),
                ),
                IconButton(visualDensity: VisualDensity.compact, onPressed: () => s.adjustStock(i, -1), icon: const Icon(Icons.remove_circle_outline)),
                IconButton(visualDensity: VisualDensity.compact, onPressed: () => s.adjustStock(i, 1), icon: const Icon(Icons.add_circle_outline)),
              ]),
            ),
        ]);
      });
}

import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'design_review_screen.dart';
import 'order_detail_screen.dart';

/// Daftar semua pesanan. Dipakai sebagai tab, atau dibuka dari dashboard ([standalone]).
class OrderListScreen extends StatefulWidget {
  final bool standalone;
  final String initialFilter;
  const OrderListScreen({this.standalone = false, this.initialFilter = 'Semua', super.key});
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late String filter = widget.initialFilter;
  String query = '';

  bool _match(Order o) {
    final okFilter = switch (filter) {
      'Baru' => o.status == St.menungguDp || o.status == St.menungguVerifikasi || o.status == St.menungguDesain,
      'Dibordir' => o.status == St.dibordir,
      'Selesai' => o.isDone,
      _ => true,
    };
    final q = query.toLowerCase();
    return okFilter && (q.isEmpty || o.id.toLowerCase().contains(q) || o.title.toLowerCase().contains(q) || o.customer.toLowerCase().contains(q));
  }

  void _open(Order o) => go(context, o.status == St.menungguDesain ? DesignReviewScreen(order: o) : OrderDetailScreen(order: o));

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final list = s.orders.where(_match).toList();
        return Screen(
          title: 'Daftar pesanan',
          back: widget.standalone,
          children: [
            Fld('Cari', 'BK-01 atau nama', onChanged: (v) => setState(() => query = v)),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in ['Semua', 'Baru', 'Dibordir', 'Selesai']) Choice(c, filter == c, () => setState(() => filter = c)),
            ]),
            const SizedBox(height: 12),
            if (list.isEmpty) Text('Tidak ada pesanan.', style: t(12, color: C.muted)),
            for (final o in list) OrderTile(o, admin: true, onTap: () => _open(o)),
          ],
        );
      });
}

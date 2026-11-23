import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'admin_new_order_screen.dart';
import 'order_list_screen.dart';
import 'report_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _quick(BuildContext c, IconData i, String s, Widget to, {int badge = 0}) => Expanded(
        child: Box(
          onTap: () => go(c, to),
          child: Column(children: [
            Badge(isLabelVisible: badge > 0, label: Text('$badge'), child: Icon(i, color: C.brown)),
            const SizedBox(height: 4),
            Text(s, style: t(10, w: FontWeight.w700), textAlign: TextAlign.center),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final low = s.stock.where((e) => e.low).toList();
        return Screen(title: 'Dashboard', children: [
          const Label('Aktivitas'),
          Box(
            child: Row(children: [
              const Icon(Icons.timer_outlined, color: C.brown),
              const SizedBox(width: 10),
              Expanded(
                child: Text('${s.needsAction} pesanan perlu tindakan\n${s.activeCount} pesanan aktif', style: t(12, w: FontWeight.w600)),
              ),
            ]),
          ),
          Box(
            color: C.sand,
            child: Row(children: [
              Expanded(
                child: Text(
                  low.isEmpty
                      ? 'Stok aman'
                      : '${low.first.cat} ${low.first.name.toLowerCase()} hampir habis\nSisa ${low.first.qty} ${low.first.unit}, segera restok.',
                  style: t(12, w: FontWeight.w600),
                ),
              ),
              Icon(low.isEmpty ? Icons.check_circle_outline : Icons.warning_amber_rounded, color: C.brown),
            ]),
          ),
          const Label('Aksi cepat'),
          Row(children: [
            _quick(context, Icons.add, 'Pesanan Baru', const AdminNewOrderScreen()),
            const SizedBox(width: 8),
            _quick(context, Icons.check_circle_outline, 'Verifikasi DP', const ReportScreen(), badge: s.pendingVerify.length),
            const SizedBox(width: 8),
            _quick(context, Icons.bar_chart, 'Laporan', const ReportScreen()),
          ]),
          const Label('Pesanan'),
          Row(children: [
            Expanded(
              child: Box(
                onTap: () => go(context, const OrderListScreen(standalone: true)),
                child: Text('Semua pesanan\n${s.orders.length} pesanan', style: t(12, w: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Box(
                onTap: () => go(context, const OrderListScreen(standalone: true, initialFilter: 'Baru')),
                child: Text('Perlu tindakan\n${s.needsAction} pesanan', style: t(12, w: FontWeight.w700)),
              ),
            ),
          ]),
        ]);
      });
}

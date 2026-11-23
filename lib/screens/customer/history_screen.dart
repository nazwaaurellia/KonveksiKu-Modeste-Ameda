import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'track_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool aktif = true;

  @override
  Widget build(BuildContext context) => Live((context, s) {
        final list = s.mine.where((o) => aktif ? !o.isDone : o.isDone).toList();
        return Screen(
          title: 'Riwayat pesanan',
          back: true,
          children: [
            Row(children: [
              Choice('Aktif', aktif, () => setState(() => aktif = true)),
              const SizedBox(width: 8),
              Choice('Selesai', !aktif, () => setState(() => aktif = false)),
            ]),
            const SizedBox(height: 12),
            if (list.isEmpty) Text('Belum ada pesanan di sini.', style: t(12, color: C.muted)),
            for (final o in list) OrderTile(o, onTap: () => go(context, TrackScreen(order: o))),
          ],
        );
      });
}

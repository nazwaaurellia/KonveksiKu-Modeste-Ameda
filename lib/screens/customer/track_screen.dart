import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'track_detail_screen.dart';

/// Daftar pesanan pelanggan (tab Lacak). Ketuk kartu untuk melihat detail.
/// Jika [order] diisi, langsung membuka detail pesanan itu.
class TrackScreen extends StatefulWidget {
  final Order? order;
  final bool back;
  const TrackScreen({this.order, this.back = false, super.key});
  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  bool running = true;

  Widget _seg(String label, bool on, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: on ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(22)),
            child: Text(label, style: t(14, color: on ? C.ink : C.muted, w: FontWeight.w800)),
          ),
        ),
      );

  (String, String, Color) _pay(Order o) {
    if (o.dpPaid == 0) return ('Menunggu DP ${rp(o.dp)}', 'Belum bayar', C.gold);
    if (o.remaining == 0) return ('Pembayaran', 'Lunas', C.green);
    if (o.status == St.menungguDesain || o.status == St.menungguVerifikasi) return ('DP sudah dibayar', 'Belum lunas', C.gold);
    return ('Sisa tagihan ${rp(o.remaining)}', 'Belum lunas', C.gold);
  }

  Widget _card(Order o) {
    final (txt, tag, tagColor) = _pay(o);
    final ready = o.status == St.selesai;
    final parts = txt.split(' Rp');
    return GestureDetector(
      onTap: () => go(context, TrackDetailScreen(o)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ready ? C.green : C.ink.withOpacity(.05), width: ready ? 1.5 : 1),
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 3))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(o.title, style: t(17, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.chevron_right, color: C.ink),
          ]),
          const SizedBox(height: 2),
          Text('#${o.id} · ${o.qty} pcs · dibuat ${o.created}', style: t(12, color: C.muted)),
          const SizedBox(height: 12),
          Row(children: [
            Tag(o.label, o.isDone ? C.green : C.gold),
            const Spacer(),
            Text('${o.step} dari ${o.stepCount} tahap selesai', style: t(12, color: C.muted)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: o.progress, minHeight: 6, color: C.green, backgroundColor: C.sand),
          ),
          Divider(height: 24, color: C.sand),
          Row(children: [
            Expanded(
              child: parts.length > 1
                  ? Text.rich(TextSpan(style: t(12.5, color: C.muted), children: [
                      TextSpan(text: '${parts[0]} '),
                      TextSpan(text: 'Rp${parts[1]}', style: t(12.5, w: FontWeight.w800)),
                    ]))
                  : Text(txt, style: t(12.5, color: C.muted)),
            ),
            Tag(tag, tagColor),
          ]),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.order != null) return TrackDetailScreen(widget.order!);
    return Live((context, s) {
      final all = s.mine;
      final run = all.where((o) => !o.isDone).toList();
      final done = all.where((o) => o.isDone).toList();
      final list = running ? run : done;
      if (all.isEmpty) {
        return Screen(title: 'Lacak Pesanan', centerTitle: true, back: true, children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
          Center(
            child: Container(
              width: 132,
              height: 132,
              decoration: const BoxDecoration(color: Color(0xFFF1E4C8), shape: BoxShape.circle),
              child: const Icon(Icons.view_in_ar_outlined, size: 52, color: C.brown),
            ),
          ),
          const SizedBox(height: 22),
          Text('Belum ada pesanan', textAlign: TextAlign.center, style: h(21)),
          const SizedBox(height: 8),
          Text('Setelah kamu memesan, status pesananmu\nakan muncul di sini.',
              textAlign: TextAlign.center, style: t(13, color: C.muted).copyWith(height: 1.5)),
        ]);
      }
      return Screen(title: 'Lacak pesanan', back: true, children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: C.sand, borderRadius: BorderRadius.circular(26)),
          child: Row(children: [
            _seg('Berjalan · ${run.length}', running, () => setState(() => running = true)),
            _seg('Selesai', !running, () => setState(() => running = false)),
          ]),
        ),
        const SizedBox(height: 16),
        if (list.isEmpty) Padding(padding: const EdgeInsets.only(top: 30), child: Center(child: Text('Belum ada pesanan di sini.', style: t(13, color: C.muted)))),
        for (final o in list) _card(o),
      ]);
    });
  }
}

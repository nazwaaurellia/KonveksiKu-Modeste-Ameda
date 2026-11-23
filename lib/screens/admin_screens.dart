import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'auth_screens.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});
  @override
  Widget build(BuildContext context) => Shell(
        const [DashboardScreen(), OrderListScreen(), StockScreen(), AdminProfile()],
        const [
          (Icons.home_outlined, 'Beranda'),
          (Icons.receipt_long_outlined, 'Pesanan'),
          (Icons.inventory_2_outlined, 'Stok'),
          (Icons.person_outline, 'Akun'),
        ],
      );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  Widget _quick(BuildContext c, IconData i, String s, Widget to) => Expanded(
        child: Box(
          onTap: () => go(c, to),
          child: Column(children: [Icon(i, color: C.brown), const SizedBox(height: 4), Text(s, style: t(10, w: FontWeight.w700), textAlign: TextAlign.center)]),
        ),
      );
  @override
  Widget build(BuildContext context) => Screen(title: 'Dashboard', children: [
        const Label('Aktivitas'),
        Box(child: Row(children: [
          const Icon(Icons.timer_outlined, color: C.brown),
          const SizedBox(width: 10),
          Text('3 pesanan jatuh tempo\n12 pesanan aktif minggu ini', style: t(12, w: FontWeight.w600)),
        ])),
        Box(color: C.sand, child: Row(children: [
          Expanded(child: Text('Benang hitam hampir habis\nSisa 3 kon, segera restok.', style: t(12, w: FontWeight.w600))),
          const Icon(Icons.warning_amber_rounded, color: C.brown),
        ])),
        const Label('Aksi cepat'),
        Row(children: [
          _quick(context, Icons.add, 'Pesanan Baru', const AdminNewOrder()),
          const SizedBox(width: 8),
          _quick(context, Icons.check_circle_outline, 'Verifikasi DP', const ReportScreen()),
          const SizedBox(width: 8),
          _quick(context, Icons.bar_chart, 'Laporan', const ReportScreen()),
        ]),
        const Label('Pesanan'),
        Row(children: [
          Expanded(child: Box(onTap: () => go(context, const OrderListScreen()), child: Text('Semua pesanan\n12 pesanan', style: t(12, w: FontWeight.w700)))),
          const SizedBox(width: 8),
          Expanded(child: Box(onTap: () => go(context, const DesignReview()), child: Text('Perlu tindakan\n5 pesanan', style: t(12, w: FontWeight.w700)))),
        ]),
      ]);
}

class AdminNewOrder extends StatefulWidget {
  const AdminNewOrder({super.key});
  @override
  State<AdminNewOrder> createState() => _AdminNewOrderState();
}

class _AdminNewOrderState extends State<AdminNewOrder> {
  String prod = 'Seragam', size = '8 cm';
  int qty = 48;
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Pesanan baru',
        back: true,
        bottom: Btn('Simpan pesanan', () => Navigator.pop(context)),
        children: [
          const Fld('Nama pelanggan', 'Ibu Sari'),
          const Label('Jenis produk'),
          Wrap(spacing: 8, children: [for (final p in ['Seragam', 'Topi', 'Jaket', 'Tas']) Choice(p, prod == p, () => setState(() => prod = p))]),
          const Label('Ukuran bordir'),
          Wrap(spacing: 8, children: [for (final s in ['5 cm', '8 cm', '10 cm']) Choice(s, size == s, () => setState(() => size = s))]),
          const Label('Jumlah'),
          Row(children: [
            IconButton(onPressed: () => setState(() => qty = (qty - 1).clamp(1, 9999)), icon: const Icon(Icons.remove)),
            Text('$qty', style: h(20)),
            IconButton(onPressed: () => setState(() => qty++), icon: const Icon(Icons.add)),
          ]),
          Box(child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Harga satuan ($size)', style: t(11)), Text(rp(8000), style: t(11))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total', style: t(14, w: FontWeight.w800)), Text(rp(qty * 8000), style: h(18))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('DP 50%', style: t(11, color: C.muted)), Text(rp(qty * 4000), style: t(11, color: C.muted))]),
          ])),
        ],
      );
}

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Seragam PKK',
        action: const Tag('Dibordir'),
        back: true,
        bottom: Btn('Tandai selesai', () => Navigator.pop(context)),
        children: [
          Text('#BK-0142 · Ibu Sari · 48 pcs', style: t(10, color: C.muted)),
          const SizedBox(height: 10),
          const Timeline([
            ['Pesanan diterima', '10 Nov'],
            ['Desain disetujui', '11 Nov'],
            ['Dibordir', 'Sedang berjalan'],
            ['Selesai', ''],
            ['Diambil', ''],
          ], 2),
          Box(child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total', style: t(11)), Text(rp(384000), style: t(11))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('DP dibayar', style: t(11)), Text(rp(192000), style: t(11))]),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Sisa tagihan', style: t(13, w: FontWeight.w800)), Text(rp(192000), style: h(16))]),
          ])),
        ],
      );
}

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Hitam', Colors.black, 'Sisa 3 kon', .15, 'Hampir habis'),
      ('Putih', Colors.white, 'Sisa 14 kon', .75, ''),
      ('Merah', Colors.red, 'Sisa 9 kon', .5, ''),
      ('Emas', C.gold, 'Sisa 6 kon', .35, ''),
    ];
    return Screen(title: 'Stok', children: [
      Wrap(spacing: 8, children: [for (final c in ['Benang', 'Kain', 'Jarum', 'Aksesori']) Choice(c, c == 'Benang', () {})]),
      const SizedBox(height: 12),
      for (final i in items)
        Box(child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: i.$2, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.sand))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(i.$1, style: t(14, w: FontWeight.w800)), const Spacer(), if (i.$5.isNotEmpty) Tag(i.$5, C.red)]),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: i.$4, color: i.$4 < .2 ? C.red : C.green, backgroundColor: C.sand, minHeight: 5),
            const SizedBox(height: 4),
            Text(i.$3, style: t(10, color: C.muted)),
          ])),
        ])),
    ]);
  }
}

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(title: 'Daftar pesanan', children: [
        const Fld('Cari', 'BK-01'),
        Wrap(spacing: 8, children: [for (final c in ['Semua', 'Baru', 'Dibordir', 'Selesai']) Choice(c, c == 'Semua', () {})]),
        const SizedBox(height: 12),
        OrderTile(Icons.checkroom, C.green, 'Seragam PKK', '#BK-0142 · Operator: Dani', 'Dibordir', onTap: () => go(context, const OrderDetail())),
        OrderTile(Icons.sports_baseball, C.red, 'Topi komunitas', '#BK-0141 · Belum ditugaskan', 'Baru', onTap: () => go(context, const DesignReview())),
        const OrderTile(Icons.checkroom, C.brown, 'Jaket angkatan', '#BK-0139 · Operator: Rina', 'Selesai'),
        const OrderTile(Icons.shopping_bag, C.gold, 'Tas seminar', '#BK-0138 · Pelunasan tertunda', 'Tunggu bayar'),
      ]);
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const bars = [.5, .9, .6, 1.0];
    return Screen(title: 'Laporan keuangan', back: true, action: const Tag('Nov 2026'), children: [
      Row(children: [
        Expanded(child: Box(child: Text('Pemasukan\nRp 12,4 jt', style: t(12, w: FontWeight.w800, color: C.green)))),
        const SizedBox(width: 8),
        Expanded(child: Box(child: Text('Pengeluaran\nRp 3,1 jt', style: t(12, w: FontWeight.w800, color: C.red)))),
      ]),
      Box(child: SizedBox(
        height: 130,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var i = 0; i < 4; i++)
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(height: 90 * bars[i], margin: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: i == 3 ? C.gold : C.brown, borderRadius: BorderRadius.circular(6))),
              const SizedBox(height: 4),
              Text('M${i + 1}', style: t(10, color: C.muted)),
            ])),
        ]),
      )),
      const Label('Menunggu verifikasi'),
      for (final v in [('Ibu Sari', 'DP #BK-0142 · Rp 192.000'), ('Pak Anton', 'DP #BK-0141 · Rp 400.000')])
        Box(child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v.$1, style: t(13, w: FontWeight.w800)), Text(v.$2, style: t(10, color: C.muted))])),
          SizedBox(width: 100, child: Btn('Verifikasi', () {})),
        ])),
    ]);
  }
}

class DesignReview extends StatelessWidget {
  const DesignReview({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Seragam PKK',
        back: true,
        action: const Tag('Menunggu desain', C.red),
        bottom: Row(children: [
          Expanded(child: Btn('Minta revisi', () => Navigator.pop(context), light: true)),
          const SizedBox(width: 10),
          Expanded(child: Btn('Setujui desain', () => Navigator.pop(context))),
        ]),
        children: [
          Text('#BK-0142 · Ibu Sari · 48 pcs', style: t(10, color: C.muted)),
          const SizedBox(height: 10),
          Box(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Label('Spesifikasi'),
            for (final r in [['Layanan', 'Jahit + bordir'], ['Produk', 'Seragam'], ['Kain', 'Drill'], ['Ukuran baju', 'M, L, XL'], ['Ukuran bordir', '8 cm']])
              Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Expanded(child: Text(r[0], style: t(11, color: C.muted))), Text(r[1], style: t(11, w: FontWeight.w700))])),
          ])),
          Box(child: Row(children: [
            const Icon(Icons.image_outlined, color: C.brown),
            const SizedBox(width: 10),
            Expanded(child: Text('File desain\nlogo-pkk.png · diunggah 10 Nov', style: t(11))),
            const Tag('Lihat'),
          ])),
          Box(child: Text('CATATAN PELANGGAN\nLogo di dada kiri, benang emas agak tebal. Mohon kaberi kelau ada kain yang kosong.', style: t(11))),
        ],
      );
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});
  @override
  Widget build(BuildContext context) => Screen(title: 'Akun admin', children: [
        Box(onTap: () => go(context, const ReportScreen()), child: Text('Laporan keuangan', style: t(13))),
        Box(onTap: () => go(context, const DesignReview()), child: Text('Review desain', style: t(13))),
        const SizedBox(height: 8),
        Btn('Keluar', () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false), light: true),
      ]);
}

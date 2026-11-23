import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'auth_screens.dart';

/// Data pesanan sementara (demo, tanpa backend).
class Draft {
  static int qty = 48;
  static int price = 8000;
  static int get total => qty * price;
}

const _steps = [
  ['Pesanan diterima', '10 Nov'],
  ['Pembayaran DP terverifikasi', '10 Nov'],
  ['Dibordir', 'Sedang berjalan'],
  ['Selesai', ''],
  ['Siap diambil', ''],
];

class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key});
  @override
  Widget build(BuildContext context) => Shell(
        const [HomeScreen(), ChooseService(), TrackScreen(), ProfileScreen()],
        const [
          (Icons.home_outlined, 'Beranda'),
          (Icons.receipt_long_outlined, 'Pesan'),
          (Icons.place_outlined, 'Lacak'),
          (Icons.person_outline, 'Akun'),
        ],
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(children: [
        Text('Selamat siang, Sari', style: t(11, color: C.muted)),
        Text('Mau pesan apa hari ini?', style: h(26)),
        const SizedBox(height: 14),
        Box(
          color: C.sand,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(backgroundColor: C.brown, child: Text('60%', style: TextStyle(color: Colors.white, fontSize: 11))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Seragam PKK', style: t(15, w: FontWeight.w800)),
                  Text('#BK-0142 · Sedang di bordir', style: t(10, color: C.muted)),
                ]),
              ),
            ]),
            const SizedBox(height: 10),
            Text('3 dari 5 tahap selesai', style: t(10, color: C.muted)),
            const SizedBox(height: 8),
            SizedBox(width: 160, child: Btn('Lacak pesanan ›', () => go(context, const TrackScreen()))),
          ]),
        ),
        const Label('Pilih layanan'),
        Row(children: [
          Expanded(child: _ServiceCard('Jahit Baju', 'Jahit sesuai ukuran', Icons.checkroom, C.green, () => go(context, const NewOrder1()))),
          const SizedBox(width: 12),
          Expanded(child: _ServiceCard('Bordir', 'Logo dan nama di atas kain', Icons.workspace_premium, C.red, () => go(context, const NewOrder1()))),
        ]),
      ]);
}

class _ServiceCard extends StatelessWidget {
  final String title, sub;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;
  const _ServiceCard(this.title, this.sub, this.icon, this.tint, this.onTap);
  @override
  Widget build(BuildContext context) => Box(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 80, width: double.infinity,
            decoration: BoxDecoration(color: tint.withOpacity(.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: 40, color: tint),
          ),
          const SizedBox(height: 8),
          Text(title, style: t(14, w: FontWeight.w800)),
          Text(sub, style: t(10, color: C.muted)),
          const SizedBox(height: 8),
          Btn('Pesan', onTap),
        ]),
      );
}

class ChooseService extends StatefulWidget {
  const ChooseService({super.key});
  @override
  State<ChooseService> createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {
  int sel = 0;
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Mau pesan apa?',
        bottom: Btn('Lanjut', () => go(context, const NewOrder1())),
        children: [
          Text('Pilih layanan dulu. Detail bahan dan desain diisi di langkah berikutnya.', style: t(11, color: C.muted)),
          const SizedBox(height: 12),
          for (final (i, s) in [
            ('Jahit Baju', 'Pilih jenis kain dan ukuran S–XXL', Icons.checkroom, C.green),
            ('Bordir Saja', 'Bawa bahan sendiri, ukuran 5–10 cm', Icons.workspace_premium, C.red),
          ].indexed)
            GestureDetector(
              onTap: () => setState(() => sel = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: sel == i ? C.brown : Colors.transparent, width: 2),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 90, width: double.infinity,
                    decoration: BoxDecoration(color: s.$4.withOpacity(.15), borderRadius: BorderRadius.circular(14)),
                    child: Icon(s.$3, size: 44, color: s.$4),
                  ),
                  const SizedBox(height: 8),
                  Text(s.$1, style: t(15, w: FontWeight.w800)),
                  Text(s.$2, style: t(11, color: C.muted)),
                ]),
              ),
            ),
        ],
      );
}

class NewOrder1 extends StatefulWidget {
  const NewOrder1({super.key});
  @override
  State<NewOrder1> createState() => _NewOrder1State();
}

class _NewOrder1State extends State<NewOrder1> {
  String prod = 'Seragam', kain = 'Drill';
  bool bordir = true;
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Pesanan baru',
        action: Text('Langkah 1 dari 2', style: t(10, color: C.muted)),
        back: true,
        bottom: Btn('Lanjut: desain & detail', () => go(context, const NewOrder2())),
        children: [
          const Label('Jenis produk'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final p in ['Kemeja', 'Kaos', 'Seragam', 'Jaket', 'Topi', 'Tas'])
              Choice(p, prod == p, () => setState(() => prod = p)),
          ]),
          const Label('Jenis kain'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final k in ['Katun', 'Drill', 'Polyester', 'Fleece', 'Denim', 'Baby terry'])
              Choice(k, kain == k, () => setState(() => kain = k)),
          ]),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: bordir,
            activeColor: C.brown,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Tambahkan bordir pada baju', style: t(13)),
            onChanged: (v) => setState(() => bordir = v!),
          ),
        ],
      );
}

class NewOrder2 extends StatefulWidget {
  const NewOrder2({super.key});
  @override
  State<NewOrder2> createState() => _NewOrder2State();
}

class _NewOrder2State extends State<NewOrder2> {
  String size = 'L', bsize = '8 cm';
  final colors = <Color>{Colors.black, Colors.red};
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Desain & detail',
        action: Text('Langkah 2 dari 2', style: t(10, color: C.muted)),
        back: true,
        bottom: Row(children: [
          Expanded(child: Text('Estimasi total\n${rp(Draft.total)}', style: t(13, w: FontWeight.w800))),
          Expanded(child: Btn('Lanjut ke pembayaran', () => go(context, const PaymentScreen()))),
        ]),
        children: [
          const Label('Desain'),
          Box(child: Center(child: Text('⬆ Unggah desain atau logo\nPNG, JPG, atau file desain', textAlign: TextAlign.center, style: t(12, color: C.muted)))),
          const Label('Warna barang · 2 dipilih'),
          Row(children: [
            for (final c in [Colors.black, Colors.amber, Colors.red, Colors.white, Colors.indigo])
              GestureDetector(
                onTap: () => setState(() => colors.contains(c) ? colors.remove(c) : colors.add(c)),
                child: Container(
                  width: 34, height: 34, margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: c, shape: BoxShape.circle,
                    border: Border.all(color: colors.contains(c) ? C.brown : C.sand, width: 3),
                  ),
                ),
              ),
          ]),
          const Label('Ukuran'),
          Wrap(spacing: 8, children: [for (final s in ['S', 'M', 'L', 'XL', 'XXL']) Choice(s, size == s, () => setState(() => size = s))]),
          const Label('Ukuran bordir'),
          Wrap(spacing: 8, children: [for (final s in ['5 cm', '8 cm', '10 cm']) Choice(s, bsize == s, () => setState(() => bsize = s))]),
          const Label('Jumlah'),
          Row(children: [
            IconButton(onPressed: () => setState(() => Draft.qty = (Draft.qty - 1).clamp(1, 9999)), icon: const Icon(Icons.remove)),
            Text('${Draft.qty}', style: h(20)),
            IconButton(onPressed: () => setState(() => Draft.qty++), icon: const Icon(Icons.add)),
          ]),
          const Fld('Catatan', 'Logo di dada kiri, benang emas agak tebal.', lines: 3),
        ],
      );
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String m = 'Transfer bank';
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Pembayaran DP',
        back: true,
        bottom: Btn('Kirim bukti pembayaran', () => go(context, const TrackScreen())),
        children: [
          Box(child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Seragam PKK × ${Draft.qty}', style: t(12, color: C.muted)), Text(rp(Draft.total), style: t(12))]),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('DP 50%', style: t(14, w: FontWeight.w800)), Text(rp(Draft.total ~/ 2), style: h(18, C.red))]),
          ])),
          const Label('Metode pembayaran'),
          Wrap(spacing: 8, children: [for (final x in ['Transfer bank', 'QRIS', 'E-wallet']) Choice(x, m == x, () => setState(() => m = x))]),
          const SizedBox(height: 12),
          Box(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Transfer ke', style: t(10, color: C.muted)),
            Text('BCA 1234 5678 90', style: h(18)),
            Text('a.n. Konveksi Maju Jaya', style: t(11, color: C.muted)),
          ])),
          Box(child: Center(child: Text('Unggah bukti transfer\nAdmin memverifikasi maksimal 1 jam', textAlign: TextAlign.center, style: t(11, color: C.muted)))),
        ],
      );
}

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Lacak pesanan',
        action: const Tag('Dibordir'),
        bottom: Btn('Chat admin', () {}),
        children: [
          Text('Seragam PKK', style: h(20)),
          Text('#BK-0142 · 48 pcs · Est. selesai 18 Nov', style: t(10, color: C.muted)),
          const SizedBox(height: 12),
          const Timeline(_steps, 2),
          Box(child: Row(children: [
            Expanded(child: Text('Foto progress\nDikirim operator hari ini', style: t(11))),
            const Tag('Lihat'),
          ])),
        ],
      );
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool aktif = true;
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Riwayat pesanan',
        children: [
          Row(children: [
            Choice('Aktif', aktif, () => setState(() => aktif = true)),
            const SizedBox(width: 8),
            Choice('Selesai', !aktif, () => setState(() => aktif = false)),
          ]),
          const SizedBox(height: 12),
          if (aktif) ...[
            const OrderTile(Icons.checkroom, C.green, 'Seragam PKK', '#BK-0142 · 48 pcs', 'Dibordir'),
            const OrderTile(Icons.sports_baseball, C.red, 'Topi komunitas', '#BK-0141 · 100 pcs', 'Menunggu DP'),
          ] else ...[
            const OrderTile(Icons.checkroom, C.brown, 'Jaket angkatan', '#BK-0139 · 30 pcs', 'Selesai'),
            const OrderTile(Icons.shopping_bag, C.gold, 'Tas seminar', '#BK-0120 · 60 pcs', 'Selesai'),
          ],
        ],
      );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(title: 'Akun', children: [
        Box(child: Row(children: [
          const CircleAvatar(backgroundColor: C.brown, child: Text('MA', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Text('Sari Wulandari', style: t(14, w: FontWeight.w800)),
        ])),
        Box(onTap: () => go(context, const HistoryScreen()), child: Text('Riwayat pesanan', style: t(13))),
        const SizedBox(height: 8),
        Btn('Keluar', () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false), light: true),
      ]);
}

import 'package:flutter/material.dart';
import '../../core/order_ui.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'new_order_step2_screen.dart';

/// Konfigurasi form langkah 1 untuk tiap jenis pesanan.
class _Cfg {
  final String? pill;
  final String title, sub, modelLabel, searchHint, pop, addTitle, addSub;
  final List<String> models, fabrics, moreFabrics;
  final List<(String, String, List<String>)> opts; // (label, key, pilihan)
  final bool own;
  const _Cfg(this.pill, this.title, this.sub, this.modelLabel, this.models, this.searchHint, this.pop, this.fabrics,
      this.moreFabrics, this.opts, this.own, this.addTitle, this.addSub);
}

const _more = ['Cotton combed', 'Linen', 'Flanel', 'Kanvas', 'Beludru', 'Oxford', 'Twill', 'Spandek'];
const _cfg = <String, _Cfg>{
  'jahit': _Cfg(null, 'Mau pesan apa?', 'Pilih satu produk. Pilihan bahan dan ukuran menyesuaikan produknya.', 'Pakaian',
      ['Seragam', 'Kemeja', 'Kaos', 'Jaket', 'Rompi', 'Batik'], 'Cari bahan, mis. CVC, Toyobo', '',
      ['Polyester', 'Katun', 'Drill', 'CVC', 'Toyobo', 'Fleece', 'Denim', 'Baby terry', 'Lacoste', 'Rayon', 'Satin'],
      _more, [], true, 'Tambah bordir', 'Logo atau nama. Ukuran bordir diatur di langkah berikutnya.'),
  'hijab': _Cfg('Hijab', 'Pesan hijab', 'Pilih model, bahan, dan finishing tepinya.', 'Model hijab',
      ['Segi empat', 'Pashmina', 'Instan (sorong)', 'Paris', 'Khimar'], 'Cari bahan hijab, mis. voal, sifon', 'hijab',
      ['Voal', 'Paris', 'Katun', 'Sifon', 'Jersey', 'Satin', 'Wolfis', 'Ceruty'], ['Crinkle', 'Premium silk', 'Bubble pop'],
      [('Finishing tepi', 'finishing', ['Neci (rawis)', 'Obras', 'Laser cut']), ('Motif', 'motif', ['Polos', 'Print motif', 'Desain sendiri'])],
      true, 'Tambah bordir pada hijab', 'Posisi dan ukuran diatur di langkah berikutnya.'),
  'kaoskaki': _Cfg('Kaos kaki', 'Pesan kaos kaki', 'Pilih model, bahan, dan logonya.', 'Model kaos kaki',
      ['Pendek (mata kaki)', 'Setengah betis', 'Panjang (selutut)', 'Tak terlihat'], 'Cari bahan, mis. katun, spandex', 'kaos kaki',
      ['Katun', 'Katun + spandex', 'Polyester', 'Nilon', 'Wol', 'Bambu', 'Terry (handuk)'], ['Akrilik', 'Rayon'], [], false,
      'Tambah logo pada kaos kaki', 'Teknik, posisi, dan ukuran diatur di langkah berikutnya.'),
  'dasi': _Cfg('Dasi', 'Pesan dasi', 'Pilih model, bahan, dan motifnya.', 'Model dasi',
      ['Dasi panjang', 'Kupu-kupu', 'Pita', 'Siap pakai (tanpa simpul)'], 'Cari bahan dasi, mis. satin, microfiber', 'dasi',
      ['Polyester', 'Satin', 'Microfiber', 'Katun', 'Drill', 'Rajut', 'Wol'], ['Sutra imitasi', 'Jacquard'],
      [('Motif', 'motif', ['Polos', 'Garis-garis', 'Kotak', 'Logo berulang', 'Desain sendiri'])],
      true, 'Tambah bordir logo pada dasi', 'Posisi dan ukuran diatur di langkah berikutnya.'),
  'topi': _Cfg('Topi', 'Pesan topi', 'Pilih model, bahan, dan tambahan bordirnya.', 'Model topi',
      ['Baseball', 'Trucker', 'Snapback', 'Bucket', 'Rimba', 'Pet upacara'], 'Cari bahan topi, mis. rafael, taslan', 'topi',
      ['Drill', 'Katun', 'Canvas', 'Rafael', 'Taslan', 'Denim', 'Polyester', 'Jaring'], ['Corduroy', 'Nilon'], [], true,
      'Tambah bordir pada topi', 'Logo atau nama. Posisi dan ukuran diatur di langkah berikutnya.'),
};

/// Semua bahan kain yang bisa dicari, apa pun jenis pesanannya.
const _allFabrics = [
  'Polyester', 'Katun', 'Drill', 'CVC', 'Toyobo', 'Fleece', 'Denim', 'Baby terry', 'Lacoste', 'Rayon', 'Satin',
  'Cotton combed', 'Linen', 'Flanel', 'Kanvas', 'Canvas', 'Beludru', 'Oxford', 'Twill', 'Spandek', 'Voal', 'Paris',
  'Sifon', 'Jersey', 'Wolfis', 'Ceruty', 'Crinkle', 'Premium silk', 'Bubble pop', 'Rafael', 'Taslan', 'Jaring',
  'Corduroy', 'Nilon', 'Wol', 'Bambu', 'Terry (handuk)', 'Akrilik', 'Katun + spandex', 'Microfiber', 'Rajut',
  'Jacquard', 'Sutra imitasi', 'Tetoron', 'Marcopolo', 'Dobby', 'Hyget', 'Scuba', 'Katun poplin', 'Katun jepang',
  'Batik cap', 'Batik printing', 'Cotton carded', 'Bahan kaos 30s', 'Poplin', 'Kain tenun', 'Jeans', 'Kain parasut',
];

class NewOrderStep1Screen extends StatefulWidget {
  const NewOrderStep1Screen({super.key});
  @override
  State<NewOrderStep1Screen> createState() => _NewOrderStep1ScreenState();
}

class _NewOrderStep1ScreenState extends State<NewOrderStep1Screen> {
  final d = AppStore.I.draft;
  final q = TextEditingController();
  bool all = false;

  @override
  void dispose() {
    q.dispose();
    super.dispose();
  }

  Widget _bordir() => stepScreen(
        1,
        'Pesanan baru',
        bottom: Btn('Lanjut: desain & posisi', () => go(context, const NewOrderStep2Screen())),
        children: [
          const SizedBox(height: 8),
          const Pill('Layanan: Bordir saja'),
          const SizedBox(height: 14),
          Text('Apa yang mau dibordir?', style: h(24)),
          const SizedBox(height: 4),
          Text('Kamu membawa barangnya sendiri, kami hanya membordir.', style: t(13, color: C.muted)),
          const Label('Pakaian'),
          Chips(['Seragam', 'Kemeja', 'Kaos', 'Jaket', 'Rompi'], (x) => d.product == x, (x) => setState(() => d.product = x)),
          const Label('Asesoris'),
          Chips(['Topi', 'Dasi', 'Kaos kaki', 'Hijab / jilbab'], (x) => d.product == _prod(x), (x) => setState(() => d.product = _prod(x))),
          const Label('Cara menyerahkan barang'),
          Box(
            child: Row(children: [
              _round(Icons.storefront_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Antar ke toko', style: t(14, w: FontWeight.w800)),
                  Text('Bawa barangmu ke toko setelah DP terverifikasi.', style: t(12, color: C.muted)),
                ]),
              ),
            ]),
          ),
        ],
      );

  static String _prod(String x) => x == 'Kaos kaki' ? 'Kaos Kaki' : (x.startsWith('Hijab') ? 'Hijab' : x);

  Widget _round(IconData i) => Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Color(0xFFF1E4C8), shape: BoxShape.circle),
        child: Icon(i, size: 20, color: C.brown),
      );

  @override
  Widget build(BuildContext context) {
    if (d.kind == 'bordir') return _bordir();
    final c = _cfg[d.kind]!;
    final pool = {...c.fabrics, ...c.moreFabrics, ..._allFabrics}.toList();
    final query = q.text.trim().toLowerCase();
    final shown = query.isNotEmpty ? pool.where((f) => f.toLowerCase().contains(query)).toList() : (all ? pool : c.fabrics);
    final jahit = d.kind == 'jahit';
    final pop = jahit ? 'Populer untuk ${d.product.toLowerCase()}' : 'Populer untuk ${c.pop}';
    return stepScreen(
      1,
      'Pesanan baru',
      bottom: Btn('Lanjut: warna & ukuran', () {
        if (d.fabric.isEmpty) d.fabric = c.fabrics.first;
        go(context, const NewOrderStep2Screen());
      }),
      children: [
        const SizedBox(height: 8),
        if (c.pill != null) ...[Pill('Layanan: ${c.pill}'), const SizedBox(height: 14)],
        Text(c.title, style: h(24)),
        const SizedBox(height: 4),
        Text(c.sub, style: t(13, color: C.muted)),
        Label(c.modelLabel),
        Chips(
          c.models,
          (x) => jahit ? d.product == x : (d.model.isEmpty ? c.models.first == x : d.model == x),
          (x) => setState(() => jahit ? d.product = x : d.model = x),
        ),
        const Label('Bahan'),
        PillField(c.searchHint, ctrl: q, search: true, onChanged: (_) => setState(() {})),
        const SizedBox(height: 14),
        if (d.fabric.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('Dipilih: ${d.fabric}', style: t(12.5, color: C.brown, w: FontWeight.w800))),
        Sub(pop),
        if (query.isNotEmpty && !pool.any((f) => f.toLowerCase() == query)) ...[
          if (shown.isEmpty) const Sub('Bahan tidak ada di daftar. Kamu bisa memakai nama bahan sendiri:'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutChip('Pakai "${q.text.trim()}"', () => setState(() {
                    d.fabric = q.text.trim();
                    q.clear();
                  })),
            ),
          ),
        ],
        Chips(
          shown,
          (x) => d.fabric == x,
          (x) => setState(() => d.fabric = x),
          more: (all || query.isNotEmpty) ? null : 'Lihat semua bahan ›',
          onMore: () => setState(() => all = true),
        ),
        for (final (label, key, items) in c.opts) ...[
          Label(label),
          Chips(items, (x) => (d.opt[key] ?? items.first) == x, (x) => setState(() => d.opt[key] = x)),
        ],
        const SizedBox(height: 16),
        if (c.own) ToggleCard('Bawa bahan sendiri', 'Kami hanya menjahit (makloon)', d.ownMaterial, (v) => setState(() => d.ownMaterial = v)),
        const Label('Tambahan'),
        ToggleCard(c.addTitle, c.addSub, d.bordir, (v) => setState(() => d.bordir = v)),
      ],
    );
  }
}

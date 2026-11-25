import 'package:flutter/material.dart';
import '../../core/order_ui.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'payment_screen.dart';

/// Konfigurasi form langkah 2 untuk tiap jenis pesanan.
class _Cfg {
  final String colorLabel, intro, noteHint, cardTitle;
  final List<(String, String?)> rows;
  final List<int> defaults;
  final String? extraBtn, sizeNote;
  final List<(String, String, List<String>)> pre; // (label, key, pilihan) di luar kartu bordir
  final List<(String, String, List<String>)> card; // (label, key, pilihan); key 'pos' & 'bsize' khusus
  final bool boxed;
  const _Cfg(this.colorLabel, this.intro, this.rows, this.defaults, this.extraBtn, this.noteHint, this.cardTitle, this.card,
      {this.pre = const [], this.sizeNote, this.boxed = true});
}

const _cfg = <String, _Cfg>{
  'jahit': _Cfg('Warna', 'Isi jumlah tiap ukuran untuk setiap warna.',
      [('S', null), ('M', null), ('L', null), ('XL', null), ('XXL', null)], [4, 8, 8, 4, 0], '+ Ukuran lain (XS, 3XL, anak)',
      'Mis. posisi logo, nama di dada', 'Ukuran bordir', [('Ukuran bordir', 'bsize', ['5 cm', '8 cm', '10 cm'])], boxed: false),
  'hijab': _Cfg('Warna hijab', 'Isi jumlah tiap ukuran untuk setiap warna. Ukuran segi empat adalah sisi × sisi.',
      [('Anak', '90 × 90 cm'), ('Standar', '110 × 110 cm'), ('Besar', '120 × 120 cm')], [6, 20, 4], '+ Ukuran lain (sisi × sisi)',
      'Mis. logo di pojok kanan bawah, benang emas', 'Bordir hijab',
      [('Posisi (bisa lebih dari satu)', 'pos', ['Pojok depan', 'Tepi bawah', 'Tengah depan']), ('Ukuran bordir', 'bsize', ['2 cm', '3 cm', '5 cm'])]),
  'kaoskaki': _Cfg('Warna kaos kaki', 'Isi jumlah pasang tiap ukuran untuk setiap warna.',
      [('Anak', 'Ukuran sepatu 28–34'), ('S', 'Ukuran sepatu 35–38'), ('M', 'Ukuran sepatu 39–42'), ('L', 'Ukuran sepatu 43–46')],
      [4, 6, 8, 6], '+ Ukuran lain', 'Mis. logo di sisi luar, garis warna emas', 'Logo kaos kaki', [
        ('Teknik logo', 'logoTech', ['Rajut (tenun)', 'Bordir', 'Sablon']),
        ('Posisi (bisa lebih dari satu)', 'pos', ['Pergelangan', 'Sisi luar', 'Punggung kaki', 'Telapak']),
        ('Ukuran logo', 'bsize', ['2 cm', '3 cm', '4 cm']),
      ],
      pre: [('Garis di ujung atas', 'stripes', ['Tanpa garis', '1 garis', '2 garis', '3 garis'])]),
  'dasi': _Cfg('Warna dasi', 'Isi jumlah tiap ukuran untuk setiap warna. Ukuran dasi adalah panjang × lebar.',
      [('Dewasa', '± 145 × 8 cm'), ('Remaja', '± 120 × 7 cm'), ('Anak', '± 90 × 6 cm')], [12, 0, 3], '+ Ukuran lain (panjang × lebar)',
      'Mis. logo di ujung bawah, garis warna emas', 'Bordir logo', [
        ('Posisi (bisa lebih dari satu)', 'pos', ['Ujung bawah', 'Bagian tengah', 'Berulang']),
        ('Ukuran bordir', 'bsize', ['3 cm', '5 cm', '8 cm']),
      ]),
  'topi': _Cfg('Warna topi', 'Isi jumlah tiap ukuran untuk setiap warna.', [('Dewasa', null), ('Anak', null)], [20, 4], null,
      'Mis. logo di tengah depan, tulisan di belakang', 'Bordir topi', [
        ('Posisi (bisa lebih dari satu)', 'pos', ['Depan', 'Samping kiri', 'Samping kanan', 'Belakang']),
        ('Jenis bordir', 'bordirType', ['Datar', 'Timbul (3D)']),
        ('Ukuran bordir', 'bsize', ['5 cm', '6 cm', '8 cm']),
      ],
      pre: [('Pengait belakang', 'closure', ['Strap logam', 'Snap plastik', 'Velcro', 'Karet'])],
      sizeNote: 'Dewasa: lingkar kepala sekitar 56–60 cm, bisa diatur. Anak: sekitar 52–54 cm.'),
};

const _positions = {
  'Topi': ['Depan', 'Samping kiri', 'Samping kanan', 'Belakang'],
  'Dasi': ['Ujung bawah', 'Bagian tengah', 'Berulang'],
  'Kaos Kaki': ['Pergelangan', 'Sisi luar', 'Punggung kaki', 'Telapak'],
  'Hijab': ['Pojok depan', 'Tepi bawah', 'Tengah depan'],
};
const _clothesPos = ['Dada kiri', 'Dada kanan', 'Lengan kiri', 'Lengan kanan', 'Punggung', 'Kerah', 'Saku'];

class NewOrderStep2Screen extends StatefulWidget {
  const NewOrderStep2Screen({super.key});
  @override
  State<NewOrderStep2Screen> createState() => _NewOrderStep2ScreenState();
}

class _NewOrderStep2ScreenState extends State<NewOrderStep2Screen> {
  final d = AppStore.I.draft;
  final q = TextEditingController();
  int tab = 0;

  @override
  void initState() {
    super.initState();
    if (d.positions.isEmpty) {
      final list = d.kind == 'bordir' ? (_positions[d.product] ?? _clothesPos) : (_cfg[d.kind]?.card.where((e) => e.$2 == 'pos').firstOrNull?.$3 ?? const []);
      if (list.isNotEmpty) d.positions = {list.first};
    }
  }

  @override
  void dispose() {
    q.dispose();
    super.dispose();
  }

  void _next() {
    go(context, const PaymentScreen());
  }

  // ---------- bagian bersama ----------
  Widget _bsizeChips(List<String> items) {
    final custom = !items.contains(d.bsize);
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (final x in items) Choice(x, d.bsize == x, () => setState(() => d.bsize = x)),
      if (custom) Choice(d.bsize, true, () {}),
      OutChip('Ukuran lain', () async {
        final v = await askText(context, 'Ukuran bordir', 'Mis. 7 cm');
        if (v != null && v.isNotEmpty) setState(() => d.bsize = v);
      }),
    ]);
  }

  Widget _section(List<(String, String, List<String>)> list, {bool labels = true}) {
    final w = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      final (label, key, items) = list[i];
      if (labels) {
        w.add(Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 16, bottom: 10),
          child: Text(label, style: t(12.5, color: C.muted)),
        ));
      }
      if (key == 'pos') {
        w.add(Chips(items, (x) => d.positions.contains(x), (x) => setState(() => d.positions.contains(x) ? d.positions.remove(x) : d.positions.add(x))));
      } else if (key == 'bsize') {
        w.add(_bsizeChips(items));
      } else {
        w.add(Chips(items, (x) => (d.opt[key] ?? items.first) == x, (x) => setState(() => d.opt[key] = x)));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: w);
  }

  Widget _totalBar(String button) => Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('Total ${d.qty} ${d.unitName} · estimasi', style: t(12, color: C.muted)),
          Text(rp(d.total), style: h(20)),
        ]),
        const SizedBox(height: 10),
        Btn(button, d.qty > 0 ? _next : null),
      ]);

  // ---------- Bordir saja ----------
  Widget _bordir() {
    final pos = _positions[d.product] ?? _clothesPos;
    final unitTxt = '${d.bsize}, ${d.posCount} posisi';
    return stepScreen(
      2,
      'Desain & posisi',
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Harga satuan ($unitTxt)', style: t(12, color: C.muted)),
          Text(rp(d.unit), style: t(12)),
        ]),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('DP 50%', style: t(12, color: C.muted)),
          Text(rp(d.dp), style: t(12)),
        ]),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Estimasi total · ${d.qty} pcs', style: t(12.5, w: FontWeight.w800)),
          Text(rp(d.total), style: h(20)),
        ]),
        const SizedBox(height: 10),
        Btn('Lanjut ke pembayaran', d.qty > 0 ? _next : null),
      ]),
      children: [
        const SizedBox(height: 8),
        Box(
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Barang yang dibordir', style: t(12, color: C.muted)),
                Text(d.product, style: t(18, w: FontWeight.w800)),
              ]),
            ),
            SizedBox(width: 96, child: Btn('Ganti', () => Navigator.pop(context), compact: true, light: true)),
          ]),
        ),
        const SectionRow('Desain'),
        UploadBox(d.hasDesign, () => setState(() => d.hasDesign = !d.hasDesign)),
        const SizedBox(height: 12),
        PillField('Atau tulis nama / teks untuk dibordir', onChanged: (v) => d.text = v),
        SectionRow('Posisi bordir', trailing: 'Untuk ${d.product.toLowerCase()}'),
        const Sub('Pilihan posisi menyesuaikan barang. Bisa lebih dari satu.'),
        Chips(pos, (x) => d.positions.contains(x), (x) => setState(() => d.positions.contains(x) ? d.positions.remove(x) : d.positions.add(x))),
        const Label('Ukuran bordir'),
        _bsizeChips(const ['5 cm', '8 cm', '10 cm']),
        SectionRow('Warna benang', trailing: '${d.threads.length} dipilih'),
        ColorGrid(kThreads, d.threads, (x) => setState(() => d.threads.contains(x) ? d.threads.remove(x) : d.threads.add(x))),
        const SizedBox(height: 14),
        const PillField('Cari nama atau kode warna benang', search: true),
        const Label('Jumlah barang'),
        Box(
          child: Row(children: [
            Expanded(child: Text('Barang yang dibordir', style: t(13, color: C.muted))),
            QtyStepper(d.itemQty, (v) => setState(() => d.itemQty = v)),
          ]),
        ),
        const Label('Catatan'),
        NoteField('Mis. logo di dada kiri, benang emas', d.note, (v) => d.note = v),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (d.kind == 'bordir') return _bordir();
    final c = _cfg[d.kind]!;
    final query = q.text.trim().toLowerCase();
    final palette = query.isEmpty ? kPalette : kPalette.where((e) => e.$1.toLowerCase().contains(query)).toList();
    final chosen = d.colors.toList();
    if (tab >= chosen.length) tab = 0;
    final List<(String, String?)> rows = [...c.rows, for (final e in d.extraSizes) (e, null)];
    Map<String, int>? cur;
    if (chosen.isNotEmpty) {
      cur = d.sizes.putIfAbsent(chosen[tab], () => {for (var i = 0; i < c.rows.length; i++) c.rows[i].$1: c.defaults[i]});
    }
    return stepScreen(
      2,
      'Warna & ukuran',
      bottom: _totalBar('Lanjut ke pembayaran'),
      children: [
        const SectionRow('Desain'),
        UploadBox(d.hasDesign, () => setState(() => d.hasDesign = !d.hasDesign)),
        SectionRow(c.colorLabel, trailing: '${d.colors.length} dipilih'),
        ColorGrid(palette, d.colors, (x) => setState(() => d.colors.contains(x) ? d.colors.remove(x) : d.colors.add(x))),
        const SizedBox(height: 14),
        PillField('Cari nama atau kode warna, mis. #1F2A5C', ctrl: q, search: true, onChanged: (_) => setState(() {})),
        if (c.sizeNote != null) ...[const Label('Ukuran topi'), Sub(c.sizeNote!)],
        for (final (label, key, items) in c.pre) ...[
          Label(label),
          Chips(items, (x) => (d.opt[key] ?? (key == 'stripes' ? '2 garis' : items.first)) == x, (x) => setState(() => d.opt[key] = x)),
        ],
        const Label('Jumlah per ukuran'),
        Sub(c.intro),
        if (chosen.isEmpty) const Sub('Pilih minimal satu warna dulu.'),
        if (chosen.isNotEmpty) ...[
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 0; i < chosen.length; i++)
              Choice('${chosen[i]} · ${d.colorQty(chosen[i])} ${d.unitName}', i == tab, () => setState(() => tab = i)),
          ]),
          const SizedBox(height: 14),
          SizeCard(rows, cur!, (n, v) => setState(() => cur![n] = v)),
        ],
        if (c.extraBtn != null)
          Align(
            alignment: Alignment.centerLeft,
            child: OutChip(c.extraBtn!, () async {
              final v = await askText(context, 'Ukuran lain', 'Mis. XS');
              if (v != null && v.isNotEmpty && !rows.any((r) => r.$1 == v)) setState(() => d.extraSizes.add(v));
            }),
          ),
        if (d.bordir) ...[
          Label(c.cardTitle),
          c.boxed ? Box(child: _section(c.card)) : _section(c.card, labels: false),
        ],
        const Label('Catatan'),
        NoteField(c.noteHint, d.note, (v) => d.note = v),
      ],
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/files.dart';
import '../../core/order_ui.dart';
import '../../core/price_ui.dart';
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
      'Tulis permintaan khusus, mis. model kerah atau panjang lengan', 'Bordir', [
        ('Posisi (bisa lebih dari satu)', 'pos', ['Dada kiri']),
        ('Ukuran bordir', 'bsize', ['5 cm', '8 cm', '10 cm']),
      ]),
  'hijab': _Cfg('Warna hijab', 'Isi jumlah tiap ukuran untuk setiap warna. Ukuran segi empat adalah sisi × sisi.',
      [('Anak', '90 × 90 cm'), ('Standar', '110 × 110 cm'), ('Besar', '120 × 120 cm')], [6, 20, 4], '+ Ukuran lain (sisi × sisi)',
      'Tulis permintaan khusus, mis. warna benang tepi atau ukuran jahitan', 'Bordir hijab',
      [('Posisi (bisa lebih dari satu)', 'pos', ['Pojok depan', 'Tepi bawah', 'Tengah depan']), ('Ukuran bordir', 'bsize', ['2 cm', '3 cm', '5 cm'])]),
  'kaoskaki': _Cfg('Warna kaos kaki', 'Isi jumlah pasang tiap ukuran untuk setiap warna.',
      [('Anak', 'Ukuran sepatu 28–34'), ('S', 'Ukuran sepatu 35–38'), ('M', 'Ukuran sepatu 39–42'), ('L', 'Ukuran sepatu 43–46')],
      [4, 6, 8, 6], '+ Ukuran lain', 'Tulis permintaan khusus, mis. tinggi garis atau letak logo', 'Logo kaos kaki', [
        ('Teknik logo', 'logoTech', ['Rajut (tenun)', 'Bordir', 'Sablon']),
        ('Posisi (bisa lebih dari satu)', 'pos', ['Pergelangan', 'Sisi luar', 'Punggung kaki', 'Telapak']),
        ('Ukuran logo', 'bsize', ['2 cm', '3 cm', '4 cm']),
      ],
      pre: [('Garis di ujung atas', 'stripes', ['Tanpa garis', '1 garis', '2 garis', '3 garis'])]),
  'dasi': _Cfg('Warna dasi', 'Isi jumlah tiap ukuran untuk setiap warna. Ukuran dasi adalah panjang × lebar.',
      [('Dewasa', '± 145 × 8 cm'), ('Remaja', '± 120 × 7 cm'), ('Anak', '± 90 × 6 cm')], [12, 0, 3], '+ Ukuran lain (panjang × lebar)',
      'Tulis permintaan khusus, mis. lebar dasi atau warna garis', 'Bordir logo', [
        ('Posisi (bisa lebih dari satu)', 'pos', ['Ujung bawah', 'Bagian tengah', 'Berulang']),
        ('Ukuran bordir', 'bsize', ['3 cm', '5 cm', '8 cm']),
      ]),
  'topi': _Cfg('Warna topi', 'Isi jumlah tiap ukuran untuk setiap warna.', [('Dewasa', null), ('Anak', null)], [20, 4], null,
      'Tulis permintaan khusus, mis. tinggi topi atau warna jahitan', 'Bordir topi', [
        ('Posisi (bisa lebih dari satu)', 'pos', ['Depan', 'Samping kiri', 'Samping kanan', 'Belakang']),
        ('Jenis bordir', 'bordirType', ['Datar', 'Timbul (3D)']),
        ('Ukuran bordir', 'bsize', ['5 cm', '6 cm', '8 cm']),
      ],
      pre: [('Pengait belakang', 'closure', ['Strap logam', 'Snap plastik', 'Velcro', 'Karet'])],
      sizeNote: 'Dewasa: lingkar kepala sekitar 56–60 cm, bisa diatur. Anak: sekitar 52–54 cm.'),
};

/// Letak bordir per barang (mengikuti referensi "Posisi bordir per barang").
const _positions = {
  'Seragam': ['Dada kiri', 'Dada kanan', 'Lengan kiri', 'Lengan kanan', 'Punggung', 'Kerah', 'Saku'],
  'Kemeja': ['Dada kiri', 'Dada kanan', 'Saku', 'Lengan kiri', 'Lengan kanan', 'Kerah', 'Manset'],
  'Kaos': ['Dada kiri', 'Dada kanan', 'Dada tengah', 'Lengan', 'Punggung', 'Kerah belakang'],
  'Jaket': ['Dada kiri', 'Dada kanan', 'Lengan kiri', 'Lengan kanan', 'Punggung', 'Tudung'],
  'Rompi': ['Dada kiri', 'Dada kanan', 'Punggung', 'Saku'],
  'Batik': ['Dada kiri', 'Dada kanan', 'Lengan kiri', 'Lengan kanan', 'Punggung', 'Kerah', 'Saku'],
  'Topi': ['Depan', 'Samping kiri', 'Samping kanan', 'Belakang'],
  'Dasi': ['Ujung bawah', 'Bagian tengah'],
  'Kaos Kaki': ['Pergelangan', 'Sisi luar'],
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
  final qt = TextEditingController();
  int tab = 0;
  String? get design => d.designName;
  Uint8List? get designBytes => d.designBytes;
  String? get bordirDesign => d.bordirName;
  Uint8List? get bordirBytes => d.bordirBytes;

  Future<void> _pickDesign() async {
    final f = await pickFile(ext: kDesignExt);
    if (f != null) {
      setState(() {
        d.designName = f.name;
        d.designBytes = f.isImage ? f.bytes : null;
        d.hasDesign = true;
      });
    }
  }

  Future<void> _pickBordir() async {
    final f = await pickFile(ext: kDesignExt);
    if (f != null) {
      setState(() {
        d.bordirName = f.name;
        d.bordirBytes = f.isImage ? f.bytes : null;
        d.hasDesign = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final list = _positions[d.product] ?? _clothesPos;
    d.positions.removeWhere((x) => !list.contains(x));
    if (d.positions.isEmpty) d.positions = {list.first};
  }

  @override
  void dispose() {
    q.dispose();
    qt.dispose();
    super.dispose();
  }

  void _showPrice() => showPriceSheet(
        context,
        subtitle: d.kind == 'bordir'
            ? 'Bordir · ${d.product} · ${d.qty} pcs'
            : '${d.product} · ${d.ownMaterial ? 'bahan sendiri' : d.fabric} · ${d.qty} ${d.unitName}',
        lines: draftLines(d),
        qty: d.qty,
        dp: d.dp,
      );

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
      final (label, key, rawItems) = list[i];
      final items = key == 'pos' ? (_positions[d.product] ?? rawItems) : rawItems;
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
        PriceLink(_showPrice),
        Btn(button, d.qty > 0 ? _next : null),
      ]);

  // ---------- Bordir saja ----------
  Widget _bordir() {
    final pos = _positions[d.product] ?? _clothesPos;
    final tp = filterColors(kThreads, qt.text);
    final tHex = parseHex(qt.text);
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
        PriceLink(_showPrice),
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
        const SectionRow('Desain bordir'),
        UploadBox(bordirDesign != null, _pickBordir,
            title: 'Unggah desain bordir', sub: 'Logo atau gambar yang akan dibordir', fileName: bordirDesign, preview: bordirBytes),
        const SizedBox(height: 12),
        PillField('Atau tulis nama / teks untuk dibordir', onChanged: (v) => d.text = v),
        SectionRow('Posisi bordir', trailing: 'Untuk ${d.product.toLowerCase()}'),
        const Sub('Pilihan posisi menyesuaikan barang. Bisa lebih dari satu.'),
        Chips(pos, (x) => d.positions.contains(x), (x) => setState(() => d.positions.contains(x) ? d.positions.remove(x) : d.positions.add(x))),
        const Label('Ukuran bordir'),
        _bsizeChips(const ['5 cm', '8 cm', '10 cm']),
        SectionRow('Warna benang', trailing: '${d.threads.length} dipilih'),
        PillField('Cari warna benang atau kode', ctrl: qt, search: true, onChanged: (_) => setState(() {})),
        if (tHex != null && !tp.any((e) => hexOf(e.$2) == hexOf(tHex)))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutChip('Tambah warna ${hexOf(tHex)}', () => setState(() {
                    final n = hexOf(tHex);
                    kCustomColors[n] = tHex;
                    d.threads.add(n);
                    qt.clear();
                  })),
            ),
          ),
        const SizedBox(height: 14),
        ColorGrid(tp, d.threads, (x) => setState(() => d.threads.contains(x) ? d.threads.remove(x) : d.threads.add(x))),
        const Label('Jumlah barang'),
        Box(
          child: Row(children: [
            Expanded(child: Text('Barang yang dibordir', style: t(13, color: C.muted))),
            QtyStepper(d.itemQty, (v) => setState(() => d.itemQty = v)),
          ]),
        ),
        const Label('Catatan'),
        NoteField('Tulis permintaan khusus, mis. warna benang atau letak tulisan', d.note, (v) => d.note = v),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (d.kind == 'bordir') return _bordir();
    final c = _cfg[d.kind]!;
    final query = q.text.trim().toLowerCase();
    final palette = filterColors(kPalette, query);
    final hex = parseHex(query);
    final canAdd = hex != null && !palette.any((e) => hexOf(e.$2) == hexOf(hex));
    final chosen = d.colors.toList();
    if (tab >= chosen.length) tab = 0;
    final List<(String, String?)> rows = [...c.rows, for (final e in d.extraSizes) (e, null)];
    Map<String, int>? cur;
    if (chosen.isNotEmpty) {
      cur = d.sizes.putIfAbsent(chosen[tab], () => {for (var i = 0; i < c.rows.length; i++) c.rows[i].$1: 0});
    }
    return stepScreen(
      2,
      'Warna & ukuran',
      bottom: _totalBar('Lanjut ke pembayaran'),
      children: [
        SectionRow(const {'jahit': 'Desain pakaian', 'hijab': 'Desain hijab', 'kaoskaki': 'Desain kaos kaki', 'dasi': 'Desain dasi', 'topi': 'Desain topi'}[d.kind] ?? 'Desain'),
        UploadBox(design != null, _pickDesign,
            title: 'Unggah desain produk', sub: 'Pola, motif, atau referensi model', fileName: design, preview: designBytes),
        SectionRow(c.colorLabel, trailing: '${d.colors.length} dipilih'),
        PillField('Cari nama atau kode warna', ctrl: q, search: true, onChanged: (_) => setState(() {})),
        if (canAdd)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutChip('Tambah warna ${hexOf(hex)}', () => setState(() {
                    final n = hexOf(hex);
                    kCustomColors[n] = hex;
                    d.colors.add(n);
                    q.clear();
                  })),
            ),
          ),
        const SizedBox(height: 14),
        if (palette.isEmpty && !canAdd) const Sub('Warna tidak ditemukan. Coba kode hex, mis. #7B1E2B.'),
        ColorGrid(palette, d.colors, (x) => setState(() => d.colors.contains(x) ? d.colors.remove(x) : d.colors.add(x))),
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
          Box(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.only(bottom: 10), child: Text('Desain bordir', style: t(12.5, color: C.muted))),
              UploadBox(bordirDesign != null, _pickBordir,
                  title: 'Unggah desain bordir', sub: 'Logo atau gambar yang akan dibordir', fileName: bordirDesign, preview: bordirBytes),
              const SizedBox(height: 18),
              _section(c.card),
            ]),
          ),
        ],
        const Label('Catatan'),
        NoteField(c.noteHint, d.note, (v) => d.note = v),
      ],
    );
  }
}

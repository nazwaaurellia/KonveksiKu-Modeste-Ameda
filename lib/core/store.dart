import 'package:flutter/material.dart';

/// Status pesanan. Alurnya: DP -> verifikasi admin -> desain -> bordir -> selesai -> diambil.
enum St { menungguDp, menungguVerifikasi, menungguDesain, dibordir, selesai, diambil }

// Harga (bisa diubah sesuai kebutuhan)
const kBase = {'Kemeja': 85000, 'Kaos': 55000, 'Seragam': 90000, 'Jaket': 150000, 'Topi': 35000, 'Dasi': 30000, 'Kaos Kaki': 15000, 'Hijab': 45000, 'Rompi': 70000, 'Batik': 95000, 'Tas': 60000};
const kBordir = {'5 cm': 5000, '8 cm': 8000, '10 cm': 12000};
/// Harga bordir per posisi untuk semua ukuran di form pelanggan.
const kBordirAll = {'2 cm': 3000, '3 cm': 4000, '4 cm': 4500, '5 cm': 5000, '6 cm': 6000, '8 cm': 8000, '10 cm': 12000};
const kSteps = ['Pesanan diterima', 'DP terverifikasi', 'Desain disetujui', 'Dibordir', 'Selesai', 'Siap diambil'];
const kMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

class Order {
  final String id, title, customer, product, service, fabric, colors, size, bsize, note, created;
  final int qty, unit;
  St status;
  int dpPaid, paidWeek;
  bool revisi, hasDesign;
  String operator;

  Order({
    required this.id,
    required this.title,
    required this.customer,
    required this.product,
    required this.qty,
    required this.unit,
    required this.status,
    required this.created,
    this.service = 'Jahit Baju',
    this.fabric = 'Drill',
    this.colors = 'Hitam, Merah',
    this.size = 'M, L, XL',
    this.bsize = '8 cm',
    this.note = '',
    this.dpPaid = 0,
    this.paidWeek = 0,
    this.revisi = false,
    this.hasDesign = true,
    this.operator = '-',
  });

  int get total => qty * unit;
  int get dp => total ~/ 2;
  int get remaining => total - dpPaid;
  bool get isDone => status == St.selesai || status == St.diambil;

  /// Jumlah tahap yang sudah selesai (0..6).
  int get step {
    switch (status) {
      case St.menungguDp:
      case St.menungguVerifikasi:
        return 1;
      case St.menungguDesain:
        return 2;
      case St.dibordir:
        return 3;
      case St.selesai:
        return 5;
      case St.diambil:
        return 6;
    }
  }

  double get progress => step / 6;

  String get label {
    switch (status) {
      case St.menungguDp:
        return 'Menunggu DP';
      case St.menungguVerifikasi:
        return 'Verifikasi DP';
      case St.menungguDesain:
        return revisi ? 'Perlu revisi' : 'Menunggu desain';
      case St.dibordir:
        return 'Dibordir';
      case St.selesai:
        return 'Selesai';
      case St.diambil:
        return 'Diambil';
    }
  }

  String get _now {
    switch (status) {
      case St.menungguDp:
        return 'Menunggu pembayaran DP';
      case St.menungguVerifikasi:
        return 'Menunggu verifikasi admin';
      case St.menungguDesain:
        return 'Menunggu persetujuan desain';
      case St.dibordir:
        return 'Sedang berjalan';
      case St.selesai:
        return 'Silakan ambil pesanan';
      case St.diambil:
        return '';
    }
  }

  List<List<String>> get timeline => [
        for (var i = 0; i < kSteps.length; i++) [kSteps[i], i == step ? _now : (i == 0 ? created : '')],
      ];
}

class StockItem {
  final String name, cat, unit;
  final Color color;
  final int max;
  int qty;
  StockItem(this.name, this.cat, this.color, this.qty, this.max, this.unit);
  bool get low => qty <= 3;
}

/// Isian form pemesanan pelanggan (belum jadi pesanan sampai dikirim).
class OrderDraft {
  String service = 'Jahit Baju', product = 'Seragam', fabric = 'Polyester', model = '';
  String bsize = '8 cm', note = '', text = '';
  bool bordir = true, hasDesign = false, ownMaterial = false;
  int itemQty = 48; // jumlah barang (khusus Bordir saja)
  Set<String> colors = {'Hitam', 'Merah'};
  Set<String> positions = {};
  Set<String> threads = {'Hitam', 'Kuning'};
  /// Pilihan tunggal lain: finishing, motif, closure, stripes, logoTech, bordirType.
  final Map<String, String> opt = {};
  /// warna -> ukuran -> jumlah
  final Map<String, Map<String, int>> sizes = {};
  final List<String> extraSizes = [];

  bool get jahit => service == 'Jahit Baju';

  /// Jenis form: jahit, topi, dasi, hijab, kaoskaki, atau bordir (Bordir saja).
  String get kind => !jahit
      ? 'bordir'
      : (const {'Topi': 'topi', 'Dasi': 'dasi', 'Hijab': 'hijab', 'Kaos Kaki': 'kaoskaki'}[product] ?? 'jahit');
  String get unitName => kind == 'kaoskaki' ? 'pasang' : 'pcs';

  int colorQty(String c) => (sizes[c]?.values ?? const <int>[]).fold(0, (a, b) => a + b);
  int get qty => kind == 'bordir' ? itemQty : colors.fold(0, (a, c) => a + colorQty(c));

  bool get withBordir => !jahit || bordir;
  int get posCount => positions.isEmpty ? 1 : positions.length;
  int get bordirUnit => withBordir ? (kBordirAll[bsize] ?? 6000) * posCount : 0;
  int get baseUnit => jahit ? ((kBase[product] ?? 0) * (ownMaterial ? 0.6 : 1)).round() : 0;
  int get unit => baseUnit + bordirUnit;
  int get total => unit * qty;
  int get dp => total ~/ 2;

  /// Nilai awal sesuai jenis form (dipanggil saat layanan dipilih).
  void initKind() {
    const bs = {'jahit': '8 cm', 'bordir': '8 cm', 'topi': '6 cm', 'hijab': '3 cm', 'kaoskaki': '3 cm', 'dasi': '5 cm'};
    const fb = {'jahit': 'Polyester', 'topi': 'Drill', 'dasi': 'Polyester', 'hijab': 'Voal', 'kaoskaki': 'Katun + spandex'};
    const col = {
      'hijab': {'Maroon', 'Biru dongker'},
      'kaoskaki': {'Hitam', 'Biru dongker'},
      'dasi': {'Biru dongker', 'Maroon'},
    };
    bsize = bs[kind] ?? '8 cm';
    fabric = fb[kind] ?? 'Polyester';
    colors = {...(col[kind] ?? {'Hitam', 'Merah'})};
    positions = {};
    sizes.clear();
    extraSizes.clear();
    opt.clear();
    model = '';
  }
}

/// Data bersama untuk pelanggan dan admin (disimpan di memori, tanpa backend).
class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore I = AppStore._();

  String userName = 'Sari', userEmail = 'sari@email.com';
  bool isAdmin = false;
  OrderDraft draft = OrderDraft();
  int _next = 143;
  final Map<String, String> _users = {};

  final List<Order> orders = [
    Order(id: 'BK-0142', title: 'Seragam PKK', customer: 'Sari', product: 'Seragam', qty: 48, unit: 8000, status: St.dibordir, dpPaid: 192000, paidWeek: 4, operator: 'Dani', created: '10 Nov', note: 'Logo di dada kiri, benang emas agak tebal.'),
    Order(id: 'BK-0141', title: 'Topi komunitas', customer: 'Sari', product: 'Topi', service: 'Bordir Saja', fabric: 'Bahan sendiri', qty: 100, unit: 8000, status: St.menungguDp, created: '12 Nov'),
    Order(id: 'BK-0139', title: 'Jaket angkatan', customer: 'Sari', product: 'Jaket', qty: 30, unit: 90000, status: St.diambil, dpPaid: 2700000, paidWeek: 1, operator: 'Rina', created: '28 Okt'),
    Order(id: 'BK-0138', title: 'Tas seminar', customer: 'Sari', product: 'Tas', qty: 60, unit: 60000, status: St.selesai, dpPaid: 1800000, paidWeek: 3, operator: 'Dani', created: '5 Nov'),
  ];

  final List<StockItem> stock = [
    StockItem('Hitam', 'Benang', const Color(0xFF2B1D0E), 3, 20, 'kon'),
    StockItem('Putih', 'Benang', Colors.white, 14, 20, 'kon'),
    StockItem('Merah', 'Benang', const Color(0xFFC0392B), 9, 20, 'kon'),
    StockItem('Emas', 'Benang', const Color(0xFFD4A82A), 6, 20, 'kon'),
    StockItem('Drill', 'Kain', const Color(0xFF8B6B3E), 12, 30, 'roll'),
    StockItem('Katun', 'Kain', const Color(0xFFD9C9A3), 20, 30, 'roll'),
    StockItem('Jarum no. 14', 'Jarum', Colors.blueGrey, 40, 60, 'pak'),
    StockItem('Kancing', 'Aksesori', Colors.brown, 200, 300, 'pak'),
  ];

  // ---------- Akun ----------
  void login(String email) {
    final e = email.trim().toLowerCase();
    userEmail = e;
    isAdmin = e.contains('admin');
    if (isAdmin) {
      userName = 'Admin';
    } else if (_users.containsKey(e)) {
      userName = _users[e]!;
    } else {
      final p = e.split('@').first;
      userName = p.isEmpty ? 'Sari' : p[0].toUpperCase() + p.substring(1);
    }
    notifyListeners();
  }

  void register(String name, String email) => _users[email.trim().toLowerCase()] = name.trim();

  // ---------- Pelanggan ----------
  List<Order> get mine => orders.where((o) => o.customer == userName).toList();

  Order? get activeMine {
    for (final o in mine) {
      if (!o.isDone) return o;
    }
    return null;
  }

  String _today() {
    final n = DateTime.now();
    return '${n.day} ${kMonths[n.month - 1]}';
  }

  String _newId() => 'BK-${(_next++).toString().padLeft(4, '0')}';

  Order submitDraft({required bool proof}) {
    final d = draft;
    final o = Order(
      id: _newId(),
      title: d.jahit ? d.product : 'Bordir ${d.product}',
      customer: userName,
      product: d.product,
      service: d.service,
      fabric: d.jahit ? d.fabric : 'Bahan sendiri',
      colors: d.colors.join(', '),
      size: d.kind,
      bsize: d.bsize,
      note: d.note,
      qty: d.qty,
      unit: d.unit,
      hasDesign: d.hasDesign,
      status: proof ? St.menungguVerifikasi : St.menungguDp,
      created: _today(),
    );
    orders.insert(0, o);
    draft = OrderDraft();
    notifyListeners();
    return o;
  }

  void sendProof(Order o) {
    o.status = St.menungguVerifikasi;
    notifyListeners();
  }

  // ---------- Admin ----------
  void verifyDp(Order o) {
    o.dpPaid = o.dp;
    o.paidWeek = 4;
    o.status = St.menungguDesain;
    notifyListeners();
  }

  void approveDesign(Order o) {
    o.revisi = false;
    o.operator = 'Dani';
    o.status = St.dibordir;
    _use('Emas');
    notifyListeners();
  }

  void requestRevision(Order o) {
    o.revisi = true;
    notifyListeners();
  }

  void markDone(Order o) {
    o.status = St.selesai;
    notifyListeners();
  }

  void markPickedUp(Order o) {
    o.dpPaid = o.total;
    o.paidWeek = 4;
    o.status = St.diambil;
    notifyListeners();
  }

  void addAdminOrder({required String customer, required String product, required String bsize, required int qty}) {
    final o = Order(
      id: _newId(),
      title: product,
      customer: customer,
      product: product,
      service: 'Bordir Saja',
      fabric: 'Bahan sendiri',
      bsize: bsize,
      qty: qty,
      unit: kBordir[bsize] ?? 0,
      status: St.menungguDesain,
      created: _today(),
      paidWeek: 4,
    );
    o.dpPaid = o.dp;
    orders.insert(0, o);
    notifyListeners();
  }

  void adjustStock(StockItem s, int delta) {
    s.qty = (s.qty + delta).clamp(0, s.max).toInt();
    notifyListeners();
  }

  void _use(String name) {
    for (final s in stock) {
      if (s.cat == 'Benang' && s.name == name) s.qty = (s.qty - 1).clamp(0, s.max).toInt();
    }
  }

  // ---------- Ringkasan ----------
  int get income => orders.fold(0, (a, o) => a + o.dpPaid);
  int get receivable => orders.where((o) => o.dpPaid > 0 && o.remaining > 0).fold(0, (a, o) => a + o.remaining);
  int get activeCount => orders.where((o) => !o.isDone).length;
  List<Order> get pendingVerify => orders.where((o) => o.status == St.menungguVerifikasi).toList();
  int get needsAction => pendingVerify.length + orders.where((o) => o.status == St.menungguDesain).length;

  List<int> get weekly {
    final w = [0, 0, 0, 0];
    for (final o in orders) {
      if (o.paidWeek >= 1 && o.paidWeek <= 4) w[o.paidWeek - 1] += o.dpPaid;
    }
    return w;
  }
}

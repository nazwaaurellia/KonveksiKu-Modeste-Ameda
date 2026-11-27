import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/files.dart';
import '../../core/order_ui.dart';
import '../../core/store.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import 'chat_screen.dart';
import 'customer_shell.dart';

const _wallets = ['GoPay', 'OVO', 'DANA', 'ShopeePay', 'LinkAja'];
const _banks = ['BRI', 'BCA', 'Mandiri'];
const _holder = 'Nazwa Aurellia Ababiluna Putri';
const _walletNo = '082338958254';
const _bankNo = {'BRI': '1234 5678 90', 'BCA': '0987 6543 21', 'Mandiri': '1122 3344 55'};

/// Pembayaran DP. Jika [order] diisi, pelanggan membayar untuk pesanan yang sudah ada.
/// [remainder] = pelunasan sisa tagihan.
class PaymentScreen extends StatefulWidget {
  final Order? order;
  final bool remainder;
  const PaymentScreen({this.order, this.remainder = false, super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'Transfer bank', wallet = 'DANA', bank = 'BRI';
  String? proof;
  Uint8List? proofBytes;

  Future<void> _pickProof() async {
    final f = await pickFile(ext: kProofExt);
    if (f != null) {
      setState(() {
        proof = f.name;
        proofBytes = f.isImage ? f.bytes : null;
      });
    }
  }

  Future<void> _saveQr() async {
    try {
      final data = await rootBundle.load('assets/images/qris.png');
      final ok = await saveBytes('qris-konveksiku.png', data.buffer.asUint8List());
      if (mounted) toast(context, ok ? 'QR disimpan' : 'QR gagal disimpan');
    } catch (_) {
      if (mounted) toast(context, 'QR gagal disimpan');
    }
  }

  String get _methodLabel => method == 'E-wallet' ? 'E-wallet $wallet' : (method == 'Transfer bank' ? 'Transfer bank $bank' : 'QRIS');

  void _send(int amount) {
    if (proof == null) return toast(context, 'Unggah bukti pembayaran dulu');
    final s = AppStore.I;
    Order o;
    if (widget.order != null) {
      o = widget.order!;
      if (!widget.remainder) s.sendProof(o);
    } else {
      o = s.submitDraft(proof: true);
    }
    goReplaceAll(context, PaymentSentScreen(o, _methodLabel, amount, widget.remainder));
  }

  void _later() {
    final o = AppStore.I.submitDraft(proof: false);
    goReplaceAll(context, PaymentSavedScreen(o));
  }

  Widget _radioRow(String name, bool on, VoidCallback onTap, {bool last = false}) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: C.sand))),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundColor: const Color(0xFFF1E4C8), child: Text(name[0], style: t(13, color: C.brown, w: FontWeight.w800))),
            const SizedBox(width: 12),
            Expanded(child: Text(name, style: t(14, w: FontWeight.w600))),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: on ? C.brown : const Color(0xFFD1BC8E), width: 2)),
              child: on ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: C.brown, shape: BoxShape.circle))) : null,
            ),
          ]),
        ),
      );

  Widget _destination(int amount) {
    if (method == 'QRIS') {
      return Column(children: [
        Box(
          child: Column(children: [
            Text('Scan QRIS untuk membayar', style: t(15, w: FontWeight.w800)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE6D7B5)),
              ),
              child: Image.asset(
                'assets/images/qris.png',
                width: 220,
                height: 220,
                filterQuality: FilterQuality.none,
                errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_2, size: 200, color: C.ink),
              ),
            ),
            const SizedBox(height: 16),
            Text(rp(amount), style: h(30, C.brown)),
            const SizedBox(height: 8),
            Text('a.n. $_holder\nBisa dibayar lewat aplikasi bank atau e-wallet apa saja.',
                textAlign: TextAlign.center, style: t(12.5, color: C.muted).copyWith(height: 1.45)),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _saveQr,
              icon: const Icon(Icons.file_download_outlined, size: 18, color: C.brown),
              label: Text('Simpan QR ke galeri', style: t(13, color: C.brown, w: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: C.brown),
                shape: const StadiumBorder(),
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 22),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Pastikan nominal sesuai sebelum membayar.', style: t(12, color: C.muted)),
        ),
      ]);
    }
    final isW = method == 'E-wallet';
    final name = isW ? wallet : bank;
    final no = isW ? _walletNo : _bankNo[bank]!;
    return Box(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(isW ? 'Kirim ke $name' : 'Transfer ke $name', style: t(13, color: C.muted)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text(no, style: h(24))),
          SizedBox(
            width: 92,
            child: Btn('Salin', () {
              Clipboard.setData(ClipboardData(text: no.replaceAll(' ', '')));
              toast(context, 'Nomor disalin');
            }, compact: true, light: true),
          ),
        ]),
        const SizedBox(height: 6),
        Text('a.n. $_holder', style: t(13, color: C.muted)),
        Divider(height: 24, color: C.sand),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Nominal', style: t(14)),
          Text(rp(amount), style: h(20)),
        ]),
        const SizedBox(height: 6),
        Text(isW ? 'Buka aplikasi $name, pilih Kirim, masukkan nomor dan nominal di atas.' : 'Transfer sesuai nominal di atas agar mudah diverifikasi.',
            style: t(12.5, color: C.muted).copyWith(height: 1.4)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final d = AppStore.I.draft;
    final rem = widget.remainder;
    final title = o != null ? o.title : (d.kind == 'bordir' ? '${d.product} · bordir saja' : '${d.product} · ${d.fabric} · ${d.colors.length} warna');
    final qty = o?.qty ?? d.qty;
    final total = o?.total ?? d.total;
    final amount = rem ? o!.remaining : (o?.dp ?? d.dp);
    final sub = o != null ? '$qty pcs · #${o.id}' : '$qty ${d.unitName}${d.withBordir ? ' · bordir ${d.bsize}' : ''}';
    return Screen(
      title: rem ? 'Pelunasan' : 'Pembayaran DP',
      back: true,
      action: Text('Langkah 3 dari 3', style: t(12, color: C.muted)),
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        Btn('Kirim bukti pembayaran', () => _send(amount)),
        if (o == null) ...[const SizedBox(height: 8), Btn('Bayar nanti', _later, light: true)],
        const SizedBox(height: 6),
        Text(rem ? 'Pesanan bisa diambil setelah pelunasan terverifikasi.' : 'Pesanan mulai diproses setelah DP terverifikasi.',
            style: t(12, color: C.muted), textAlign: TextAlign.center),
        HelpLink(order: o),
      ]),
      children: [
        const StepBar(3),
        const SizedBox(height: 14),
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: t(16, w: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(sub, style: t(13, color: C.muted)),
            Divider(height: 22, color: C.sand),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total pesanan', style: t(14)),
              Text(rp(total), style: t(14)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(rem ? 'Sisa tagihan' : 'DP 50%', style: t(14, w: FontWeight.w800)),
              Text(rp(amount), style: h(24, C.brown)),
            ]),
            if (!rem) ...[
              const SizedBox(height: 8),
              Text('Sisa ${rp(total - amount)} dibayar saat pesanan selesai.', style: t(13, color: C.muted)),
            ],
          ]),
        ),
        const Label('Metode pembayaran'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final x in ['Transfer bank', 'QRIS', 'E-wallet']) Choice(x, method == x, () => setState(() => method = x)),
        ]),
        if (method == 'E-wallet') ...[
          const Label('Pilih e-wallet'),
          Box(
            child: Column(children: [
              for (var i = 0; i < _wallets.length; i++)
                _radioRow(_wallets[i], wallet == _wallets[i], () => setState(() => wallet = _wallets[i]), last: i == _wallets.length - 1),
            ]),
          ),
        ],
        if (method == 'Transfer bank') ...[
          const Label('Pilih bank'),
          Box(
            child: Column(children: [
              for (var i = 0; i < _banks.length; i++)
                _radioRow(_banks[i], bank == _banks[i], () => setState(() => bank = _banks[i]), last: i == _banks.length - 1),
            ]),
          ),
        ],
        const SizedBox(height: 4),
        _destination(amount),
        GestureDetector(
          onTap: _pickProof,
          child: CustomPaint(
            painter: _DashedBox(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              child: Column(children: [
                if (proofBytes != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(color: Colors.white, child: Image.memory(proofBytes!, height: 170, width: double.infinity, fit: BoxFit.contain)),
                    ),
                  ),
                Text(proof != null ? '✓ $proof' : 'Unggah bukti pembayaran',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t(15, w: FontWeight.w800, color: proof != null ? C.green : C.ink)),
                const SizedBox(height: 4),
                Text(proof != null ? 'Ketuk untuk mengganti berkas' : 'Admin memverifikasi maksimal 1 jam', style: t(13, color: C.muted)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DashedBox extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(22)));
    final paint = Paint()
      ..color = const Color(0xFFD8B97A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 9) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

Widget _halo(Color c, IconData icon) => Center(
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(color: c.withOpacity(.16), shape: BoxShape.circle),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 42),
          ),
        ),
      ),
    );

Widget _row(String a, String b, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(a, style: t(14)),
        Flexible(child: Text(b, style: t(14, w: bold ? FontWeight.w800 : FontWeight.w500), textAlign: TextAlign.right)),
      ]),
    );

/// Setelah bukti pembayaran dikirim.
class PaymentSentScreen extends StatelessWidget {
  final Order o;
  final String method;
  final int amount;
  final bool remainder;
  const PaymentSentScreen(this.o, this.method, this.amount, this.remainder, {super.key});
  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        onBack: () => goReplaceAll(context, const CustomerShell()),
        bottom: Column(mainAxisSize: MainAxisSize.min, children: [
          Btn('Lacak pesanan', () => goReplaceAll(context, const CustomerShell(initial: 2)), icon: Icons.chevron_right),
          const SizedBox(height: 8),
          Btn('Kembali ke beranda', () => goReplaceAll(context, const CustomerShell()), light: true),
          HelpLink(order: o),
        ]),
        children: [
          const SizedBox(height: 24),
          _halo(C.green, Icons.check),
          const SizedBox(height: 22),
          Text('Bukti pembayaran terkirim', textAlign: TextAlign.center, style: h(22)),
          const SizedBox(height: 8),
          Text('Admin akan memverifikasi maksimal 1 jam. Kami memberi tahu kamu setelah ${remainder ? 'pelunasan' : 'DP'} terverifikasi.',
              textAlign: TextAlign.center, style: t(13, color: C.muted).copyWith(height: 1.45)),
          const SizedBox(height: 20),
          Box(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(o.title, style: t(17, w: FontWeight.w800)),
                    Text('#${o.id} · ${o.qty} pcs', style: t(12, color: C.muted)),
                  ]),
                ),
                const Tag('Menunggu verifikasi'),
              ]),
              Divider(height: 22, color: C.sand),
              _row(remainder ? 'Pelunasan' : 'DP dibayar (50%)', rp(amount), bold: true),
              _row('Metode', method),
              if (!remainder) _row('Sisa tagihan', rp(o.total - amount)),
              if (!remainder) Text('Sisa tagihan dibayar saat pesanan selesai.', style: t(12, color: C.muted)),
            ]),
          ),
        ],
      );
}

/// Setelah memilih "Bayar nanti".
class PaymentSavedScreen extends StatelessWidget {
  final Order o;
  const PaymentSavedScreen(this.o, {super.key});
  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        onBack: () => goReplaceAll(context, const CustomerShell()),
        bottom: Column(mainAxisSize: MainAxisSize.min, children: [
          Btn('Bayar DP sekarang', () => go(context, PaymentScreen(order: o)), icon: Icons.chevron_right),
          const SizedBox(height: 8),
          Btn('Lihat di Lacak pesanan', () => goReplaceAll(context, const CustomerShell(initial: 2)), light: true),
          HelpLink(order: o),
        ]),
        children: [
          const SizedBox(height: 24),
          _halo(C.brown, Icons.schedule),
          const SizedBox(height: 22),
          Text('Pesanan disimpan', textAlign: TextAlign.center, style: h(24)),
          const SizedBox(height: 8),
          Text('Pesanan kamu belum diproses. Bayar DP kapan saja untuk memulai produksi.',
              textAlign: TextAlign.center, style: t(13.5, color: C.muted).copyWith(height: 1.45)),
          const SizedBox(height: 20),
          Box(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(o.title, style: t(17, w: FontWeight.w800)),
                    Text('#${o.id} · ${o.qty} pcs', style: t(12, color: C.muted)),
                  ]),
                ),
                const Tag('Menunggu DP'),
              ]),
              Divider(height: 22, color: C.sand),
              _row('Total pesanan', rp(o.total)),
              _row('DP 50% yang perlu dibayar', rp(o.dp), bold: true),
            ]),
          ),
          Box(
            color: const Color(0xFFFBEFD5),
            child: Text.rich(TextSpan(style: t(13.5).copyWith(height: 1.5), children: [
              const TextSpan(text: 'Produksi dimulai setelah DP terverifikasi. Pesanan ini ada di menu '),
              TextSpan(text: 'Lacak', style: t(13.5, w: FontWeight.w800)),
              const TextSpan(text: ' dengan status Menunggu DP.'),
            ])),
          ),
        ],
      );
}

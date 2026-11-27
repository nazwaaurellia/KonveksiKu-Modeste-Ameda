import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'store.dart';
import 'widgets.dart' show rp;

const kBankLine = 'BRI 3643 0104 1485 539';
const kBankHolder = 'Nazwa Aurellia Ababiluna Putri';

String _sentence(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

/// Isi invoice yang dipakai layar dan PDF.
class InvoiceInfo {
  final String number, date, orderNo, customer, email, item, detail, qtyLine, status;
  final int total, dpPaid, remaining;
  InvoiceInfo._(this.number, this.date, this.orderNo, this.customer, this.email, this.item, this.detail, this.qtyLine,
      this.status, this.total, this.dpPaid, this.remaining);

  factory InvoiceInfo.of(Order o, String email) => InvoiceInfo._(
        'INV-${o.id}',
        '${o.created} ${DateTime.now().year}',
        '#${o.id}',
        o.customer,
        email,
        '${o.title} · ${_sentence(o.service)}',
        o.detail.isNotEmpty ? o.detail : '${o.fabric} · ${o.colors}',
        '${o.qty} pcs × ${rp(o.unit)}',
        o.dpPaid == 0 ? 'Menunggu DP' : (o.remaining == 0 ? 'Lunas' : 'DP diterima'),
        o.total,
        o.dpPaid,
        o.remaining,
      );

  String get dpLabel => 'DP dibayar';
}

/// Buat berkas PDF invoice.
Future<Uint8List> buildInvoicePdf(Order o, String email) async {
  final i = InvoiceInfo.of(o, email);
  const brown = PdfColor.fromInt(0xFFA0680F);
  const ink = PdfColor.fromInt(0xFF2B1D0E);
  const muted = PdfColor.fromInt(0xFF7A6A55);
  const line = PdfColor.fromInt(0xFFE6D7B5);
  final doc = pw.Document(title: i.number, author: 'Konveksi Maju Jaya');

  pw.Widget row(String a, String b, {bool bold = false, PdfColor? color}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(a, style: pw.TextStyle(fontSize: 11, color: color ?? muted)),
          pw.Text(b, style: pw.TextStyle(fontSize: 11, color: ink, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ]),
      );
  pw.Widget label(String x) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text(x, style: pw.TextStyle(fontSize: 8.5, color: brown, fontWeight: pw.FontWeight.bold, letterSpacing: 1.2)),
      );
  pw.Widget div() => pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 12), child: pw.Divider(color: line, height: 1));

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Konveksi Maju Jaya', style: pw.TextStyle(fontSize: 18, color: ink, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 3),
            pw.Text('Bordir, jahit, dan perlengkapan seragam', style: const pw.TextStyle(fontSize: 10, color: muted)),
          ]),
          pw.Text('INVOICE', style: pw.TextStyle(fontSize: 12, color: brown, fontWeight: pw.FontWeight.bold, letterSpacing: 1.5)),
        ]),
        div(),
        row('No. invoice', i.number, bold: true),
        row('Tanggal', i.date),
        row('No. pesanan', i.orderNo),
        div(),
        label('DITAGIHKAN KEPADA'),
        pw.Text(i.customer, style: pw.TextStyle(fontSize: 12, color: ink, fontWeight: pw.FontWeight.bold)),
        if (i.email.isNotEmpty) pw.Text(i.email, style: const pw.TextStyle(fontSize: 10, color: muted)),
        div(),
        label('RINCIAN PESANAN'),
        pw.Text(i.item, style: pw.TextStyle(fontSize: 12, color: ink, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 2),
        pw.Text(i.detail, style: const pw.TextStyle(fontSize: 10, color: muted)),
        pw.SizedBox(height: 6),
        row(i.qtyLine, rp(i.total), bold: true),
        div(),
        row('Total', rp(i.total), bold: true, color: ink),
        if (i.dpPaid > 0) row('DP dibayar', '- ${rp(i.dpPaid)}'),
        pw.SizedBox(height: 6),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('Sisa tagihan', style: pw.TextStyle(fontSize: 12, color: ink, fontWeight: pw.FontWeight.bold)),
          pw.Text(rp(i.remaining), style: pw.TextStyle(fontSize: 20, color: ink, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.SizedBox(height: 14),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(color: const PdfColor.fromInt(0xFFFBEFD5), borderRadius: pw.BorderRadius.circular(8)),
          child: pw.RichText(
            text: pw.TextSpan(style: const pw.TextStyle(fontSize: 10, color: ink), children: [
              const pw.TextSpan(text: 'Bayar sisa tagihan ke '),
              pw.TextSpan(text: kBankLine, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.TextSpan(text: ' a.n. $kBankHolder.'),
            ]),
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Center(child: pw.Text('Terima kasih telah memesan.', style: const pw.TextStyle(fontSize: 9, color: muted))),
      ]),
    ),
  );
  return doc.save();
}

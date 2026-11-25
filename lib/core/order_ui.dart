import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets.dart';

/// Palet warna kain/produk dan benang.
const kPalette = <(String, Color)>[
  ('Hitam', Color(0xFF111111)), ('Putih', Color(0xFFFFFFFF)), ('Merah', Color(0xFFE53935)),
  ('Biru dongker', Color(0xFF1B2A5C)), ('Biru', Color(0xFF3F51B5)), ('Hijau tua', Color(0xFF2E7D5B)),
  ('Kuning', Color(0xFFFFC107)), ('Oranye', Color(0xFFF57C00)), ('Abu-abu', Color(0xFF9E9E9E)),
  ('Cokelat', Color(0xFF6D4C41)), ('Krem', Color(0xFFE8D9B5)), ('Pink', Color(0xFFF48FB1)),
  ('Ungu', Color(0xFF7E57C2)), ('Tosca', Color(0xFF26A69A)), ('Maroon', Color(0xFF7B1E2B)),
  ('Khaki', Color(0xFFC2A878)), ('Hijau', Color(0xFF4CAF50)), ('Cyan', Color(0xFF00ACC1)),
];
const kThreads = <(String, Color)>[
  ('Hitam', Color(0xFF111111)), ('Putih', Color(0xFFFFFFFF)), ('Merah', Color(0xFFE53935)),
  ('Biru dongker', Color(0xFF1B2A5C)), ('Biru', Color(0xFF3F51B5)), ('Hijau tua', Color(0xFF2E7D5B)),
  ('Kuning', Color(0xFFFFC107)), ('Emas', Color(0xFFC9A227)), ('Perak', Color(0xFFBDBDBD)),
  ('Oranye', Color(0xFFF57C00)), ('Cokelat', Color(0xFF6D4C41)), ('Pink', Color(0xFFF48FB1)),
];

/// Halaman langkah pemesanan: judul + "Langkah n dari 3" + 3 segmen progres.
Widget stepScreen(int n, String title, {required List<Widget> children, Widget? bottom}) => Screen(
      title: title,
      back: true,
      action: Text('Langkah $n dari 3', style: t(12, color: C.muted)),
      bottom: bottom,
      children: [StepBar(n), const SizedBox(height: 4), ...children],
    );

class StepBar extends StatelessWidget {
  final int step;
  const StepBar(this.step, {super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 1; i <= 3; i++)
          Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
              decoration: BoxDecoration(color: i <= step ? C.brown : C.sand, borderRadius: BorderRadius.circular(2)),
            ),
          ),
      ]);
}

/// Label bagian dengan teks kecil di kanan (mis. "2 dipilih").
class SectionRow extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionRow(this.title, {this.trailing, super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 12),
        child: Row(children: [
          Expanded(
            child: Text(title.toUpperCase(), style: t(11, color: C.brown, w: FontWeight.w800).copyWith(letterSpacing: 1.2)),
          ),
          if (trailing != null) Text(trailing!, style: t(12, color: C.muted, w: FontWeight.w700)),
        ]),
      );
}

class Sub extends StatelessWidget {
  final String text;
  const Sub(this.text, {super.key});
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: t(13, color: C.muted).copyWith(height: 1.4)));
}

class Pill extends StatelessWidget {
  final String text;
  const Pill(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(color: const Color(0xFFF1DFB5), borderRadius: BorderRadius.circular(16)),
          child: Text(text, style: t(12, color: const Color(0xFF6B4509), w: FontWeight.w800)),
        ),
      );
}

class OutChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const OutChip(this.text, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(border: Border.all(color: C.brown), borderRadius: BorderRadius.circular(18)),
          child: Text(text, style: t(12, color: C.brown, w: FontWeight.w700)),
        ),
      );
}

/// Kumpulan chip pilihan. [more] = chip bergaris tepi di akhir (mis. "Lihat semua bahan ›").
class Chips extends StatelessWidget {
  final List<String> items;
  final bool Function(String) isOn;
  final ValueChanged<String> onTap;
  final String? more;
  final VoidCallback? onMore;
  const Chips(this.items, this.isOn, this.onTap, {this.more, this.onMore, super.key});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final x in items) Choice(x, isOn(x), () => onTap(x)),
        if (more != null) OutChip(more!, onMore ?? () {}),
      ]);
}

class PillField extends StatelessWidget {
  final String hint;
  final TextEditingController? ctrl;
  final ValueChanged<String>? onChanged;
  final bool search;
  const PillField(this.hint, {this.ctrl, this.onChanged, this.search = false, super.key});
  @override
  Widget build(BuildContext context) => TextField(
        controller: ctrl,
        onChanged: onChanged,
        style: t(13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: t(13, color: C.muted.withOpacity(.8)),
          prefixIcon: search ? const Icon(Icons.search, size: 20, color: C.muted) : null,
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: search ? 8 : 18, vertical: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: const BorderSide(color: Color(0xFFE6D7B5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: const BorderSide(color: C.brown)),
        ),
      );
}

class NoteField extends StatelessWidget {
  final String hint;
  final String initial;
  final ValueChanged<String> onChanged;
  const NoteField(this.hint, this.initial, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => TextFormField(
        initialValue: initial,
        onChanged: onChanged,
        maxLines: 3,
        style: t(13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: t(13, color: C.muted.withOpacity(.8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFE6D7B5))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: C.brown)),
        ),
      );
}

class ToggleCard extends StatelessWidget {
  final String title, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const ToggleCard(this.title, this.sub, this.value, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => Box(
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: t(14, w: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(sub, style: t(11.5, color: C.muted)),
            ]),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: C.green,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD9C9A3),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ]),
      );
}

class _Dashed extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(22)));
    final paint = Paint()
      ..color = const Color(0xFFD8B97A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final PathMetric m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 9) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Kotak unggah berpinggir putus-putus.
class UploadBox extends StatelessWidget {
  final String title, sub;
  final bool attached;
  final VoidCallback onTap;
  const UploadBox(this.attached, this.onTap, {this.title = 'Unggah desain atau logo', this.sub = 'PNG, JPG, atau file desain', super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: _Dashed(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
            child: Column(children: [
              Icon(attached ? Icons.check_circle : Icons.upload, color: attached ? C.green : C.brown, size: 26),
              const SizedBox(height: 8),
              Text(attached ? 'Berkas dilampirkan' : title, style: t(14, w: FontWeight.w800, color: attached ? C.green : C.ink)),
              const SizedBox(height: 3),
              Text(attached ? 'Ketuk lagi untuk melepas' : sub, style: t(12, color: C.muted), textAlign: TextAlign.center),
            ]),
          ),
        ),
      );
}

/// Grid lingkaran warna (6 kolom). Terpilih = cincin cokelat + centang.
class ColorGrid extends StatelessWidget {
  final List<(String, Color)> colors;
  final Set<String> selected;
  final ValueChanged<String> onTap;
  const ColorGrid(this.colors, this.selected, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          for (final (name, c) in colors)
            GestureDetector(
              onTap: () => onTap(name),
              child: Tooltip(
                message: name,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: selected.contains(name) ? C.brown : Colors.transparent, width: 3),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c,
                      border: Border.all(color: C.ink.withOpacity(.12)),
                    ),
                    child: selected.contains(name)
                        ? Icon(Icons.check, size: 22, color: c.computeLuminance() > .6 ? C.ink : Colors.white)
                        : null,
                  ),
                ),
              ),
            ),
        ],
      );
}

class StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const StepBtn(this.icon, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.brown, width: 1.2)),
          child: Icon(icon, size: 20, color: C.brown),
        ),
      );
}

class QtyStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const QtyStepper(this.value, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        StepBtn(Icons.remove, () => onChanged(value > 0 ? value - 1 : 0)),
        SizedBox(width: 44, child: Center(child: Text('$value', style: h(18)))),
        StepBtn(Icons.add, () => onChanged(value + 1)),
      ]);
}

/// Daftar ukuran dengan tombol − / + (satu kartu putih).
class SizeCard extends StatelessWidget {
  final List<(String, String?)> rows;
  final Map<String, int> qty;
  final void Function(String name, int value) onChanged;
  const SizeCard(this.rows, this.qty, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => Box(
        child: Column(children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: C.sand),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(rows[i].$1, style: t(15, w: FontWeight.w800)),
                    if (rows[i].$2 != null) Text(rows[i].$2!, style: t(12, color: C.muted)),
                  ]),
                ),
                QtyStepper(qty[rows[i].$1] ?? 0, (v) => onChanged(rows[i].$1, v)),
              ]),
            ),
          ],
        ]),
      );
}

Future<String?> askText(BuildContext context, String title, String hint) {
  final c = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: C.cream,
      title: Text(title, style: h(16)),
      content: TextField(controller: c, autofocus: true, decoration: InputDecoration(hintText: hint)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: t(13, color: C.muted))),
        TextButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: Text('Simpan', style: t(13, color: C.brown, w: FontWeight.w800))),
      ],
    ),
  );
}

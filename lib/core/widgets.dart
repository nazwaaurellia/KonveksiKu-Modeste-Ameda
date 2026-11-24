import 'package:flutter/material.dart';
import 'floral_bg.dart';
import 'store.dart';
import 'theme.dart';

String rp(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

String jt(int n) => 'Rp ${(n / 1000000).toStringAsFixed(1).replaceAll('.', ',')} jt';

void go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));
void goReplaceAll(BuildContext c, Widget w) =>
    Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => w), (_) => false);
void toast(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));

/// Padding horizontal menyesuaikan lebar layar (HP kecil vs besar).
double pad(BuildContext c) => MediaQuery.sizeOf(c).width < 360 ? 16 : 20;

IconData productIcon(String p) =>
    p == 'Topi' ? Icons.sports_baseball : (p == 'Tas' ? Icons.shopping_bag : (p == 'Dasi' ? Icons.style : Icons.checkroom));
Color productTint(String p) =>
    {'Topi': C.red, 'Dasi': Color(0xFF3D5A80), 'Tas': C.gold, 'Jaket': C.brown, 'Seragam': C.green}[p] ?? C.brown;

/// Membangun ulang layar otomatis saat data bersama (AppStore) berubah.
class Live extends StatelessWidget {
  final Widget Function(BuildContext, AppStore) builder;
  const Live(this.builder, {super.key});
  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: AppStore.I, builder: (c, _) => builder(c, AppStore.I));
}

/// Kerangka halaman standar: area aman, lebar maksimum, konten scroll, tombol bawah.
class Screen extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final Widget? bottom, action;
  final bool back;
  const Screen({this.title, required this.children, this.bottom, this.action, this.back = false, super.key});

  @override
  Widget build(BuildContext context) {
    final p = pad(context);
    return Scaffold(
      body: FloralBg(child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(children: [
              if (title != null || back) _TopBar(title: title, back: back, action: action),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(p, 16, p, 24),
                  children: [
                    ...children,
                  ],
                ),
              ),
              if (bottom != null) Padding(padding: EdgeInsets.fromLTRB(p, 8, p, 14), child: bottom),
            ]),
          ),
        ),
      )),
    );
  }
}

/// Bilah atas tetap (tidak ikut scroll): panah kembali, judul rata kiri, aksi di kanan.
class _TopBar extends StatelessWidget {
  final String? title;
  final bool back;
  final Widget? action;
  const _TopBar({this.title, this.back = false, this.action});
  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        padding: EdgeInsets.only(left: back ? 4 : pad(context), right: pad(context)),
        decoration: BoxDecoration(
          color: C.cream.withOpacity(.92),
          border: Border(bottom: BorderSide(color: C.ink.withOpacity(.10))),
        ),
        child: Row(children: [
          if (back)
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              tooltip: 'Kembali',
              iconSize: 26,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: const Icon(Icons.arrow_back, color: C.ink),
            ),
          if (title != null)
            Expanded(
              child: Text(title!, style: h(20), maxLines: 1, overflow: TextOverflow.ellipsis),
            )
          else
            const Spacer(),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ]),
      );
}

/// Tombol berbentuk pil, selalu selebar wadahnya.
/// Ukuran: default tinggi 46 (aksi utama), [compact] tinggi 36 (di dalam kartu),
/// [large] tinggi 52 (layar masuk/daftar). [light] = tombol sekunder bergaris tepi.
/// [icon] = ikon kecil di kanan teks (mis. panah).
class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool light, compact, large;
  final IconData? icon;
  final double? height;
  const Btn(this.label, this.onTap,
      {this.light = false, this.compact = false, this.large = false, this.icon, this.height, super.key});
  @override
  Widget build(BuildContext context) {
    final h = height ?? (compact ? 36 : (large ? 52 : 46));
    final fg = light ? C.ink : Colors.white;
    return SizedBox(
      height: h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: light ? Colors.transparent : C.brown,
          foregroundColor: fg,
          disabledBackgroundColor: C.sand,
          elevation: 0,
          minimumSize: Size(64, h),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          side: light ? const BorderSide(color: C.ink, width: 1.2) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(h / 2)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: t(compact ? 12 : (large ? 15 : 13.5), color: fg, w: FontWeight.w700)),
            if (icon != null) ...[const SizedBox(width: 4), Icon(icon, size: compact ? 16 : 19, color: fg)],
          ]),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;
  const Box({required this.child, this.color = Colors.white, this.onTap, super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.ink.withOpacity(.05)),
            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 3))],
          ),
          child: child,
        ),
      );
}

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  const Tag(this.text, [this.color = C.gold]);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: color.withOpacity(.25), borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: t(10, color: C.ink, w: FontWeight.w700), maxLines: 1),
      );
}

class Choice extends StatelessWidget {
  final String text;
  final bool on;
  final VoidCallback onTap;
  const Choice(this.text, this.on, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(color: on ? C.brown : C.sand, borderRadius: BorderRadius.circular(18)),
          child: Text(text, style: t(12, color: on ? Colors.white : C.ink, w: FontWeight.w600)),
        ),
      );
}

class Fld extends StatelessWidget {
  final String label, hint;
  final bool obscure;
  final TextEditingController? ctrl;
  final int lines;
  final TextInputType? keyboard;
  final ValueChanged<String>? onChanged;
  const Fld(this.label, this.hint,
      {this.obscure = false, this.ctrl, this.lines = 1, this.keyboard, this.onChanged, super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: t(12, color: C.muted)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            obscureText: obscure,
            maxLines: obscure ? 1 : lines,
            keyboardType: keyboard,
            onChanged: onChanged,
            style: t(14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: t(14, color: C.muted.withOpacity(.7)),
              filled: true,
              fillColor: C.sand,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: C.brown, width: 1.2)),
            ),
          ),
        ]),
      );
}

class Label extends StatelessWidget {
  final String text;
  const Label(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 12),
        child: Text(text.toUpperCase(),
            style: t(11, color: C.brown, w: FontWeight.w800).copyWith(letterSpacing: 1.2)),
      );
}

class Counter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const Counter(this.value, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () => onChanged(value > 1 ? value - 1 : 1), visualDensity: VisualDensity.compact, icon: const Icon(Icons.remove_circle_outline)),
        Text('$value', style: h(18)),
        IconButton(onPressed: () => onChanged(value + 1), visualDensity: VisualDensity.compact, icon: const Icon(Icons.add_circle_outline)),
      ]);
}

class Timeline extends StatelessWidget {
  final List<List<String>> steps;
  final int current;
  const Timeline(this.steps, this.current, {super.key});
  @override
  Widget build(BuildContext context) => Box(
        child: Column(children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(children: [
                Icon(Icons.circle, size: 10, color: i < current ? C.green : (i == current ? C.brown : C.sand)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(steps[i][0], style: t(13, w: i <= current ? FontWeight.w700 : FontWeight.w500)),
                    if (steps[i][1].isNotEmpty) Text(steps[i][1], style: t(10, color: C.muted)),
                  ]),
                ),
              ]),
            ),
        ]),
      );
}

class OrderTile extends StatelessWidget {
  final Order o;
  final bool admin;
  final VoidCallback? onTap;
  const OrderTile(this.o, {this.admin = false, this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final tint = productTint(o.product);
    final label = admin && o.isDone && o.remaining > 0 ? 'Tunggu bayar' : o.label;
    return Box(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: tint.withOpacity(.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(productIcon(o.product), color: tint),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.title, style: t(13, w: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(admin ? '#${o.id} · ${o.customer} · ${o.qty} pcs' : '#${o.id} · ${o.qty} pcs',
                style: t(10, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
        const SizedBox(width: 8),
        Tag(label),
      ]),
    );
  }
}

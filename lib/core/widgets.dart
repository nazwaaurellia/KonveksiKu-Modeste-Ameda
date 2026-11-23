import 'package:flutter/material.dart';
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
double pad(BuildContext c) => MediaQuery.sizeOf(c).width < 360 ? 14 : 20;

IconData productIcon(String p) => p == 'Topi' ? Icons.sports_baseball : (p == 'Tas' ? Icons.shopping_bag : Icons.checkroom);
Color productTint(String p) =>
    {'Topi': C.red, 'Tas': C.gold, 'Jaket': C.brown, 'Seragam': C.green}[p] ?? C.brown;

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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(children: [
              Expanded(
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(p, 16, p, 16),
                  children: [
                    if (back)
                      InkWell(
                        onTap: () => Navigator.maybePop(context),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 2),
                          child: Text('‹ Kembali', style: t(13, color: C.muted)),
                        ),
                      ),
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(children: [
                          Expanded(child: Text(title!, style: h(26))),
                          if (action != null) action!,
                        ]),
                      ),
                    ...children,
                  ],
                ),
              ),
              if (bottom != null) Padding(padding: EdgeInsets.fromLTRB(p, 8, p, 12), child: bottom),
            ]),
          ),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool light;
  const Btn(this.label, this.onTap, {this.light = false, super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: light ? C.sand : C.brown,
            foregroundColor: light ? C.ink : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: t(14, color: light ? C.ink : Colors.white, w: FontWeight.w700)),
          ),
        ),
      );
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
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(.25), borderRadius: BorderRadius.circular(12)),
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
          decoration: BoxDecoration(color: on ? C.brown : C.sand, borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: t(13, color: on ? Colors.white : C.ink, w: FontWeight.w600)),
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
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: t(11, color: C.muted)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            obscureText: obscure,
            maxLines: lines,
            keyboardType: keyboard,
            onChanged: onChanged,
            style: t(14),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: C.sand,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
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
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(text.toUpperCase(), style: t(11, color: C.brown, w: FontWeight.w800)),
      );
}

class Counter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const Counter(this.value, this.onChanged, {super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () => onChanged(value > 1 ? value - 1 : 1), icon: const Icon(Icons.remove_circle_outline)),
        Text('$value', style: h(20)),
        IconButton(onPressed: () => onChanged(value + 1), icon: const Icon(Icons.add_circle_outline)),
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
              padding: const EdgeInsets.symmetric(vertical: 6),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: tint.withOpacity(.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(productIcon(o.product), color: tint),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.title, style: t(14, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
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

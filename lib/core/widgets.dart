import 'package:flutter/material.dart';
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

void go(BuildContext c, Widget w) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => w));

/// Halaman standar: judul serif, konten scroll, tombol bawah opsional.
class Screen extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final Widget? bottom, action;
  final bool back;
  const Screen({this.title, required this.children, this.bottom, this.action, this.back = false});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), children: [
                if (back)
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('‹ Kembali', style: t(12, color: C.muted))),
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
              ]),
            ),
            if (bottom != null) Padding(padding: const EdgeInsets.all(16), child: bottom),
          ]),
        ),
      );
}

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool light;
  const Btn(this.label, this.onTap, {this.light = false});
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          child: Text(label, style: t(14, color: light ? C.ink : Colors.white, w: FontWeight.w700)),
        ),
      );
}

class Box extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;
  const Box({required this.child, this.color = Colors.white, this.onTap});
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
        child: Text(text, style: t(10, color: C.ink, w: FontWeight.w700)),
      );
}

class Choice extends StatelessWidget {
  final String text;
  final bool on;
  final VoidCallback onTap;
  const Choice(this.text, this.on, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
  const Fld(this.label, this.hint, {this.obscure = false, this.ctrl, this.lines = 1});
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
            style: t(13),
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: C.sand,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        ]),
      );
}

class Label extends StatelessWidget {
  final String text;
  const Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(text.toUpperCase(), style: t(11, color: C.brown, w: FontWeight.w800)),
      );
}

class Timeline extends StatelessWidget {
  final List<List<String>> steps;
  final int current;
  const Timeline(this.steps, this.current);
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
  final IconData icon;
  final Color tint;
  final String title, sub, status;
  final VoidCallback? onTap;
  const OrderTile(this.icon, this.tint, this.title, this.sub, this.status, {this.onTap});
  @override
  Widget build(BuildContext context) => Box(
        onTap: onTap,
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: tint.withOpacity(.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: t(14, w: FontWeight.w800)),
              Text(sub, style: t(10, color: C.muted)),
            ]),
          ),
          Tag(status),
        ]),
      );
}

class Shell extends StatefulWidget {
  final List<Widget> pages;
  final List<(IconData, String)> items;
  const Shell(this.pages, this.items);
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: i, children: widget.pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: i,
          onTap: (v) => setState(() => i = v),
          type: BottomNavigationBarType.fixed,
          backgroundColor: C.cream,
          selectedItemColor: C.brown,
          unselectedItemColor: C.muted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [for (final it in widget.items) BottomNavigationBarItem(icon: Icon(it.$1), label: it.$2)],
        ),
      );
}

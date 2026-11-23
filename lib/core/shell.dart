import 'package:flutter/material.dart';
import 'theme.dart';

/// Kerangka navigasi bawah (dipakai pelanggan dan admin).
class Shell extends StatefulWidget {
  final List<Widget> pages;
  final List<(IconData, String)> items;
  final int initial;
  const Shell(this.pages, this.items, {this.initial = 0, super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  late int i = widget.initial;
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

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
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 66,
            backgroundColor: C.cream,
            surfaceTintColor: Colors.transparent,
            indicatorColor: C.gold.withOpacity(.35),
            labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
                  fontSize: 11,
                  fontWeight: s.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
                  color: s.contains(WidgetState.selected) ? C.brown : C.muted,
                )),
            iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
                  size: 23,
                  color: s.contains(WidgetState.selected) ? C.brown : C.muted,
                )),
          ),
          child: NavigationBar(
            selectedIndex: i,
            onDestinationSelected: (v) => setState(() => i = v),
            destinations: [
              for (final it in widget.items) NavigationDestination(icon: Icon(it.$1), label: it.$2),
            ],
          ),
        ),
      );
}

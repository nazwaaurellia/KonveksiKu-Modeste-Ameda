import 'package:flutter/material.dart';
import 'theme.dart';

/// Kerangka navigasi bawah (dipakai pelanggan dan admin).
/// Gaya: ikon + label, garis aksen di bawah item aktif, garis tipis di atas bar.
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: C.cream,
            border: Border(top: BorderSide(color: C.ink.withOpacity(.10))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(children: [
                for (var k = 0; k < widget.items.length; k++)
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => i = k),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(widget.items[k].$1, size: 26, color: k == i ? C.brown : C.muted),
                        const SizedBox(height: 2),
                        Text(
                          widget.items[k].$2,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: k == i ? FontWeight.w800 : FontWeight.w500,
                            color: k == i ? C.brown : C.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 3,
                          width: k == i ? 26 : 0,
                          decoration: BoxDecoration(color: C.brown, borderRadius: BorderRadius.circular(2)),
                        ),
                      ]),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      );
}

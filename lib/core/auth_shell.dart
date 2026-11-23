import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets.dart';

/// Kerangka layar Masuk / Daftar / Lupa kata sandi (header coklat + logo).
class AuthShell extends StatelessWidget {
  final String sub;
  final List<Widget> body;
  const AuthShell(this.sub, this.body, {super.key});
  @override
  Widget build(BuildContext context) {
    final p = pad(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(p, MediaQuery.paddingOf(context).top + 24, p, 24),
                decoration: const BoxDecoration(
                  color: C.brown,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: Column(children: [
                  CircleAvatar(radius: 28, backgroundColor: C.cream, child: Text('MA', style: h(18, C.brown))),
                  const SizedBox(height: 10),
                  Text('MODESTE AMEDA', style: t(15, color: Colors.white, w: FontWeight.w800)),
                  Text(sub, style: t(11, color: Colors.white70)),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(p),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: body),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

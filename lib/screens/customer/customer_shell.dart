import 'package:flutter/material.dart';
import '../../core/shell.dart';
import 'choose_service_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'track_screen.dart';

class CustomerShell extends StatelessWidget {
  final int initial;
  const CustomerShell({this.initial = 0, super.key});
  @override
  Widget build(BuildContext context) => Shell(
        const [HomeScreen(), ChooseServiceScreen(), TrackScreen(), ProfileScreen()],
        const [
          (Icons.home_outlined, 'Beranda'),
          (Icons.receipt_long_outlined, 'Pesan'),
          (Icons.place_outlined, 'Lacak'),
          (Icons.person_outline, 'Akun'),
        ],
        initial: initial,
      );
}

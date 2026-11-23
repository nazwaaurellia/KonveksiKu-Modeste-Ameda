import 'package:flutter/material.dart';
import '../../core/shell.dart';
import 'admin_profile_screen.dart';
import 'dashboard_screen.dart';
import 'order_list_screen.dart';
import 'stock_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});
  @override
  Widget build(BuildContext context) => Shell(
        const [DashboardScreen(), OrderListScreen(), StockScreen(), AdminProfileScreen()],
        const [
          (Icons.home_outlined, 'Beranda'),
          (Icons.receipt_long_outlined, 'Pesanan'),
          (Icons.inventory_2_outlined, 'Stok'),
          (Icons.person_outline, 'Akun'),
        ],
      );
}

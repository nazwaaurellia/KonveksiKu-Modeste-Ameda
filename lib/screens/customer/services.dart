import 'package:flutter/material.dart';
import '../../core/store.dart';
import '../../core/theme.dart';

/// Daftar layanan di beranda & layar "Pesan". Foto ada di assets/images/.
class ServiceInfo {
  final String title, sub, image, service, product;
  final IconData icon;
  final Color tint;
  const ServiceInfo(this.title, this.sub, this.image, this.service, this.product, this.icon, this.tint);

  /// Siapkan draft pesanan sesuai layanan yang dipilih.
  void startDraft() {
    final d = OrderDraft()..service = service;
    if (product.isNotEmpty) d.product = product;
    AppStore.I.draft = d;
  }
}

const kServices = <ServiceInfo>[
  ServiceInfo('Jahit Baju', 'Jahit sesuai ukuranmu', 'assets/images/layanan_baju.jpg', 'Jahit Baju', '', Icons.checkroom, C.green),
  ServiceInfo('Bordir', 'Logo dan nama di atas kain', 'assets/images/layanan_bordir.jpg', 'Bordir Saja', '', Icons.workspace_premium, C.red),
  ServiceInfo('Topi', 'Topi polos atau bordir logo', 'assets/images/layanan_topi.jpg', 'Jahit Baju', 'Topi', Icons.sports_baseball, C.brown),
  ServiceInfo('Dasi', 'Dasi seragam sesuai warna', 'assets/images/layanan_dasi.jpg', 'Jahit Baju', 'Dasi', Icons.style, Color(0xFF3D5A80)),
];

/// Foto layanan (rasio 4:3, sudut membulat). Bila file belum ada, tampil ikon.
class ServiceImage extends StatelessWidget {
  final ServiceInfo s;
  final double radius;
  const ServiceImage(this.s, {this.radius = 16, super.key});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.asset(
            s.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: s.tint.withOpacity(.15),
              child: Icon(s.icon, size: 34, color: s.tint),
            ),
          ),
        ),
      );
}

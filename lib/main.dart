import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

/// Rasio layar HP Android modern (lebar : tinggi = 9 : 19,5).
const double _kRatio = 19.5 / 9;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Modeste Ameda',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          // Font sedikit lebih besar supaya tidak terlihat kecil / "bantet" di HP.
          final base = mq.copyWith(
            textScaler: mq.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.2),
          );

          return LayoutBuilder(builder: (context, box) {
            // Di HP Android asli: layar penuh.
            if (box.maxWidth <= 600) return MediaQuery(data: base, child: child!);

            // Di Chrome / Windows / tablet: tampil sebagai layar HP berukuran Android.
            final w = (box.maxHeight / _kRatio).clamp(320.0, 430.0).toDouble();
            final h = w * _kRatio;
            return ColoredBox(
              color: const Color(0xFF1B1B1B),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: MediaQuery(
                      data: base.copyWith(
                        size: Size(w, h),
                        padding: EdgeInsets.zero,
                        viewPadding: EdgeInsets.zero,
                        viewInsets: EdgeInsets.zero,
                      ),
                      child: child!,
                    ),
                  ),
                ),
              ),
            );
          });
        },
        home: const LoginScreen(),
      );
}

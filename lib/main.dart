import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/auth_screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Modeste Ameda',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const LoginScreen(),
      );
}

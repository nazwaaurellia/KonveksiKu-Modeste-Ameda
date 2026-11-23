import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Login screen tampil', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Masuk'), findsWidgets);
  });
}

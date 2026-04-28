import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_ma/main.dart';

void main() {
  testWidgets('App launches with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SpharmacyApp());
    expect(find.text('PharmaMa'), findsOneWidget);
    expect(find.text('دليل الأدوية المغربي'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:studioequip_mobile_app/app.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Studioequip());
    await tester.pump();
    expect(find.byType(Studioequip), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });
}

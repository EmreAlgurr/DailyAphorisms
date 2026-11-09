import 'package:flutter_test/flutter_test.dart';

import 'package:daily_aphorisms/main.dart';

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyAphorismsApp());
    // Verify the header text is present
    expect(find.text('Günün Sözü'), findsOneWidget);
  });
}

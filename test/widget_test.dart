import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aramielle_app/src/app.dart';

void main() {
  testWidgets('Aramielle App renders Landing screen and navigates to Auth screen successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the landing page renders correctly.
    expect(find.text('ARAMIELLE RESTAURANT'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);

    // Tap GET STARTED to navigate to Auth Screen
    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();

    // Verify Auth Screen renders
    expect(find.text('Sign In'), findsWidgets);
  });
}

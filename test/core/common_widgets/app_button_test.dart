import 'package:dhanra_new/core/common_widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('renders button text and icon correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Transfer Funds',
              icon: Icons.swap_horiz_rounded,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Transfer Funds'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    });

    testWidgets(
        'renders without RenderFlex overflow in narrow constrained width',
        (WidgetTester tester) async {
      // Test constrained narrow width (100px) that previously caused 25px overflow
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: AppButton(
                text: 'Transfer Funds',
                icon: Icons.swap_horiz_rounded,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify widget builds without any layout overflow exception
      expect(tester.takeException(), isNull);
      expect(find.text('Transfer Funds'), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });
  });
}

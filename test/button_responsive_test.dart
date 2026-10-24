import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studioequip_mobile_app/core/common/widgets/sp_primary_button.dart';
import 'package:studioequip_mobile_app/core/utils/constants/colors.dart';

Widget _wrapWithScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(428, 932),
    builder: (_, __) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('SpPrimaryButton Responsive Tests', () {
    testWidgets('SpPrimaryButton renders without truncation or errors', (tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(
          SpPrimaryButton(
            label: 'Enter Session Brief',
            onPressed: () {},
            height: 56,
            suffixIcon: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter Session Brief'), findsOneWidget);
      expect(find.byType(SpPrimaryButton), findsOneWidget);
      expect(find.byType(FittedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SpPrimaryButton.outlined renders properly with custom colors', (tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(
          SpPrimaryButton.outlined(
            label: 'Record again',
            onPressed: () {},
            height: 54,
            textColor: AppColors.primary,
            borderColor: AppColors.primary,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Record again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SpPrimaryButton handles long text by scaling down instead of throwing RenderFlex overflow', (tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(
          SpPrimaryButton(
            label: 'Extremely Long Action Button Label That Would Normally Overflow A Narrow Device',
            onPressed: () {},
            suffixIcon: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FittedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SpPrimaryButton displays loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _wrapWithScreenUtil(
          SpPrimaryButton(
            label: 'Enter Session Brief',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Enter Session Brief'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}

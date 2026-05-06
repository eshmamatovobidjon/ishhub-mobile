import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ishhub/l10n/generated/app_localizations.dart';
import 'package:ishhub/models/geo.dart';
import 'package:ishhub/models/job.dart';
import 'package:ishhub/screens/auth/login_screen.dart';
import 'package:ishhub/utils/offer_input.dart';
import 'package:ishhub/widgets/job_card.dart';

void main() {
  testWidgets('login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });

  test('offer input parsing accepts only positive numbers', () {
    expect(parsePositiveAmount('125000'), 125000);
    expect(parsePositiveAmount(' 99.5 '), 99.5);
    expect(parsePositiveAmount('0'), isNull);
    expect(parsePositiveAmount('-1'), isNull);
    expect(parsePositiveAmount('abc'), isNull);

    expect(parseOptionalPositiveHours(''), isNull);
    expect(parseOptionalPositiveHours('2.5'), 2.5);
    expect(hasInvalidOptionalHours(''), isFalse);
    expect(hasInvalidOptionalHours('0'), isTrue);
    expect(hasInvalidOptionalHours('later'), isTrue);
  });

  testWidgets('job card shows fallback copy when distance is unknown',
      (WidgetTester tester) async {
    final job = Job(
      id: 'job-1',
      creatorId: 'client-1',
      kind: 'paid',
      status: 'posted',
      title: 'Fix kitchen sink',
      category: 'repair',
      urgency: 'flexible',
      pricingModel: 'fixed',
      budget: 120000,
      hourlyRate: null,
      budgetCurrency: 'UZS',
      displayPrice: '120,000 UZS',
      location: const GeoPoint(latitude: 41.31, longitude: 69.28),
      address: 'Yunusobod',
      scheduledFor: null,
      workersNeeded: 1,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: JobCard(
            job: job,
            distanceKm: 4.2,
            distanceKnown: false,
          ),
        ),
      ),
    );

    expect(find.text('Showing recent jobs'), findsOneWidget);
    expect(find.text('4.2 km'), findsNothing);
  });
}

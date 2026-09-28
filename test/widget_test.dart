import 'package:app_connectee_backend_reel/core/config/app_strings.dart';
import 'package:app_connectee_backend_reel/core/format/formatters.dart';
import 'package:app_connectee_backend_reel/core/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatXof groupe les milliers', () {
    expect(formatXof(1450), '1\u202f450 F CFA');
    expect(formatXof(275), '275 F CFA');
  });

  testWidgets('la bannière hors-ligne affiche le message utilisateur', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: OfflineBanner()),
      ),
    );

    expect(find.text(AppStrings.offlineBanner), findsOneWidget);
  });
}

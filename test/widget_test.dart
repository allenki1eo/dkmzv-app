import 'package:dkmzv_app/app.dart';
import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ChurchStore store;

  setUpAll(() async {
    await initializeDateFormatting('sw');
    await initializeDateFormatting('en');
  });

  setUp(() async {
    final data = await ChurchStore.loadSeed();
    store = ChurchStore.memory(data);
  });

  testWidgets('home shows announcements, Sunday times, and SW/EN toggle',
      (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    expect(find.text('DKMZV'), findsWidgets);
    expect(find.text('SAA ZA JUMAPILI'), findsOneWidget);
    expect(find.textContaining('Ibada kuu'), findsWidgets);

    await tester.tap(find.widgetWithText(TextButton, 'EN'));
    await tester.pumpAndSettle();
    expect(find.text('SUNDAY TIMES'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Grace that is enough'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Grace that is enough'), findsWidgets);

    await tester.scrollUntilVisible(
      find.textContaining('Welcome to Sunday worship'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Welcome to Sunday worship'), findsOneWidget);
  });

  testWidgets('hymn search and favorite', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nyimbo'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ngome');
    await tester.pumpAndSettle();
    expect(find.textContaining('Mungu wetu ni ngome'), findsWidgets);

    await tester.tap(find.textContaining('Mungu wetu ni ngome').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Weka pendwa'));
    await tester.pumpAndSettle();
    expect(store.isFavorite('hymn-001'), isTrue);
  });

  testWidgets('pastoral form reaches inbox', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zaidi'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Ombi la kichungaji'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Ombi la kichungaji'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Asha');
    await tester.enterText(find.byType(TextField).at(2), 'Tafadhali ombeni');
    await tester.tap(find.text('Tuma kwa ofisi'));
    await tester.pumpAndSettle();
    expect(store.data.pastoralRequests, isNotEmpty);
    expect(store.data.pastoralRequests.first.name, 'Asha');
  });

  test('ChurchData round-trip keeps hymn count', () async {
    final data = await ChurchStore.loadSeed();
    final again = ChurchData.fromJson(data.toJson());
    expect(again.hymns.length, data.hymns.length);
    expect(again.latestService()?.themeSw, isNotEmpty);
  });
}

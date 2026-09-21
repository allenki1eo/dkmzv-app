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
    await tester.scrollUntilVisible(
      find.text('Saa za Jumapili'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Saa za Jumapili'), findsOneWidget);
    expect(find.textContaining('Ibada kuu'), findsWidgets);

    await tester.tap(find.widgetWithText(TextButton, 'EN'));
    await tester.pumpAndSettle();
    expect(find.text('Sunday times'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Welcome to Sunday worship'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Grace that is enough'), findsWidgets);
    expect(find.textContaining('Welcome to Sunday worship'), findsOneWidget);
  });

  testWidgets('hymn search and favorite', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Nyimbo'),
    ));
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
    expect(again.congregations.map((c) => c.id),
        containsAll(['cong-ebenezer', 'cong-angaza', 'cong-makedonia']));
    expect(again.congregations.where((c) => c.isMain).single.id,
        'cong-ebenezer');
    expect(again.jumuiyas, isNotEmpty);
    expect(again.sermons.any((s) => s.isLive), isTrue);
  });

  test('member registration and jumuiya home pin stay local', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    expect(store.selectedCongregation?.id, 'cong-ebenezer');
    await store.selectCongregation('cong-angaza');
    expect(store.selectedCongregation?.id, 'cong-angaza');

    await store.saveMember(MemberRecord(
      id: 'mem-asha',
      fullName: 'Asha Juma',
      congregationId: 'cong-angaza',
      jumuiyaId: 'jum-angaza-chamaguha',
      phone: '+255 700 000 099',
      householdNote: 'Chamaguha',
      shareHomePin: true,
      homeLat: -3.6702,
      homeLng: 33.4463,
      registeredAt: DateTime.now().toIso8601String(),
    ));
    expect(store.currentMember?.fullName, 'Asha Juma');
    expect(store.data.homePins, isNotEmpty);
    expect(store.data.homePins.first.label, contains('Asha'));
    expect(store.data.homePins.first.note, 'Chamaguha');
    // Phone is stored for the office inbox, not copied onto the public pin.
    expect(store.data.homePins.first.toJson()['phone'], isNull);

    final v1 = ChurchData.fromJson({
      'version': 1,
      'settings': {'adminPin': 'dkmzv'},
      'church': {'nameSw': 'Old'},
      'hymns': store.data.hymns.take(1).map((h) => h.toJson()).toList(),
    });
    final migrated = await ChurchStore.migrateV2(v1);
    expect(migrated.congregations.length, 3);
    expect(migrated.version, 2);
    expect(migrated.settings.selectedCongregationId, 'cong-ebenezer');
  });

  testWidgets('congregations, live mahubiri, and registration', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    expect(find.text('Usharika wa Ebenezer'), findsWidgets);
    expect(find.textContaining('MOJA KWA MOJA'), findsWidgets);

    await tester.tap(find.text('Zaidi'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Masharika'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Masharika'));
    await tester.pumpAndSettle();
    expect(find.text('Usharika wa Angaza'), findsWidgets);
    expect(find.text('Usharika wa Makedonia'), findsWidgets);
    expect(find.textContaining('Kanisa kuu'), findsWidgets);

    Navigator.of(tester.element(find.text('Usharika wa Angaza').first)).pop();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sajili mwanachama'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Sajili mwanachama'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Baraka');
    await tester.tap(find.text('Hifadhi'));
    await tester.pumpAndSettle();
    expect(store.currentMember?.fullName, 'Baraka');
  });
}

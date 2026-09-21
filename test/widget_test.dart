import 'package:dkmzv_app/app.dart';
import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/store.dart';
import 'package:dkmzv_app/theme/backgrounds.dart';
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

    expect(find.text('Usharika wa Ebenezer'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('SAA ZA JUMAPILI'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('SAA ZA JUMAPILI'), findsOneWidget);
    expect(find.textContaining('Ibada kuu'), findsWidgets);

    await tester.tap(find.widgetWithText(TextButton, 'EN'));
    await tester.pumpAndSettle();
    expect(find.text('SUNDAY TIMES'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Welcome to Sunday worship'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Grace that is enough'), findsWidgets);
    expect(find.textContaining('Welcome to Sunday worship'), findsOneWidget);
  });

  testWidgets('dark mode and background live in Mwonekano', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zaidi'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Mwonekano'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Mwonekano'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Giza'));
    await tester.pumpAndSettle();
    expect(store.data.settings.themeMode, 'dark');
    expect(store.themeMode, ThemeMode.dark);

    await tester.ensureVisible(find.text('Maua'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maua'));
    await tester.pumpAndSettle();
    expect(store.backgroundId, 'maua');

    // The wallpaper is painted behind the navigator, so scaffolds must let it
    // through instead of covering it with the canvas colour.
    final themed = Theme.of(tester.element(find.text('Maua')));
    expect(themed.scaffoldBackgroundColor, Colors.transparent);
    expect(find.byType(BackgroundCanvas), findsOneWidget);
  });

  testWidgets('sadaka groups render in dark mode without layout errors',
      (tester) async {
    await store.setThemeMode('dark');
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.byType(NavigationBar))).brightness,
        Brightness.dark);

    await tester.tap(find.text('Sadaka'));
    await tester.pumpAndSettle();
    expect(find.text('SADAKA ZA BAHASHA'), findsOneWidget);
    expect(find.text('Exempt'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('SHUKRANI'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('FUNGU LA KUMI'), findsOneWidget);
    expect(find.text('SHUKRANI'), findsOneWidget);

    await tester.ensureVisible(find.text('Ujenzi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ujenzi'));
    await tester.pumpAndSettle();
    expect(find.text('Chagua kiasi'), findsOneWidget);
    // Card stays disabled until the office pastes a Stripe Payment Link.
    final card = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Lipa kwa kadi'));
    expect(card.onPressed, isNull);
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
    expect(migrated.version, dataVersion);
    expect(migrated.settings.selectedCongregationId, 'cong-ebenezer');
    expect(migrated.giving.categories, isNotEmpty);
  });

  test('bahasha stays exempt and apart from fungu la kumi', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    final g = store.data.giving;

    expect(g.inGroup(GivingGroups.bahasha), isNotEmpty);
    expect(g.inGroup(GivingGroups.bahasha).every((c) => c.exempt), isTrue);
    expect(g.inGroup(GivingGroups.fungu).single.exempt, isFalse);
    expect(g.inGroup(GivingGroups.shukrani).single.exempt, isFalse);
    expect(g.categoryById('bah-ujenzi')?.group, GivingGroups.bahasha);

    await store.addGivingNote(
        amount: 20000, purposeId: 'bah-ujenzi', categoryId: 'bah-ujenzi',
        method: 'bahasha', note: '');
    await store.addGivingNote(
        amount: 50000, purposeId: 'fungu-la-kumi', categoryId: 'fungu-la-kumi',
        method: 'mpesa', note: '');

    final totals = store.givingTotalsByGroup;
    expect(totals[GivingGroups.bahasha], 20000);
    expect(totals[GivingGroups.fungu], 50000);
  });

  test('jumuiya geofence groups the homes it contains', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    final jumuiya = store.data.jumuiyaById('jum-angaza-chamaguha')!;
    expect(jumuiya.radiusMeters, greaterThan(0));

    await store.saveMember(MemberRecord(
      id: 'mem-inside',
      fullName: 'Neema Paul',
      congregationId: 'cong-angaza',
      jumuiyaId: jumuiya.id,
      phone: '',
      householdNote: '',
      shareHomePin: true,
      homeLat: jumuiya.latitude + 0.0008,
      homeLng: jumuiya.longitude,
      registeredAt: DateTime.now().toIso8601String(),
      kaya: 'Kaya ya Paul',
    ));
    expect(store.pinsInsideGeofence(jumuiya).length, 1);

    // A home two kilometres away falls outside the circle.
    await store.pingHome(
      memberId: 'mem-inside',
      jumuiyaId: jumuiya.id,
      congregationId: 'cong-angaza',
      label: 'Kaya ya Paul',
      lat: jumuiya.latitude + 0.02,
      lng: jumuiya.longitude,
      note: '',
    );
    expect(store.pinsInsideGeofence(jumuiya), isEmpty);
    expect(
      store.jumuiyaAt(jumuiya.latitude, jumuiya.longitude,
          congregationId: 'cong-angaza')?.id,
      jumuiya.id,
    );
    expect(store.jumuiyaAt(-3.0, 33.0), isNull);
  });

  test('theme mode and background persist on the store', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    expect(store.themeMode, ThemeMode.system);
    await store.setThemeMode('dark');
    expect(store.themeMode, ThemeMode.dark);
    await store.setThemeMode('nonsense');
    expect(store.themeMode, ThemeMode.system);

    await store.setBackground('kitenge');
    expect(AppBackground.byId(store.backgroundId).asset,
        'assets/backgrounds/kitenge.webp');
    expect(AppBackground.byId('hakuna').id, 'none');
  });

  test('each usharika carries its own accent colour', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    final ebenezer = store.parishAccent;
    await store.selectCongregation('cong-angaza');
    expect(store.parishAccent, isNot(ebenezer));
    expect(parseHexColor('#2E0854'), const Color(0xFF2E0854));
    expect(parseHexColor('oops'), isNull);
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
      find.text('Usajili wa waumini'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Usajili wa waumini'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Baraka');
    await tester.scrollUntilVisible(
      find.text('Hifadhi'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Hifadhi'));
    await tester.pumpAndSettle();
    expect(store.currentMember?.fullName, 'Baraka');
  });
}

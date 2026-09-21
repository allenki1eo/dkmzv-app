import 'dart:math' as math;

import 'package:dkmzv_app/app.dart';
import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/store.dart';
import 'package:dkmzv_app/data/youtube.dart';
import 'package:dkmzv_app/theme/app_theme.dart';
import 'package:dkmzv_app/theme/backgrounds.dart';
import 'package:dkmzv_app/theme/brand.dart';
import 'package:dkmzv_app/widgets/tab_bar.dart';
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

  testWidgets('home greets the member and carries the announcements', (
    tester,
  ) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    // The usharika being followed is named under the greeting.
    expect(find.text('Usharika wa Ebenezer'), findsWidgets);

    // Nobody has registered on this phone yet, so the envelope panel invites
    // them to, rather than showing an empty bahasha.
    expect(find.text('Hujajisajili bado'), findsOneWidget);
    expect(find.text('Sajili mwanachama'), findsWidgets);

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(find.text('Not registered yet'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Welcome to Sunday worship'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Grace that is enough'), findsWidgets);
    expect(find.textContaining('Welcome to Sunday worship'), findsOneWidget);
  });

  testWidgets('a registered member sees their bahasha on the home panel', (
    tester,
  ) async {
    await store.saveMember(
      MemberRecord(
        id: 'mem-neema',
        fullName: 'Neema Joseph',
        congregationId: 'cong-ebenezer',
        jumuiyaId: '',
        phone: '',
        householdNote: '',
        shareHomePin: false,
        registeredAt: DateTime.now().toIso8601String(),
        bahashaNo: 'EB-0142',
      ),
    );
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    expect(find.text('Bahasha yangu'.toUpperCase()), findsOneWidget);
    expect(find.text('EB-0142'), findsOneWidget);
    expect(find.text('Toa sadaka'), findsWidgets);
    // The greeting carries their first name, not the generic welcome.
    expect(find.textContaining('Neema'), findsWidgets);
  });

  testWidgets('the shell carries four tabs and one raised give button', (
    tester,
  ) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    final bar = find.byType(GlassTabBar);
    expect(bar, findsOneWidget);
    for (final label in ['Nyumbani', 'Mahubiri', 'Nyimbo', 'Zaidi']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
        reason: '\$label should be a destination',
      );
    }

    // Giving is the raised action, not a tab, and it opens Sadaka.
    await tester.tap(find.byTooltip('Toa sadaka'));
    await tester.pumpAndSettle();
    expect(find.text('Sadaka za bahasha'), findsOneWidget);
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
    await tester.ensureVisible(find.text('Mwonekano'));
    await tester.pumpAndSettle();
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

  testWidgets('sadaka groups render in dark mode without layout errors', (
    tester,
  ) async {
    await store.setThemeMode('dark');
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(GlassTabBar))).brightness,
      Brightness.dark,
    );

    await tester.scrollUntilVisible(
      find.text('Sadaka'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Sadaka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sadaka'));
    await tester.pumpAndSettle();
    expect(find.text('Sadaka za bahasha'), findsOneWidget);
    expect(find.text('Exempt'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Shukrani'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Fungu la kumi'), findsWidgets);
    expect(find.text('Shukrani'), findsOneWidget);

    await tester.ensureVisible(find.text('Ujenzi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ujenzi'));
    await tester.pumpAndSettle();
    expect(find.text('Chagua kiasi'), findsOneWidget);
    // Card stays disabled until the office pastes a Stripe Payment Link.
    final card = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Lipa kwa kadi'),
    );
    expect(card.onPressed, isNull);
  });

  testWidgets('hymn search and favorite', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(GlassTabBar),
        matching: find.text('Nyimbo'),
      ),
    );
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
    expect(
      again.congregations.map((c) => c.id),
      containsAll(['cong-ebenezer', 'cong-angaza', 'cong-makedonia']),
    );
    expect(
      again.congregations.where((c) => c.isMain).single.id,
      'cong-ebenezer',
    );
    expect(again.jumuiyas, isNotEmpty);
    expect(again.sermons.any((s) => s.isLive), isTrue);
  });

  test('member registration and jumuiya home pin stay local', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    expect(store.selectedCongregation?.id, 'cong-ebenezer');
    await store.selectCongregation('cong-angaza');
    expect(store.selectedCongregation?.id, 'cong-angaza');

    await store.saveMember(
      MemberRecord(
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
      ),
    );
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
      amount: 20000,
      purposeId: 'bah-ujenzi',
      categoryId: 'bah-ujenzi',
      method: 'bahasha',
      note: '',
    );
    await store.addGivingNote(
      amount: 50000,
      purposeId: 'fungu-la-kumi',
      categoryId: 'fungu-la-kumi',
      method: 'mpesa',
      note: '',
    );

    final totals = store.givingTotalsByGroup;
    expect(totals[GivingGroups.bahasha], 20000);
    expect(totals[GivingGroups.fungu], 50000);
  });

  test('jumuiya geofence groups the homes it contains', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    final jumuiya = store.data.jumuiyaById('jum-angaza-chamaguha')!;
    expect(jumuiya.radiusMeters, greaterThan(0));

    await store.saveMember(
      MemberRecord(
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
      ),
    );
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
      store
          .jumuiyaAt(
            jumuiya.latitude,
            jumuiya.longitude,
            congregationId: 'cong-angaza',
          )
          ?.id,
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
    expect(
      AppBackground.byId(store.backgroundId).asset,
      'assets/backgrounds/kitenge.webp',
    );
    expect(AppBackground.byId('hakuna').id, 'none');
  });

  test('each usharika carries its own accent colour', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    final ebenezer = store.parishAccent;
    await store.selectCongregation('cong-angaza');
    expect(store.parishAccent, isNot(ebenezer));
    expect(parseHexColor('#0F5F52'), const Color(0xFF0F5F52));
    expect(parseHexColor('oops'), isNull);
  });

  test('no chrome colour is purple any more', () async {
    final data = await ChurchStore.loadSeed();
    // Every parish accent is out of the violet band of the colour wheel.
    for (final c in data.congregations) {
      final hue = HSLColor.fromColor(parseHexColor(c.accentHex)!).hue;
      expect(
        hue > 255 && hue < 330,
        isFalse,
        reason: '${c.id} still carries a purple accent',
      );
    }

    for (final brightness in Brightness.values) {
      final theme = AppTheme.build(
        accent: parseHexColor(data.congregations.first.accentHex)!,
        brightness: brightness,
      );
      // The one filled action weight is the neutral slate, not a hue.
      final expected = brightness == Brightness.dark
          ? Surfaces.dark.action
          : Surfaces.light.action;
      expect(
        theme.filledButtonTheme.style?.backgroundColor?.resolve(
          <WidgetState>{},
        ),
        expected,
      );
      // Canvas is a true neutral: the channels sit within a few points of
      // each other, so no violet cast leaks into the background.
      final canvas = theme.scaffoldBackgroundColor;
      final channels = [canvas.r, canvas.g, canvas.b];
      expect(
        channels.reduce(math.max) - channels.reduce(math.min),
        lessThan(0.05),
      );
    }
  });

  test('a v3 phone keeps its data but loses the purple', () async {
    final seed = await ChurchStore.loadSeed();
    final old = ChurchData.fromJson(seed.toJson());
    old.version = 3;
    old.congregations.first.accentHex = '#2E0854';
    old.congregations.last.accentHex = '#0B7285'; // an office choice
    old.jumuiyas.first.colorHex = '#6C3FA0';

    final migrated = await ChurchStore.migrateV2(old);
    expect(migrated.version, dataVersion);
    expect(migrated.congregations.first.accentHex, '#0F5F52');
    expect(migrated.congregations.last.accentHex, '#0B7285');
    expect(migrated.jumuiyas.first.colorHex, isNot('#6C3FA0'));
  });

  test('the office can paste any shape of YouTube link', () {
    expect(youtubeVideoId('https://youtu.be/dQw4w9WgXcQ'), 'dQw4w9WgXcQ');
    expect(
      youtubeVideoId('https://www.youtube.com/live/dQw4w9WgXcQ?si=x'),
      'dQw4w9WgXcQ',
    );
    expect(
      youtubeVideoId('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
      'dQw4w9WgXcQ',
    );
    expect(youtubeVideoId('https://vimeo.com/12345'), isNull);
    expect(
      youtubeThumbUrl('dQw4w9WgXcQ'),
      'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
    );
  });

  test(
    'a channel id lets the live stream play without a weekly link',
    () async {
      const channel =
          'https://www.youtube.com/channel/UC_x5XG1OV2P6uZZ5FSM9Ttw';
      expect(youtubeChannelId(channel), 'UC_x5XG1OV2P6uZZ5FSM9Ttw');
      expect(youtubeHandle('https://youtube.com/@dkmzv'), '@dkmzv');
      expect(
        youtubeChannelLiveEmbedUrl(channel),
        contains('embed/live_stream?channel=UC_x5XG1OV2P6uZZ5FSM9Ttw'),
      );
      // A handle alone cannot be embedded, but it can still be opened.
      expect(youtubeChannelLiveEmbedUrl('@dkmzv'), isNull);
      expect(
        youtubeChannelLiveUrl('@dkmzv'),
        'https://www.youtube.com/@dkmzv/live',
      );

      final store = ChurchStore.memory(await ChurchStore.loadSeed());
      expect(store.youtubeChannel, isEmpty);
      await store.setYoutubeChannel(channel);
      expect(store.youtubeChannel, 'UC_x5XG1OV2P6uZZ5FSM9Ttw');
      await store.setYoutubeChannel('not a channel');
      expect(store.youtubeChannel, isEmpty);
    },
  );

  test('home offers the live stream first, then the newest sermon', () async {
    final store = ChurchStore.memory(await ChurchStore.loadSeed());
    expect(store.watchNow?.isLive, isTrue);

    final live = store.liveSermon!;
    await store.setLiveSermon(live.id, false);
    expect(store.watchNow?.isLive, isFalse);
    expect(store.watchNow?.mediaUrl, isNotEmpty);
  });

  testWidgets('live mahubiri and member registration', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    expect(find.text('Usharika wa Ebenezer'), findsWidgets);
    expect(find.textContaining('MOJA KWA MOJA'), findsWidgets);

    await tester.tap(find.text('Zaidi'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Usajili wa waumini'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.ensureVisible(find.text('Usajili wa waumini'));
    await tester.pumpAndSettle();
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

  testWidgets('the office is not reachable from the phone', (tester) async {
    await tester.pumpWidget(DkmzvApp(store: store, skipSplash: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Zaidi'));
    await tester.pumpAndSettle();

    // Admin and the usharika picker moved to the web app. Neither should
    // have a way in from a member's phone.
    expect(find.text('Msimamizi'), findsNothing);
    expect(find.text('Masharika'), findsNothing);
  });
}

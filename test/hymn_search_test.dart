import 'dart:convert';

import 'package:dkmzv_app/data/hymn_search.dart';
import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ChurchData seed;

  setUpAll(() async {
    final raw = await const LocalFileSystem().loadSeed();
    seed = ChurchData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('seed has 20–50 hymns and Shinyanga church identity', () {
    expect(seed.hymns.length, inInclusiveRange(20, 50));
    expect(seed.church.addressSw.toLowerCase(), contains('shinyanga'));
    expect(seed.contacts.length, lessThan(5));
    expect(seed.contacts.every((c) => c.phone.contains('000')), isTrue);
  });

  test('search finds Swahili title, English title, and number', () {
    expect(searchHymns(seed.hymns, 'ngome').first.id, 'hymn-001');
    expect(searchHymns(seed.hymns, 'amazing grace').first.id, 'hymn-013');
    expect(searchHymns(seed.hymns, '028').first.id, 'hymn-028');
  });

  test('favorites and pastoral inbox persist in memory store', () async {
    final store = ChurchStore.memory(seed);
    expect(store.isFavorite('hymn-001'), isFalse);
    await store.toggleFavorite('hymn-001');
    expect(store.isFavorite('hymn-001'), isTrue);
    await store.addPastoralRequest(
      name: 'Neema',
      phone: '',
      type: 'prayer',
      message: 'Maombi ya familia',
    );
    expect(store.data.pastoralRequests, isNotEmpty);
    expect(store.data.pastoralRequests.first.message, contains('familia'));
  });
}

/// Loads the seed JSON from the repo so tests do not depend on asset bundle.
class LocalFileSystem {
  const LocalFileSystem();

  Future<String> loadSeed() async {
    return rootBundle.loadString(seedAsset);
  }
}

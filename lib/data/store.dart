import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'hymn_search.dart';
import 'models.dart';

const seedAsset = 'assets/seed/church.json';
const _dataKey = 'church_data_v1';
const _localeKey = 'locale_code';
const _favKey = 'favorite_hymn_ids';
const _recentKey = 'recent_hymn_ids';
const _lastIbadaKey = 'last_opened_ibada_id';

class ChurchStore extends ChangeNotifier {
  ChurchStore._(this._prefs, this.data, this.localeCode, this.favoriteIds,
      this.recentHymnIds, this.lastOpenedIbadaId);

  final SharedPreferences? _prefs;
  ChurchData data;
  String localeCode;
  List<String> favoriteIds;
  List<String> recentHymnIds;
  String? lastOpenedIbadaId;

  static const _uuid = Uuid();

  bool get sw => localeCode != 'en';

  static Future<ChurchStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dataKey);
    final ChurchData parsed;
    if (raw != null && raw.isNotEmpty) {
      parsed = ChurchData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } else {
      parsed = await loadSeed();
      await prefs.setString(_dataKey, jsonEncode(parsed.toJson()));
    }
    return ChurchStore._(
      prefs,
      parsed,
      prefs.getString(_localeKey) ?? parsed.settings.defaultLocale,
      prefs.getStringList(_favKey) ?? const [],
      prefs.getStringList(_recentKey) ?? const [],
      prefs.getString(_lastIbadaKey),
    );
  }

  static Future<ChurchData> loadSeed() async {
    final seed = await rootBundle.loadString(seedAsset);
    return ChurchData.fromJson(jsonDecode(seed) as Map<String, dynamic>);
  }

  /// In-memory store for tests (no SharedPreferences).
  factory ChurchStore.memory(ChurchData data, {String locale = 'sw'}) {
    return ChurchStore._(null, data, locale, [], [], null);
  }

  Future<void> persist() async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString(_dataKey, jsonEncode(data.toJson()));
      await prefs.setString(_localeKey, localeCode);
      await prefs.setStringList(_favKey, favoriteIds);
      await prefs.setStringList(_recentKey, recentHymnIds);
      if (lastOpenedIbadaId != null) {
        await prefs.setString(_lastIbadaKey, lastOpenedIbadaId!);
      }
    }
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    localeCode = code == 'en' ? 'en' : 'sw';
    await persist();
  }

  Future<void> toggleLocale() => setLocale(sw ? 'en' : 'sw');

  bool isFavorite(String hymnId) => favoriteIds.contains(hymnId);

  Future<void> toggleFavorite(String hymnId) async {
    if (favoriteIds.contains(hymnId)) {
      favoriteIds = [...favoriteIds]..remove(hymnId);
    } else {
      favoriteIds = [...favoriteIds, hymnId];
    }
    await persist();
  }

  Future<void> openHymn(String hymnId) async {
    final next = [hymnId, ...recentHymnIds.where((id) => id != hymnId)];
    recentHymnIds = next.take(12).toList();
    await persist();
  }

  Future<void> openIbada(String id) async {
    lastOpenedIbadaId = id;
    await persist();
  }

  ServiceOrder? get featuredService {
    if (lastOpenedIbadaId != null) {
      for (final s in data.services) {
        if (s.id == lastOpenedIbadaId) return s;
      }
    }
    return data.latestService();
  }

  List<Hymn> get favoriteHymns => data.hymns
      .where((h) => favoriteIds.contains(h.id))
      .toList();

  List<Hymn> get recentHymns => recentHymnIds
      .map(data.hymnById)
      .whereType<Hymn>()
      .toList();

  List<Hymn> hymnsMatching(String query) => searchHymns(data.hymns, query);

  Future<void> addPastoralRequest({
    required String name,
    required String phone,
    required String type,
    required String message,
  }) async {
    data.pastoralRequests = [
      PastoralRequest(
        id: _uuid.v4(),
        at: DateTime.now().toIso8601String(),
        name: name.trim(),
        phone: phone.trim(),
        type: type,
        message: message.trim(),
        read: false,
      ),
      ...data.pastoralRequests,
    ];
    await persist();
  }

  Future<void> markPastoralRead(String id) async {
    for (final r in data.pastoralRequests) {
      if (r.id == id) r.read = true;
    }
    await persist();
  }

  Future<void> deletePastoral(String id) async {
    data.pastoralRequests =
        data.pastoralRequests.where((r) => r.id != id).toList();
    await persist();
  }

  Future<void> addGivingNote({
    required int amount,
    required String purposeId,
    required String note,
  }) async {
    data.givingNotes = [
      GivingNote(
        id: _uuid.v4(),
        at: DateTime.now().toIso8601String(),
        amount: amount,
        purposeId: purposeId,
        note: note.trim(),
      ),
      ...data.givingNotes,
    ];
    await persist();
  }

  bool verifyPin(String pin) => pin.trim() == data.settings.adminPin;

  Future<void> changePin(String pin) async {
    data.settings.adminPin = pin.trim();
    await persist();
  }

  Future<void> upsertAnnouncement(Announcement item) async {
    _upsert(data.announcements, item.id, item, (list) => data.announcements = list);
    await persist();
  }

  Future<void> deleteAnnouncement(String id) async {
    data.announcements = data.announcements.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertService(ServiceOrder item) async {
    _upsert(data.services, item.id, item, (list) => data.services = list);
    await persist();
  }

  Future<void> deleteService(String id) async {
    data.services = data.services.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertEvent(ChurchEvent item) async {
    _upsert(data.events, item.id, item, (list) => data.events = list);
    await persist();
  }

  Future<void> deleteEvent(String id) async {
    data.events = data.events.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertSermon(Sermon item) async {
    _upsert(data.sermons, item.id, item, (list) => data.sermons = list);
    await persist();
  }

  Future<void> deleteSermon(String id) async {
    data.sermons = data.sermons.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertHymn(Hymn item) async {
    _upsert(data.hymns, item.id, item, (list) => data.hymns = list);
    await persist();
  }

  Future<void> deleteHymn(String id) async {
    data.hymns = data.hymns.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertContact(RoleContact item) async {
    _upsert(data.contacts, item.id, item, (list) => data.contacts = list);
    await persist();
  }

  Future<void> deleteContact(String id) async {
    data.contacts = data.contacts.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> upsertSunday(SundaySlot item) async {
    _upsert(data.sundayTimes, item.id, item, (list) => data.sundayTimes = list);
    await persist();
  }

  Future<void> deleteSunday(String id) async {
    data.sundayTimes = data.sundayTimes.where((e) => e.id != id).toList();
    await persist();
  }

  Future<void> saveGiving(GivingConfig giving) async {
    data.giving = giving;
    await persist();
  }

  Future<void> saveChurch(ChurchInfo info) async {
    data.church = info;
    await persist();
  }

  Future<void> restoreSeed() async {
    data = await loadSeed();
    await persist();
  }

  void _upsert<T>(
    List<T> current,
    String id,
    T item,
    void Function(List<T>) assign, {
    String Function(T)? idOf,
  }) {
    final getter = idOf ??
        (T e) {
          if (e is Announcement) return e.id;
          if (e is ServiceOrder) return e.id;
          if (e is ChurchEvent) return e.id;
          if (e is Sermon) return e.id;
          if (e is Hymn) return e.id;
          if (e is RoleContact) return e.id;
          if (e is SundaySlot) return e.id;
          return '';
        };
    final next = [...current];
    final i = next.indexWhere((e) => getter(e) == id);
    if (i >= 0) {
      next[i] = item;
    } else {
      next.insert(0, item);
    }
    assign(next);
  }
}


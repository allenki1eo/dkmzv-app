import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'hymn_search.dart';
import 'models.dart';
import 'youtube.dart';
import '../theme/brand.dart';
import '../theme/liturgical.dart';

/// `#RRGGBB` or `#AARRGGBB` to a [Color]; null when the office typed junk.
Color? parseHexColor(String raw) {
  var hex = raw.trim().replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  if (hex.length != 8) return null;
  final value = int.tryParse(hex, radix: 16);
  return value == null ? null : Color(value);
}

/// Metres between two WGS84 points (haversine) — used for jumuiya geofences.
double metersBetween(double lat1, double lng1, double lat2, double lng2) {
  const earth = 6371000.0;
  double rad(double d) => d * math.pi / 180.0;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) *
          math.sin(dLng / 2) * math.sin(dLng / 2);
  return earth * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

const seedAsset = 'assets/seed/church.json';
const dataVersion = 4;
const _dataKey = 'church_data_v1';
const _localeKey = 'locale_code';
const _favKey = 'favorite_hymn_ids';
const _recentKey = 'recent_hymn_ids';
const _lastIbadaKey = 'last_opened_ibada_id';
const _vestmentKey = 'vestment_preview';

class ChurchStore extends ChangeNotifier {
  ChurchStore._(
    this._prefs,
    this.data,
    this.localeCode,
    this.favoriteIds,
    this.recentHymnIds,
    this.lastOpenedIbadaId,
    this.vestmentPreview,
  );

  final SharedPreferences? _prefs;
  ChurchData data;
  String localeCode;
  List<String> favoriteIds;
  List<String> recentHymnIds;
  String? lastOpenedIbadaId;
  /// When set (`purple`/`green`/`white`/`red`), UI cloth follows that vestment.
  String? vestmentPreview;

  static const _uuid = Uuid();

  bool get sw => localeCode != 'en';

  static Future<ChurchStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dataKey);
    final ChurchData parsed;
    if (raw != null && raw.isNotEmpty) {
      parsed = await migrateV2(
          ChurchData.fromJson(jsonDecode(raw) as Map<String, dynamic>));
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
      prefs.getString(_vestmentKey),
    );
  }

  static Future<ChurchData> loadSeed() async {
    final seed = await rootBundle.loadString(seedAsset);
    return ChurchData.fromJson(jsonDecode(seed) as Map<String, dynamic>);
  }

  /// Accents that shipped before the purple-free palette. Phones carrying
  /// them get the new colours; anything the office chose itself is left alone.
  static const _retiredAccents = {
    '#2E0854',
    '#8A5A00',
    '#123A5C',
    '#6C3FA0',
  };

  /// Older installs miss congregations (v1), offering groups (v2) or the
  /// neutral palette (v3). Fill only what is empty or retired so office edits
  /// survive.
  static Future<ChurchData> migrateV2(ChurchData data) async {
    if (data.version >= dataVersion &&
        data.congregations.isNotEmpty &&
        data.giving.categories.isNotEmpty) {
      _ensureSelectedCongregation(data);
      return data;
    }
    final seed = await loadSeed();
    if (data.congregations.isEmpty) {
      data.congregations = seed.congregations;
    }
    if (data.jumuiyas.isEmpty) {
      data.jumuiyas = seed.jumuiyas;
    }
    if (data.giving.categories.isEmpty) {
      data.giving.categories = seed.giving.categories;
    }
    if (data.giving.payments.stripeNoteSw.isEmpty) {
      data.giving.payments = seed.giving.payments;
    }
    for (final c in data.congregations) {
      final fromSeed = seed.congregationById(c.id);
      if (fromSeed == null) continue;
      if (c.accentHex.isEmpty ||
          _retiredAccents.contains(c.accentHex.toUpperCase())) {
        c.accentHex = fromSeed.accentHex;
      }
    }
    for (final j in data.jumuiyas) {
      if (!_retiredAccents.contains(j.colorHex.toUpperCase())) continue;
      final fromSeed = seed.jumuiyaById(j.id);
      j.colorHex = fromSeed?.colorHex ?? '';
    }
    data.version = dataVersion;
    _ensureSelectedCongregation(data);
    return data;
  }

  static void _ensureSelectedCongregation(ChurchData data) {
    if (data.congregations.isEmpty) return;
    final current = data.settings.selectedCongregationId;
    final known = data.congregationById(current);
    if (known != null) return;
    final main = data.congregations.where((c) => c.isMain);
    data.settings.selectedCongregationId =
        main.isNotEmpty ? main.first.id : data.congregations.first.id;
  }

  /// In-memory store for tests (no SharedPreferences).
  factory ChurchStore.memory(ChurchData data, {String locale = 'sw'}) {
    return ChurchStore._(null, data, locale, [], [], null, null);
  }

  LiturgicalMoment get moment {
    final preview = vestmentPreview;
    if (preview != null) {
      final v = Vestment.values.asNameMap()[preview];
      if (v != null) return LiturgicalCalendar.preview(v);
    }
    return LiturgicalCalendar.at(DateTime.now());
  }

  SeasonPalette get palette => moment.palette;

  Future<void> setVestmentPreview(String? name) async {
    vestmentPreview = name;
    await persist();
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
      if (vestmentPreview == null) {
        await prefs.remove(_vestmentKey);
      } else {
        await prefs.setString(_vestmentKey, vestmentPreview!);
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
    String categoryId = '',
    String method = 'mpesa',
  }) async {
    data.givingNotes = [
      GivingNote(
        id: _uuid.v4(),
        at: DateTime.now().toIso8601String(),
        amount: amount,
        purposeId: purposeId,
        note: note.trim(),
        categoryId: categoryId,
        method: method,
      ),
      ...data.givingNotes,
    ];
    await persist();
  }

  Future<void> deleteGivingNote(String id) async {
    data.givingNotes = data.givingNotes.where((n) => n.id != id).toList();
    await persist();
  }

  /// My own notes per offering group — bahasha stays apart from fungu la kumi.
  Map<String, int> get givingTotalsByGroup {
    final totals = <String, int>{};
    for (final n in data.givingNotes) {
      final group =
          data.giving.categoryById(n.categoryId)?.group ?? GivingGroups.sadaka;
      totals[group] = (totals[group] ?? 0) + n.amount;
    }
    return totals;
  }

  Future<void> upsertGivingCategory(GivingCategory item) async {
    _upsert(data.giving.categories, item.id, item,
        (list) => data.giving.categories = list);
    await persist();
  }

  Future<void> deleteGivingCategory(String id) async {
    data.giving.categories =
        data.giving.categories.where((c) => c.id != id).toList();
    await persist();
  }

  Future<void> savePayments(PaymentConfig payments) async {
    data.giving.payments = payments;
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

  ThemeMode get themeMode {
    switch (data.settings.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(String mode) async {
    data.settings.themeMode =
        const {'light', 'dark', 'system'}.contains(mode) ? mode : 'system';
    await persist();
  }

  String get backgroundId => data.settings.backgroundId;

  Future<void> setBackground(String id) async {
    data.settings.backgroundId = id;
    await persist();
  }

  /// Identity colour of the active usharika (vestments stay liturgical).
  Color get parishAccent {
    final hex = selectedCongregation?.accentHex ?? '';
    return parseHexColor(hex) ?? DkmzvBrand.ink;
  }

  Congregation? get selectedCongregation {
    final byId = data.congregationById(data.settings.selectedCongregationId);
    if (byId != null) return byId;
    for (final c in data.congregations) {
      if (c.isMain) return c;
    }
    return data.congregations.isEmpty ? null : data.congregations.first;
  }

  MemberRecord? get currentMember {
    final id = data.settings.currentMemberId;
    if (id == null || id.isEmpty) return null;
    for (final m in data.members) {
      if (m.id == id) return m;
    }
    return data.members.isEmpty ? null : data.members.first;
  }

  Sermon? get liveSermon {
    final live = data.sermons.where((s) => s.isLive).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return live.isEmpty ? null : live.first;
  }

  /// What the home screen offers to play: the live stream if the office
  /// flipped the switch, otherwise the newest sermon that has a link.
  Sermon? get watchNow {
    final live = liveSermon;
    if (live != null) return live;
    final playable = data.sermons.where((s) => s.mediaUrl.isNotEmpty).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return playable.isEmpty ? null : playable.first;
  }

  /// Parish channel (`UC…` id or `@handle`), used for channel-level live.
  String get youtubeChannel => data.settings.youtubeChannel;

  Future<void> setYoutubeChannel(String raw) async {
    data.settings.youtubeChannel = normaliseChannel(raw);
    await persist();
  }

  List<Jumuiya> jumuiyasFor(String congregationId) =>
      data.jumuiyas.where((j) => j.congregationId == congregationId).toList();

  List<HomePin> pinsForJumuiya(String jumuiyaId) =>
      data.homePins.where((p) => p.jumuiyaId == jumuiyaId).toList();

  List<HomePin> pinsForCongregation(String congregationId) =>
      data.homePins.where((p) => p.congregationId == congregationId).toList();

  List<MemberRecord> membersForCongregation(String congregationId) =>
      data.members.where((m) => m.congregationId == congregationId).toList();

  List<MemberRecord> membersForJumuiya(String jumuiyaId) =>
      data.members.where((m) => m.jumuiyaId == jumuiyaId).toList();

  List<MemberRecord> searchMembers(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return data.members;
    return data.members.where((m) {
      final jumuiya = data.jumuiyaById(m.jumuiyaId)?.nameSw ?? '';
      return '${m.fullName} ${m.kaya} ${m.phone} $jumuiya'
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  /// Home pins that fall inside the jumuiya geofence circle.
  List<HomePin> pinsInsideGeofence(Jumuiya jumuiya) => data.homePins
      .where((p) =>
          metersBetween(
              jumuiya.latitude, jumuiya.longitude, p.latitude, p.longitude) <=
          jumuiya.radiusMeters)
      .toList();

  /// Nearest jumuiya whose geofence contains the point, else null.
  Jumuiya? jumuiyaAt(double lat, double lng, {String? congregationId}) {
    Jumuiya? best;
    var bestDistance = double.infinity;
    for (final j in data.jumuiyas) {
      if (congregationId != null && j.congregationId != congregationId) {
        continue;
      }
      final d = metersBetween(j.latitude, j.longitude, lat, lng);
      if (d <= j.radiusMeters && d < bestDistance) {
        best = j;
        bestDistance = d;
      }
    }
    return best;
  }

  Future<void> selectCongregation(String id) async {
    data.settings.selectedCongregationId = id;
    await persist();
  }

  Future<void> saveMember(MemberRecord member) async {
    _upsert(data.members, member.id, member, (list) => data.members = list);
    data.settings.currentMemberId = member.id;
    if (member.shareHomePin &&
        member.homeLat != null &&
        member.homeLng != null &&
        member.jumuiyaId.isNotEmpty) {
      await pingHome(
        memberId: member.id,
        jumuiyaId: member.jumuiyaId,
        congregationId: member.congregationId,
        label: member.fullName.trim().isEmpty
            ? 'Nyumba'
            : 'Nyumba ya ${member.fullName.trim()}',
        lat: member.homeLat!,
        lng: member.homeLng!,
        note: member.householdNote,
        persistAfter: false,
      );
    }
    await persist();
  }

  Future<void> deleteMember(String id) async {
    data.members = data.members.where((m) => m.id != id).toList();
    data.homePins = data.homePins.where((p) => p.memberId != id).toList();
    if (data.settings.currentMemberId == id) {
      data.settings.currentMemberId = null;
    }
    await persist();
  }

  Future<void> pingHome({
    required String memberId,
    required String jumuiyaId,
    required String congregationId,
    required String label,
    required double lat,
    required double lng,
    String note = '',
    bool persistAfter = true,
  }) async {
    final existing = data.homePins.where((p) => p.memberId == memberId);
    final id = existing.isNotEmpty ? existing.first.id : _uuid.v4();
    _upsert(
      data.homePins,
      id,
      HomePin(
        id: id,
        memberId: memberId,
        jumuiyaId: jumuiyaId,
        congregationId: congregationId,
        label: label.trim().isEmpty ? 'Nyumba' : label.trim(),
        latitude: lat,
        longitude: lng,
        note: note.trim(),
        at: DateTime.now().toIso8601String(),
      ),
      (list) => data.homePins = list,
    );
    final member = data.members.where((m) => m.id == memberId);
    if (member.isNotEmpty) {
      member.first.shareHomePin = true;
      member.first.homeLat = lat;
      member.first.homeLng = lng;
      member.first.jumuiyaId = jumuiyaId;
      member.first.congregationId = congregationId;
    }
    if (persistAfter) await persist();
  }

  Future<void> deleteHomePin(String id) async {
    data.homePins = data.homePins.where((p) => p.id != id).toList();
    await persist();
  }

  Future<void> upsertCongregation(Congregation item) async {
    _upsert(data.congregations, item.id, item,
        (list) => data.congregations = list);
    await persist();
  }

  Future<void> upsertJumuiya(Jumuiya item) async {
    _upsert(data.jumuiyas, item.id, item, (list) => data.jumuiyas = list);
    await persist();
  }

  Future<void> deleteJumuiya(String id) async {
    data.jumuiyas = data.jumuiyas.where((j) => j.id != id).toList();
    await persist();
  }

  Future<void> deleteCongregation(String id) async {
    data.congregations = data.congregations.where((c) => c.id != id).toList();
    data.jumuiyas = data.jumuiyas.where((j) => j.congregationId != id).toList();
    _ensureSelectedCongregation(data);
    await persist();
  }

  /// One switch for "tuna live sasa" on today's stream.
  Future<void> setLiveSermon(String sermonId, bool live) async {
    for (final s in data.sermons) {
      if (s.id == sermonId) {
        s.isLive = live;
      } else if (live) {
        s.isLive = false;
      }
    }
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
          if (e is Congregation) return e.id;
          if (e is Jumuiya) return e.id;
          if (e is MemberRecord) return e.id;
          if (e is HomePin) return e.id;
          if (e is GivingCategory) return e.id;
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


String _s(dynamic v, [String fallback = '']) => v?.toString() ?? fallback;

int _i(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  return int.tryParse('$v') ?? fallback;
}

double _d(dynamic v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  return double.tryParse('$v') ?? fallback;
}

bool _b(dynamic v, [bool fallback = false]) {
  if (v is bool) return v;
  return fallback;
}

List<String> _ss(dynamic v) {
  if (v is List) return v.map((e) => '$e').toList();
  return const [];
}

DateTime? parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

class ChurchSettings {
  ChurchSettings({
    required this.adminPin,
    required this.fcmConfigured,
    required this.defaultLocale,
    this.selectedCongregationId = '',
    this.currentMemberId,
    this.themeMode = 'system',
    this.backgroundId = 'none',
    this.youtubeChannel = '',
  });

  String adminPin;
  bool fcmConfigured;
  String defaultLocale;
  String selectedCongregationId;
  String? currentMemberId;

  /// `system` | `light` | `dark`
  String themeMode;
  String backgroundId;

  /// Parish channel as a `UC…` id or an `@handle`. With a channel id the live
  /// stream plays in-app without anyone pasting this Sunday's video link.
  String youtubeChannel;

  factory ChurchSettings.fromJson(Map<String, dynamic> j) {
    final member = _s(j['currentMemberId']);
    return ChurchSettings(
      adminPin: _s(j['adminPin'], 'dkmzv'),
      fcmConfigured: _b(j['fcmConfigured']),
      defaultLocale: _s(j['defaultLocale'], 'sw'),
      selectedCongregationId: _s(j['selectedCongregationId']),
      currentMemberId: member.isEmpty ? null : member,
      themeMode: _s(j['themeMode'], 'system'),
      backgroundId: _s(j['backgroundId'], 'none'),
      youtubeChannel: _s(j['youtubeChannel']),
    );
  }

  Map<String, dynamic> toJson() => {
        'adminPin': adminPin,
        'fcmConfigured': fcmConfigured,
        'defaultLocale': defaultLocale,
        'selectedCongregationId': selectedCongregationId,
        'currentMemberId': currentMemberId ?? '',
        'themeMode': themeMode,
        'backgroundId': backgroundId,
        'youtubeChannel': youtubeChannel,
      };
}

class ChurchInfo {
  ChurchInfo({
    required this.nameSw,
    required this.nameEn,
    required this.shortName,
    required this.denominationSw,
    required this.denominationEn,
    required this.dioceseSw,
    required this.dioceseEn,
    required this.addressSw,
    required this.addressEn,
    required this.mapUrl,
    required this.latitude,
    required this.longitude,
    required this.officeHoursSw,
    required this.officeHoursEn,
    required this.whatsappNoteSw,
    required this.whatsappNoteEn,
    required this.aboutSw,
    required this.aboutEn,
  });

  String nameSw;
  String nameEn;
  String shortName;
  String denominationSw;
  String denominationEn;
  String dioceseSw;
  String dioceseEn;
  String addressSw;
  String addressEn;
  String mapUrl;
  double latitude;
  double longitude;
  String officeHoursSw;
  String officeHoursEn;
  String whatsappNoteSw;
  String whatsappNoteEn;
  String aboutSw;
  String aboutEn;

  String name(bool sw) => sw ? nameSw : nameEn;
  String address(bool sw) => sw ? addressSw : addressEn;
  String hours(bool sw) => sw ? officeHoursSw : officeHoursEn;
  String about(bool sw) => sw ? aboutSw : aboutEn;
  String whatsapp(bool sw) => sw ? whatsappNoteSw : whatsappNoteEn;
  String diocese(bool sw) => sw ? dioceseSw : dioceseEn;

  factory ChurchInfo.fromJson(Map<String, dynamic> j) => ChurchInfo(
        nameSw: _s(j['nameSw']),
        nameEn: _s(j['nameEn']),
        shortName: _s(j['shortName'], 'DKMZV'),
        denominationSw: _s(j['denominationSw']),
        denominationEn: _s(j['denominationEn']),
        dioceseSw: _s(j['dioceseSw']),
        dioceseEn: _s(j['dioceseEn']),
        addressSw: _s(j['addressSw']),
        addressEn: _s(j['addressEn']),
        mapUrl: _s(j['mapUrl']),
        latitude: _d(j['latitude']),
        longitude: _d(j['longitude']),
        officeHoursSw: _s(j['officeHoursSw']),
        officeHoursEn: _s(j['officeHoursEn']),
        whatsappNoteSw: _s(j['whatsappNoteSw']),
        whatsappNoteEn: _s(j['whatsappNoteEn']),
        aboutSw: _s(j['aboutSw']),
        aboutEn: _s(j['aboutEn']),
      );

  Map<String, dynamic> toJson() => {
        'nameSw': nameSw,
        'nameEn': nameEn,
        'shortName': shortName,
        'denominationSw': denominationSw,
        'denominationEn': denominationEn,
        'dioceseSw': dioceseSw,
        'dioceseEn': dioceseEn,
        'addressSw': addressSw,
        'addressEn': addressEn,
        'mapUrl': mapUrl,
        'latitude': latitude,
        'longitude': longitude,
        'officeHoursSw': officeHoursSw,
        'officeHoursEn': officeHoursEn,
        'whatsappNoteSw': whatsappNoteSw,
        'whatsappNoteEn': whatsappNoteEn,
        'aboutSw': aboutSw,
        'aboutEn': aboutEn,
      };
}

class Congregation {
  Congregation({
    required this.id,
    required this.nameSw,
    required this.nameEn,
    required this.roleSw,
    required this.roleEn,
    required this.isMain,
    required this.approximate,
    required this.addressSw,
    required this.addressEn,
    required this.latitude,
    required this.longitude,
    required this.noteSw,
    required this.noteEn,
    this.accentHex = '#0F5F52',
    this.motif = 'church',
    this.taglineSw = '',
    this.taglineEn = '',
  });

  String id;
  String nameSw;
  String nameEn;
  String roleSw;
  String roleEn;
  bool isMain;
  bool approximate;
  String addressSw;
  String addressEn;
  double latitude;
  double longitude;
  String noteSw;
  String noteEn;

  /// Identity colour for this usharika's chrome (vestments stay liturgical).
  String accentHex;
  String motif;
  String taglineSw;
  String taglineEn;

  String name(bool sw) => sw ? nameSw : nameEn;
  String role(bool sw) => sw ? roleSw : roleEn;
  String address(bool sw) => sw ? addressSw : addressEn;
  String note(bool sw) => sw ? noteSw : noteEn;
  String tagline(bool sw) => sw ? taglineSw : taglineEn;

  String get osmUrl =>
      'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=16/$latitude/$longitude';

  factory Congregation.fromJson(Map<String, dynamic> j) => Congregation(
        id: _s(j['id']),
        nameSw: _s(j['nameSw']),
        nameEn: _s(j['nameEn']),
        roleSw: _s(j['roleSw']),
        roleEn: _s(j['roleEn']),
        isMain: _b(j['isMain']),
        approximate: _b(j['approximate']),
        addressSw: _s(j['addressSw']),
        addressEn: _s(j['addressEn']),
        latitude: _d(j['latitude']),
        longitude: _d(j['longitude']),
        noteSw: _s(j['noteSw']),
        noteEn: _s(j['noteEn']),
        accentHex: _s(j['accentHex'], '#0F5F52'),
        motif: _s(j['motif'], 'church'),
        taglineSw: _s(j['taglineSw']),
        taglineEn: _s(j['taglineEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameSw': nameSw,
        'nameEn': nameEn,
        'roleSw': roleSw,
        'roleEn': roleEn,
        'isMain': isMain,
        'approximate': approximate,
        'addressSw': addressSw,
        'addressEn': addressEn,
        'latitude': latitude,
        'longitude': longitude,
        'noteSw': noteSw,
        'noteEn': noteEn,
        'accentHex': accentHex,
        'motif': motif,
        'taglineSw': taglineSw,
        'taglineEn': taglineEn,
      };
}

class Jumuiya {
  Jumuiya({
    required this.id,
    required this.congregationId,
    required this.nameSw,
    required this.nameEn,
    required this.meetingNoteSw,
    required this.meetingNoteEn,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 450,
    this.colorHex = '',
    this.leaderRole = '',
  });

  String id;
  String congregationId;
  String nameSw;
  String nameEn;
  String meetingNoteSw;
  String meetingNoteEn;
  double latitude;
  double longitude;

  /// Geofence the office draws around a jumuiya so homes can be grouped.
  double radiusMeters;
  String colorHex;
  String leaderRole;

  String name(bool sw) => sw ? nameSw : nameEn;
  String meetingNote(bool sw) => sw ? meetingNoteSw : meetingNoteEn;

  factory Jumuiya.fromJson(Map<String, dynamic> j) => Jumuiya(
        id: _s(j['id']),
        congregationId: _s(j['congregationId']),
        nameSw: _s(j['nameSw']),
        nameEn: _s(j['nameEn']),
        meetingNoteSw: _s(j['meetingNoteSw']),
        meetingNoteEn: _s(j['meetingNoteEn']),
        latitude: _d(j['latitude']),
        longitude: _d(j['longitude']),
        radiusMeters: _d(j['radiusMeters'], 450),
        colorHex: _s(j['colorHex']),
        leaderRole: _s(j['leaderRole']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'congregationId': congregationId,
        'nameSw': nameSw,
        'nameEn': nameEn,
        'meetingNoteSw': meetingNoteSw,
        'meetingNoteEn': meetingNoteEn,
        'latitude': latitude,
        'longitude': longitude,
        'radiusMeters': radiusMeters,
        'colorHex': colorHex,
        'leaderRole': leaderRole,
      };
}

class HomePin {
  HomePin({
    required this.id,
    required this.memberId,
    required this.jumuiyaId,
    required this.congregationId,
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.at,
  });

  String id;
  String memberId;
  String jumuiyaId;
  String congregationId;
  String label;
  double latitude;
  double longitude;
  String note;
  String at;

  factory HomePin.fromJson(Map<String, dynamic> j) => HomePin(
        id: _s(j['id']),
        memberId: _s(j['memberId']),
        jumuiyaId: _s(j['jumuiyaId']),
        congregationId: _s(j['congregationId']),
        label: _s(j['label']),
        latitude: _d(j['latitude']),
        longitude: _d(j['longitude']),
        note: _s(j['note']),
        at: _s(j['at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'jumuiyaId': jumuiyaId,
        'congregationId': congregationId,
        'label': label,
        'latitude': latitude,
        'longitude': longitude,
        'note': note,
        'at': at,
      };
}

class MemberRecord {
  MemberRecord({
    required this.id,
    required this.fullName,
    required this.congregationId,
    required this.jumuiyaId,
    required this.phone,
    required this.householdNote,
    required this.shareHomePin,
    this.homeLat,
    this.homeLng,
    required this.registeredAt,
    this.kaya = '',
    this.gender = '',
    this.status = 'mwanachama',
    this.baptized = false,
    this.confirmed = false,
    this.birthYear = '',
    this.bahashaNo = '',
  });

  String id;
  String fullName;
  String congregationId;
  String jumuiyaId;
  /// Kept on this phone for the office inbox — never shown as a public directory.
  String phone;
  String householdNote;
  bool shareHomePin;
  double? homeLat;
  double? homeLng;
  String registeredAt;

  /// Household the waumini belongs to (kaya).
  String kaya;
  /// `me` (mwanamume) | `ke` (mwanamke) | empty
  String gender;
  /// `mwanachama` | `kijana` | `mtoto` | `mgeni`
  String status;
  bool baptized;
  bool confirmed;
  String birthYear;

  /// Envelope number the office issued. This is how a mwumini's offering is
  /// recognised in the books, so it is the one figure they need to hand.
  String bahashaNo;

  factory MemberRecord.fromJson(Map<String, dynamic> j) {
    final lat = j['homeLat'];
    final lng = j['homeLng'];
    return MemberRecord(
      id: _s(j['id']),
      fullName: _s(j['fullName']),
      congregationId: _s(j['congregationId']),
      jumuiyaId: _s(j['jumuiyaId']),
      phone: _s(j['phone']),
      householdNote: _s(j['householdNote']),
      shareHomePin: _b(j['shareHomePin']),
      homeLat: lat == null || '$lat'.isEmpty ? null : _d(lat),
      homeLng: lng == null || '$lng'.isEmpty ? null : _d(lng),
      registeredAt: _s(j['registeredAt']),
      kaya: _s(j['kaya']),
      gender: _s(j['gender']),
      status: _s(j['status'], 'mwanachama'),
      baptized: _b(j['baptized']),
      confirmed: _b(j['confirmed']),
      birthYear: _s(j['birthYear']),
      bahashaNo: _s(j['bahashaNo']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'congregationId': congregationId,
        'jumuiyaId': jumuiyaId,
        'phone': phone,
        'householdNote': householdNote,
        'shareHomePin': shareHomePin,
        'homeLat': homeLat,
        'homeLng': homeLng,
        'registeredAt': registeredAt,
        'kaya': kaya,
        'gender': gender,
        'status': status,
        'baptized': baptized,
        'confirmed': confirmed,
        'birthYear': birthYear,
        'bahashaNo': bahashaNo,
      };
}

class SundaySlot {
  SundaySlot({
    required this.id,
    required this.time,
    required this.titleSw,
    required this.titleEn,
    required this.noteSw,
    required this.noteEn,
  });

  String id;
  String time;
  String titleSw;
  String titleEn;
  String noteSw;
  String noteEn;

  String title(bool sw) => sw ? titleSw : titleEn;
  String note(bool sw) => sw ? noteSw : noteEn;

  factory SundaySlot.fromJson(Map<String, dynamic> j) => SundaySlot(
        id: _s(j['id']),
        time: _s(j['time']),
        titleSw: _s(j['titleSw']),
        titleEn: _s(j['titleEn']),
        noteSw: _s(j['noteSw']),
        noteEn: _s(j['noteEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'titleSw': titleSw,
        'titleEn': titleEn,
        'noteSw': noteSw,
        'noteEn': noteEn,
      };
}

class Announcement {
  Announcement({
    required this.id,
    required this.pinned,
    required this.date,
    required this.titleSw,
    required this.titleEn,
    required this.bodySw,
    required this.bodyEn,
  });

  String id;
  bool pinned;
  String date;
  String titleSw;
  String titleEn;
  String bodySw;
  String bodyEn;

  String title(bool sw) => sw ? titleSw : titleEn;
  String body(bool sw) => sw ? bodySw : bodyEn;

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: _s(j['id']),
        pinned: _b(j['pinned']),
        date: _s(j['date']),
        titleSw: _s(j['titleSw']),
        titleEn: _s(j['titleEn']),
        bodySw: _s(j['bodySw']),
        bodyEn: _s(j['bodyEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pinned': pinned,
        'date': date,
        'titleSw': titleSw,
        'titleEn': titleEn,
        'bodySw': bodySw,
        'bodyEn': bodyEn,
      };
}

class Reading {
  Reading({required this.labelSw, required this.labelEn, required this.ref});
  String labelSw;
  String labelEn;
  String ref;
  String label(bool sw) => sw ? labelSw : labelEn;

  factory Reading.fromJson(Map<String, dynamic> j) => Reading(
        labelSw: _s(j['labelSw']),
        labelEn: _s(j['labelEn']),
        ref: _s(j['ref']),
      );

  Map<String, dynamic> toJson() => {
        'labelSw': labelSw,
        'labelEn': labelEn,
        'ref': ref,
      };
}

class ServiceOrder {
  ServiceOrder({
    required this.id,
    required this.date,
    required this.liturgicalColor,
    required this.themeSw,
    required this.themeEn,
    required this.sermonTitleSw,
    required this.sermonTitleEn,
    required this.preacherSw,
    required this.preacherEn,
    required this.readings,
    required this.outlineSw,
    required this.outlineEn,
    required this.hymnIds,
    required this.bulletinUrl,
    required this.bulletinNoteSw,
    required this.bulletinNoteEn,
  });

  String id;
  String date;
  String liturgicalColor;
  String themeSw;
  String themeEn;
  String sermonTitleSw;
  String sermonTitleEn;
  String preacherSw;
  String preacherEn;
  List<Reading> readings;
  List<String> outlineSw;
  List<String> outlineEn;
  List<String> hymnIds;
  String bulletinUrl;
  String bulletinNoteSw;
  String bulletinNoteEn;

  String theme(bool sw) => sw ? themeSw : themeEn;
  String sermonTitle(bool sw) => sw ? sermonTitleSw : sermonTitleEn;
  String preacher(bool sw) => sw ? preacherSw : preacherEn;
  List<String> outline(bool sw) => sw ? outlineSw : outlineEn;
  String bulletinNote(bool sw) => sw ? bulletinNoteSw : bulletinNoteEn;

  factory ServiceOrder.fromJson(Map<String, dynamic> j) => ServiceOrder(
        id: _s(j['id']),
        date: _s(j['date']),
        liturgicalColor: _s(j['liturgicalColor'], 'green'),
        themeSw: _s(j['themeSw']),
        themeEn: _s(j['themeEn']),
        sermonTitleSw: _s(j['sermonTitleSw']),
        sermonTitleEn: _s(j['sermonTitleEn']),
        preacherSw: _s(j['preacherSw']),
        preacherEn: _s(j['preacherEn']),
        readings: (j['readings'] as List? ?? [])
            .map((e) => Reading.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        outlineSw: _ss(j['outlineSw']),
        outlineEn: _ss(j['outlineEn']),
        hymnIds: _ss(j['hymnIds']),
        bulletinUrl: _s(j['bulletinUrl']),
        bulletinNoteSw: _s(j['bulletinNoteSw']),
        bulletinNoteEn: _s(j['bulletinNoteEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'liturgicalColor': liturgicalColor,
        'themeSw': themeSw,
        'themeEn': themeEn,
        'sermonTitleSw': sermonTitleSw,
        'sermonTitleEn': sermonTitleEn,
        'preacherSw': preacherSw,
        'preacherEn': preacherEn,
        'readings': readings.map((e) => e.toJson()).toList(),
        'outlineSw': outlineSw,
        'outlineEn': outlineEn,
        'hymnIds': hymnIds,
        'bulletinUrl': bulletinUrl,
        'bulletinNoteSw': bulletinNoteSw,
        'bulletinNoteEn': bulletinNoteEn,
      };
}

class ChurchEvent {
  ChurchEvent({
    required this.id,
    required this.category,
    required this.start,
    required this.end,
    required this.titleSw,
    required this.titleEn,
    required this.placeSw,
    required this.placeEn,
    required this.detailSw,
    required this.detailEn,
  });

  String id;
  String category;
  String start;
  String end;
  String titleSw;
  String titleEn;
  String placeSw;
  String placeEn;
  String detailSw;
  String detailEn;

  String title(bool sw) => sw ? titleSw : titleEn;
  String place(bool sw) => sw ? placeSw : placeEn;
  String detail(bool sw) => sw ? detailSw : detailEn;
  DateTime? get startAt => parseDate(start);
  DateTime? get endAt => parseDate(end);

  factory ChurchEvent.fromJson(Map<String, dynamic> j) => ChurchEvent(
        id: _s(j['id']),
        category: _s(j['category'], 'worship'),
        start: _s(j['start']),
        end: _s(j['end']),
        titleSw: _s(j['titleSw']),
        titleEn: _s(j['titleEn']),
        placeSw: _s(j['placeSw']),
        placeEn: _s(j['placeEn']),
        detailSw: _s(j['detailSw']),
        detailEn: _s(j['detailEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'start': start,
        'end': end,
        'titleSw': titleSw,
        'titleEn': titleEn,
        'placeSw': placeSw,
        'placeEn': placeEn,
        'detailSw': detailSw,
        'detailEn': detailEn,
      };
}

class GivingPurpose {
  GivingPurpose({required this.id, required this.sw, required this.en});
  String id;
  String sw;
  String en;
  String label(bool isSw) => isSw ? sw : en;

  factory GivingPurpose.fromJson(Map<String, dynamic> j) => GivingPurpose(
        id: _s(j['id']),
        sw: _s(j['sw']),
        en: _s(j['en']),
      );

  Map<String, dynamic> toJson() => {'id': id, 'sw': sw, 'en': en};
}

/// Offering kinds KKKT keeps apart in the books.
class GivingGroups {
  static const bahasha = 'bahasha';
  static const fungu = 'fungu';
  static const shukrani = 'shukrani';
  static const sadaka = 'sadaka';

  static const ordered = [bahasha, fungu, shukrani, sadaka];
}

class GivingCategory {
  GivingCategory({
    required this.id,
    required this.group,
    required this.sw,
    required this.en,
    this.exempt = false,
    this.stripeUrl = '',
    this.noteSw = '',
    this.noteEn = '',
    this.amounts = const [],
  });

  String id;
  String group;
  String sw;
  String en;

  /// Bahasha envelopes (ujenzi, utumishi, imarisha usharika…) are marked
  /// exempt: they are not counted with fungu la kumi or shukrani.
  bool exempt;
  String stripeUrl;
  String noteSw;
  String noteEn;
  List<int> amounts;

  String label(bool isSw) => isSw ? sw : en;
  String note(bool isSw) => isSw ? noteSw : noteEn;

  factory GivingCategory.fromJson(Map<String, dynamic> j) => GivingCategory(
        id: _s(j['id']),
        group: _s(j['group'], GivingGroups.sadaka),
        sw: _s(j['sw']),
        en: _s(j['en']),
        exempt: _b(j['exempt']),
        stripeUrl: _s(j['stripeUrl']),
        noteSw: _s(j['noteSw']),
        noteEn: _s(j['noteEn']),
        amounts: (j['amounts'] as List? ?? []).map((e) => _i(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'group': group,
        'sw': sw,
        'en': en,
        'exempt': exempt,
        'stripeUrl': stripeUrl,
        'noteSw': noteSw,
        'noteEn': noteEn,
        'amounts': amounts,
      };
}

/// Card / Stripe details. Stripe Payment Links need no SDK or secret key.
class PaymentConfig {
  PaymentConfig({
    this.stripeEnabled = false,
    this.stripeAccountName = '',
    this.defaultStripeUrl = '',
    this.stripeNoteSw = '',
    this.stripeNoteEn = '',
  });

  bool stripeEnabled;
  String stripeAccountName;
  String defaultStripeUrl;
  String stripeNoteSw;
  String stripeNoteEn;

  String stripeNote(bool sw) => sw ? stripeNoteSw : stripeNoteEn;

  factory PaymentConfig.fromJson(Map<String, dynamic> j) => PaymentConfig(
        stripeEnabled: _b(j['stripeEnabled']),
        stripeAccountName: _s(j['stripeAccountName']),
        defaultStripeUrl: _s(j['defaultStripeUrl']),
        stripeNoteSw: _s(j['stripeNoteSw']),
        stripeNoteEn: _s(j['stripeNoteEn']),
      );

  Map<String, dynamic> toJson() => {
        'stripeEnabled': stripeEnabled,
        'stripeAccountName': stripeAccountName,
        'defaultStripeUrl': defaultStripeUrl,
        'stripeNoteSw': stripeNoteSw,
        'stripeNoteEn': stripeNoteEn,
      };
}

class GivingConfig {
  GivingConfig({
    required this.paybill,
    required this.account,
    required this.accountName,
    required this.till,
    required this.lipaNoteSw,
    required this.lipaNoteEn,
    required this.stepsSw,
    required this.stepsEn,
    required this.tips,
    required this.purposes,
    List<GivingCategory>? categories,
    PaymentConfig? payments,
  })  : categories = categories ?? [],
        payments = payments ?? PaymentConfig();

  String paybill;
  String account;
  String accountName;
  String till;
  String lipaNoteSw;
  String lipaNoteEn;
  List<String> stepsSw;
  List<String> stepsEn;
  List<int> tips;
  List<GivingPurpose> purposes;
  List<GivingCategory> categories;
  PaymentConfig payments;

  String lipaNote(bool sw) => sw ? lipaNoteSw : lipaNoteEn;
  List<String> steps(bool sw) => sw ? stepsSw : stepsEn;

  List<GivingCategory> inGroup(String group) =>
      categories.where((c) => c.group == group).toList();

  GivingCategory? categoryById(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  factory GivingConfig.fromJson(Map<String, dynamic> j) => GivingConfig(
        paybill: _s(j['paybill']),
        account: _s(j['account']),
        accountName: _s(j['accountName']),
        till: _s(j['till']),
        lipaNoteSw: _s(j['lipaNoteSw']),
        lipaNoteEn: _s(j['lipaNoteEn']),
        stepsSw: _ss(j['stepsSw']),
        stepsEn: _ss(j['stepsEn']),
        tips: (j['tips'] as List? ?? []).map((e) => _i(e)).toList(),
        purposes: (j['purposes'] as List? ?? [])
            .map((e) =>
                GivingPurpose.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        categories: (j['categories'] as List? ?? [])
            .map((e) =>
                GivingCategory.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        payments: PaymentConfig.fromJson(
            Map<String, dynamic>.from(j['payments'] as Map? ?? {})),
      );

  Map<String, dynamic> toJson() => {
        'paybill': paybill,
        'account': account,
        'accountName': accountName,
        'till': till,
        'lipaNoteSw': lipaNoteSw,
        'lipaNoteEn': lipaNoteEn,
        'stepsSw': stepsSw,
        'stepsEn': stepsEn,
        'tips': tips,
        'purposes': purposes.map((e) => e.toJson()).toList(),
        'categories': categories.map((e) => e.toJson()).toList(),
        'payments': payments.toJson(),
      };
}

class GivingNote {
  GivingNote({
    required this.id,
    required this.at,
    required this.amount,
    required this.purposeId,
    required this.note,
    this.categoryId = '',
    this.method = 'mpesa',
  });

  String id;
  String at;
  int amount;
  String purposeId;
  String note;
  String categoryId;
  /// `mpesa` | `stripe` | `bahasha` | `taslimu`
  String method;

  factory GivingNote.fromJson(Map<String, dynamic> j) => GivingNote(
        id: _s(j['id']),
        at: _s(j['at']),
        amount: _i(j['amount']),
        purposeId: _s(j['purposeId']),
        note: _s(j['note']),
        categoryId: _s(j['categoryId']),
        method: _s(j['method'], 'mpesa'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'at': at,
        'amount': amount,
        'purposeId': purposeId,
        'note': note,
        'categoryId': categoryId,
        'method': method,
      };
}

class Sermon {
  Sermon({
    required this.id,
    required this.date,
    required this.titleSw,
    required this.titleEn,
    required this.preacherSw,
    required this.preacherEn,
    required this.mediaType,
    required this.mediaUrl,
    required this.noteSw,
    required this.noteEn,
    this.isLive = false,
    this.congregationId = '',
  });

  String id;
  String date;
  String titleSw;
  String titleEn;
  String preacherSw;
  String preacherEn;
  String mediaType;
  String mediaUrl;
  String noteSw;
  String noteEn;
  bool isLive;
  String congregationId;

  String title(bool sw) => sw ? titleSw : titleEn;
  String preacher(bool sw) => sw ? preacherSw : preacherEn;
  String note(bool sw) => sw ? noteSw : noteEn;

  factory Sermon.fromJson(Map<String, dynamic> j) => Sermon(
        id: _s(j['id']),
        date: _s(j['date']),
        titleSw: _s(j['titleSw']),
        titleEn: _s(j['titleEn']),
        preacherSw: _s(j['preacherSw']),
        preacherEn: _s(j['preacherEn']),
        mediaType: _s(j['mediaType'], 'link'),
        mediaUrl: _s(j['mediaUrl']),
        noteSw: _s(j['noteSw']),
        noteEn: _s(j['noteEn']),
        isLive: _b(j['isLive']),
        congregationId: _s(j['congregationId']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'titleSw': titleSw,
        'titleEn': titleEn,
        'preacherSw': preacherSw,
        'preacherEn': preacherEn,
        'mediaType': mediaType,
        'mediaUrl': mediaUrl,
        'noteSw': noteSw,
        'noteEn': noteEn,
        'isLive': isLive,
        'congregationId': congregationId,
      };
}

class RoleContact {
  RoleContact({
    required this.id,
    required this.roleSw,
    required this.roleEn,
    required this.nameSw,
    required this.nameEn,
    required this.phone,
    required this.email,
    required this.noteSw,
    required this.noteEn,
  });

  String id;
  String roleSw;
  String roleEn;
  String nameSw;
  String nameEn;
  String phone;
  String email;
  String noteSw;
  String noteEn;

  String role(bool sw) => sw ? roleSw : roleEn;
  String name(bool sw) => sw ? nameSw : nameEn;
  String note(bool sw) => sw ? noteSw : noteEn;

  factory RoleContact.fromJson(Map<String, dynamic> j) => RoleContact(
        id: _s(j['id']),
        roleSw: _s(j['roleSw']),
        roleEn: _s(j['roleEn']),
        nameSw: _s(j['nameSw']),
        nameEn: _s(j['nameEn']),
        phone: _s(j['phone']),
        email: _s(j['email']),
        noteSw: _s(j['noteSw']),
        noteEn: _s(j['noteEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'roleSw': roleSw,
        'roleEn': roleEn,
        'nameSw': nameSw,
        'nameEn': nameEn,
        'phone': phone,
        'email': email,
        'noteSw': noteSw,
        'noteEn': noteEn,
      };
}

class PastoralRequest {
  PastoralRequest({
    required this.id,
    required this.at,
    required this.name,
    required this.phone,
    required this.type,
    required this.message,
    required this.read,
  });

  String id;
  String at;
  String name;
  String phone;
  String type;
  String message;
  bool read;

  factory PastoralRequest.fromJson(Map<String, dynamic> j) => PastoralRequest(
        id: _s(j['id']),
        at: _s(j['at']),
        name: _s(j['name']),
        phone: _s(j['phone']),
        type: _s(j['type'], 'prayer'),
        message: _s(j['message']),
        read: _b(j['read']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'at': at,
        'name': name,
        'phone': phone,
        'type': type,
        'message': message,
        'read': read,
      };
}

class Hymn {
  Hymn({
    required this.id,
    required this.number,
    required this.titleSw,
    required this.titleEn,
    required this.firstLineSw,
    required this.source,
    required this.tags,
    required this.lyricsSw,
    required this.lyricsEn,
  });

  String id;
  String number;
  String titleSw;
  String titleEn;
  String firstLineSw;
  String source;
  List<String> tags;
  String lyricsSw;
  String lyricsEn;

  String title(bool sw) => sw ? titleSw : titleEn;
  String lyrics(bool sw) => sw ? lyricsSw : lyricsEn;

  factory Hymn.fromJson(Map<String, dynamic> j) => Hymn(
        id: _s(j['id']),
        number: _s(j['number']),
        titleSw: _s(j['titleSw']),
        titleEn: _s(j['titleEn']),
        firstLineSw: _s(j['firstLineSw']),
        source: _s(j['source']),
        tags: _ss(j['tags']),
        lyricsSw: _s(j['lyricsSw']),
        lyricsEn: _s(j['lyricsEn']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'titleSw': titleSw,
        'titleEn': titleEn,
        'firstLineSw': firstLineSw,
        'source': source,
        'tags': tags,
        'lyricsSw': lyricsSw,
        'lyricsEn': lyricsEn,
      };
}

class ChurchData {
  ChurchData({
    required this.version,
    required this.settings,
    required this.church,
    required this.congregations,
    required this.jumuiyas,
    required this.members,
    required this.homePins,
    required this.sundayTimes,
    required this.announcements,
    required this.services,
    required this.events,
    required this.giving,
    required this.givingNotes,
    required this.sermons,
    required this.contacts,
    required this.pastoralRequests,
    required this.hymns,
  });

  int version;
  ChurchSettings settings;
  ChurchInfo church;
  List<Congregation> congregations;
  List<Jumuiya> jumuiyas;
  List<MemberRecord> members;
  List<HomePin> homePins;
  List<SundaySlot> sundayTimes;
  List<Announcement> announcements;
  List<ServiceOrder> services;
  List<ChurchEvent> events;
  GivingConfig giving;
  List<GivingNote> givingNotes;
  List<Sermon> sermons;
  List<RoleContact> contacts;
  List<PastoralRequest> pastoralRequests;
  List<Hymn> hymns;

  factory ChurchData.fromJson(Map<String, dynamic> j) => ChurchData(
        version: _i(j['version'], 1),
        settings: ChurchSettings.fromJson(
            Map<String, dynamic>.from(j['settings'] as Map? ?? {})),
        church: ChurchInfo.fromJson(
            Map<String, dynamic>.from(j['church'] as Map? ?? {})),
        congregations: (j['congregations'] as List? ?? [])
            .map((e) =>
                Congregation.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        jumuiyas: (j['jumuiyas'] as List? ?? [])
            .map((e) => Jumuiya.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        members: (j['members'] as List? ?? [])
            .map((e) =>
                MemberRecord.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        homePins: (j['homePins'] as List? ?? [])
            .map((e) => HomePin.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        sundayTimes: (j['sundayTimes'] as List? ?? [])
            .map((e) =>
                SundaySlot.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        announcements: (j['announcements'] as List? ?? [])
            .map((e) =>
                Announcement.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        services: (j['services'] as List? ?? [])
            .map((e) =>
                ServiceOrder.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        events: (j['events'] as List? ?? [])
            .map((e) =>
                ChurchEvent.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        giving: GivingConfig.fromJson(
            Map<String, dynamic>.from(j['giving'] as Map? ?? {})),
        givingNotes: (j['givingNotes'] as List? ?? [])
            .map((e) =>
                GivingNote.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        sermons: (j['sermons'] as List? ?? [])
            .map((e) => Sermon.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        contacts: (j['contacts'] as List? ?? [])
            .map((e) =>
                RoleContact.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        pastoralRequests: (j['pastoralRequests'] as List? ?? [])
            .map((e) =>
                PastoralRequest.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        hymns: (j['hymns'] as List? ?? [])
            .map((e) => Hymn.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'settings': settings.toJson(),
        'church': church.toJson(),
        'congregations': congregations.map((e) => e.toJson()).toList(),
        'jumuiyas': jumuiyas.map((e) => e.toJson()).toList(),
        'members': members.map((e) => e.toJson()).toList(),
        'homePins': homePins.map((e) => e.toJson()).toList(),
        'sundayTimes': sundayTimes.map((e) => e.toJson()).toList(),
        'announcements': announcements.map((e) => e.toJson()).toList(),
        'services': services.map((e) => e.toJson()).toList(),
        'events': events.map((e) => e.toJson()).toList(),
        'giving': giving.toJson(),
        'givingNotes': givingNotes.map((e) => e.toJson()).toList(),
        'sermons': sermons.map((e) => e.toJson()).toList(),
        'contacts': contacts.map((e) => e.toJson()).toList(),
        'pastoralRequests': pastoralRequests.map((e) => e.toJson()).toList(),
        'hymns': hymns.map((e) => e.toJson()).toList(),
      };

  Congregation? congregationById(String id) {
    for (final c in congregations) {
      if (c.id == id) return c;
    }
    return null;
  }

  Jumuiya? jumuiyaById(String id) {
    for (final j in jumuiyas) {
      if (j.id == id) return j;
    }
    return null;
  }

  List<Announcement> get sortedAnnouncements {
    final list = [...announcements];
    list.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.date.compareTo(a.date);
    });
    return list;
  }

  ServiceOrder? latestService({DateTime? now}) {
    if (services.isEmpty) return null;
    final list = [...services]..sort((a, b) => b.date.compareTo(a.date));
    final today = (now ?? DateTime.now()).toIso8601String().substring(0, 10);
    for (final s in list.reversed) {
      if (s.date.compareTo(today) >= 0) return s;
    }
    return list.first;
  }

  Hymn? hymnById(String id) {
    for (final h in hymns) {
      if (h.id == id) return h;
    }
    return null;
  }
}

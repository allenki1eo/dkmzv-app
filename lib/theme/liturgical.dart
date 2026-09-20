import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import 'brand.dart';

/// Western / KKKT Lutheran vestment colours.
enum Vestment { purple, green, white, red }

/// Named moments of the church year (Western Lutheran / KKKT).
enum ChurchSeason {
  advent,
  christmas,
  epiphany,
  lent,
  palmSunday,
  holyWeek,
  goodFriday,
  easter,
  pentecost,
  trinity,
  reformation,
  allSaints,
  ordinary,
}

/// DKMZV cloth locked to the season. Gold is always the metal, never a vestment.
class SeasonPalette {
  const SeasonPalette({
    required this.vestment,
    required this.cloth,
    required this.clothDeep,
    required this.onCloth,
    required this.lightBar,
  });

  final Vestment vestment;
  final Color cloth;
  final Color clothDeep;
  final Color onCloth;
  final bool lightBar;

  Color get metal => DkmzvBrand.gold;
  Color get parchment => DkmzvBrand.cream;
  Color get sage => DkmzvBrand.sage;

  static const purple = SeasonPalette(
    vestment: Vestment.purple,
    cloth: DkmzvBrand.purple,
    clothDeep: DkmzvBrand.purpleDeep,
    onCloth: Color(0xFFFDF5E6),
    lightBar: false,
  );

  static const green = SeasonPalette(
    vestment: Vestment.green,
    cloth: Color(0xFF1E4D36),
    clothDeep: Color(0xFF123324),
    onCloth: Color(0xFFFDF5E6),
    lightBar: false,
  );

  static const white = SeasonPalette(
    vestment: Vestment.white,
    cloth: Color(0xFFF4E6C1),
    clothDeep: Color(0xFFE6D3A0),
    onCloth: DkmzvBrand.purple,
    lightBar: true,
  );

  static const red = SeasonPalette(
    vestment: Vestment.red,
    cloth: Color(0xFF8B1E2D),
    clothDeep: Color(0xFF5C101C),
    onCloth: Color(0xFFFDF5E6),
    lightBar: false,
  );

  factory SeasonPalette.of(Vestment v) {
    switch (v) {
      case Vestment.purple:
        return purple;
      case Vestment.green:
        return green;
      case Vestment.white:
        return white;
      case Vestment.red:
        return red;
    }
  }
}

class LiturgicalMoment {
  const LiturgicalMoment({
    required this.season,
    required this.vestment,
    required this.date,
  });

  final ChurchSeason season;
  final Vestment vestment;
  final DateTime date;

  SeasonPalette get palette => SeasonPalette.of(vestment);

  String name(S s) {
    switch (season) {
      case ChurchSeason.advent:
        return s.seasonAdvent;
      case ChurchSeason.christmas:
        return s.seasonChristmas;
      case ChurchSeason.epiphany:
        return s.seasonEpiphany;
      case ChurchSeason.lent:
        return s.seasonLent;
      case ChurchSeason.palmSunday:
        return s.seasonPalm;
      case ChurchSeason.holyWeek:
        return s.seasonHolyWeek;
      case ChurchSeason.goodFriday:
        return s.seasonGoodFriday;
      case ChurchSeason.easter:
        return s.seasonEaster;
      case ChurchSeason.pentecost:
        return s.seasonPentecost;
      case ChurchSeason.trinity:
        return s.seasonTrinity;
      case ChurchSeason.reformation:
        return s.seasonReformation;
      case ChurchSeason.allSaints:
        return s.seasonAllSaints;
      case ChurchSeason.ordinary:
        return s.seasonOrdinary;
    }
  }

  String meaning(S s) {
    switch (season) {
      case ChurchSeason.advent:
        return s.meaningAdvent;
      case ChurchSeason.christmas:
        return s.meaningChristmas;
      case ChurchSeason.epiphany:
        return s.meaningEpiphany;
      case ChurchSeason.lent:
        return s.meaningLent;
      case ChurchSeason.palmSunday:
        return s.meaningPalm;
      case ChurchSeason.holyWeek:
        return s.meaningHolyWeek;
      case ChurchSeason.goodFriday:
        return s.meaningGoodFriday;
      case ChurchSeason.easter:
        return s.meaningEaster;
      case ChurchSeason.pentecost:
        return s.meaningPentecost;
      case ChurchSeason.trinity:
        return s.meaningTrinity;
      case ChurchSeason.reformation:
        return s.meaningReformation;
      case ChurchSeason.allSaints:
        return s.meaningAllSaints;
      case ChurchSeason.ordinary:
        return s.meaningOrdinary;
    }
  }

  String clothName(S s) {
    switch (vestment) {
      case Vestment.purple:
        return s.colorPurple;
      case Vestment.green:
        return s.colorGreen;
      case Vestment.white:
        return s.colorWhiteGold;
      case Vestment.red:
        return s.colorRed;
    }
  }

  String clothWhy(S s) {
    switch (vestment) {
      case Vestment.purple:
        return s.whyPurple;
      case Vestment.green:
        return s.whyGreen;
      case Vestment.white:
        return s.whyWhite;
      case Vestment.red:
        return s.whyRed;
    }
  }
}

/// Computus + Western Lutheran (KKKT) church year.
class LiturgicalCalendar {
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Anonymous Gregorian (Meeus/Jones/Butcher) Easter Sunday.
  static DateTime easterSunday(int year) {
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }

  /// First Sunday of Advent: fourth Sunday before Christmas
  /// (falls 27 Nov–3 Dec).
  static DateTime adventSunday(int year) {
    final christmas = DateTime(year, 12, 25);
    var fourth = christmas;
    while (fourth.weekday != DateTime.sunday) {
      fourth = fourth.subtract(const Duration(days: 1));
    }
    if (christmas.weekday == DateTime.sunday) {
      fourth = fourth.subtract(const Duration(days: 7));
    }
    return fourth.subtract(const Duration(days: 21));
  }

  static DateTime ashWednesday(int year) =>
      easterSunday(year).subtract(const Duration(days: 46));

  static DateTime palmSunday(int year) =>
      easterSunday(year).subtract(const Duration(days: 7));

  static DateTime pentecost(int year) =>
      easterSunday(year).add(const Duration(days: 49));

  static DateTime trinitySunday(int year) =>
      easterSunday(year).add(const Duration(days: 56));

  /// Baptism of Our Lord: first Sunday after 6 January.
  static DateTime baptismOfOurLord(int year) {
    var d = DateTime(year, 1, 6).add(const Duration(days: 1));
    while (d.weekday != DateTime.sunday) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  static DateTime lastSundayOfOctober(int year) {
    var d = DateTime(year, 10, 31);
    while (d.weekday != DateTime.sunday) {
      d = d.subtract(const Duration(days: 1));
    }
    return d;
  }

  static LiturgicalMoment at(DateTime raw) {
    final date = dateOnly(raw);
    final y = date.year;
    final easter = easterSunday(y);
    final advent = adventSunday(y);
    final nextAdvent = adventSunday(y + 1);
    final ash = ashWednesday(y);
    final palm = palmSunday(y);
    final pent = pentecost(y);
    final trinity = trinitySunday(y);
    final baptism = baptismOfOurLord(y);
    final reformationSunday = lastSundayOfOctober(y);

    bool same(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    bool onOrAfter(DateTime a) => !date.isBefore(a);
    bool before(DateTime a) => date.isBefore(a);

    if (same(date, DateTime(y, 10, 31)) || same(date, reformationSunday)) {
      return LiturgicalMoment(
          season: ChurchSeason.reformation, vestment: Vestment.red, date: date);
    }
    if (same(date, DateTime(y, 11, 1))) {
      return LiturgicalMoment(
          season: ChurchSeason.allSaints, vestment: Vestment.white, date: date);
    }
    if (same(date, palm)) {
      return LiturgicalMoment(
          season: ChurchSeason.palmSunday, vestment: Vestment.red, date: date);
    }
    if (same(date, easter.subtract(const Duration(days: 2)))) {
      return LiturgicalMoment(
          season: ChurchSeason.goodFriday, vestment: Vestment.red, date: date);
    }
    if (onOrAfter(palm) && before(easter)) {
      return LiturgicalMoment(
          season: ChurchSeason.holyWeek, vestment: Vestment.purple, date: date);
    }
    if (same(date, pent)) {
      return LiturgicalMoment(
          season: ChurchSeason.pentecost, vestment: Vestment.red, date: date);
    }
    if (same(date, trinity)) {
      return LiturgicalMoment(
          season: ChurchSeason.trinity, vestment: Vestment.white, date: date);
    }
    if (onOrAfter(easter) && before(pent)) {
      return LiturgicalMoment(
          season: ChurchSeason.easter, vestment: Vestment.white, date: date);
    }
    if (onOrAfter(ash) && before(palm)) {
      return LiturgicalMoment(
          season: ChurchSeason.lent, vestment: Vestment.purple, date: date);
    }
    if (!date.isBefore(DateTime(y, 12, 25)) || date.isBefore(baptism.add(const Duration(days: 1)))) {
      if (date.month == 12 && date.day >= 25) {
        return LiturgicalMoment(
            season: ChurchSeason.christmas, vestment: Vestment.white, date: date);
      }
      if (date.month == 1 && !date.isAfter(baptism)) {
        return LiturgicalMoment(
            season: ChurchSeason.christmas, vestment: Vestment.white, date: date);
      }
    }
    if (onOrAfter(baptism.add(const Duration(days: 1))) && before(ash)) {
      return LiturgicalMoment(
          season: ChurchSeason.epiphany, vestment: Vestment.green, date: date);
    }
    if (onOrAfter(advent) && before(DateTime(y, 12, 25))) {
      return LiturgicalMoment(
          season: ChurchSeason.advent, vestment: Vestment.purple, date: date);
    }
    if (onOrAfter(trinity.add(const Duration(days: 1))) && before(nextAdvent)) {
      return LiturgicalMoment(
          season: ChurchSeason.ordinary, vestment: Vestment.green, date: date);
    }
    if (date.isBefore(advent) && onOrAfter(trinity)) {
      return LiturgicalMoment(
          season: ChurchSeason.ordinary, vestment: Vestment.green, date: date);
    }

    return LiturgicalMoment(
        season: ChurchSeason.ordinary, vestment: Vestment.green, date: date);
  }

  /// Preview a vestment family without changing the clock.
  static LiturgicalMoment preview(Vestment vestment, {DateTime? date}) {
    final season = switch (vestment) {
      Vestment.purple => ChurchSeason.lent,
      Vestment.green => ChurchSeason.ordinary,
      Vestment.white => ChurchSeason.easter,
      Vestment.red => ChurchSeason.pentecost,
    };
    return LiturgicalMoment(
      season: season,
      vestment: vestment,
      date: dateOnly(date ?? DateTime.now()),
    );
  }
}

SeasonPalette paletteForColorName(String name) {
  switch (name) {
    case 'purple':
      return SeasonPalette.purple;
    case 'gold':
    case 'white':
      return SeasonPalette.white;
    case 'red':
      return SeasonPalette.red;
    default:
      return SeasonPalette.green;
  }
}

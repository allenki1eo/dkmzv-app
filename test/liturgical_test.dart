import 'package:dkmzv_app/theme/liturgical.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Gregorian Easter Sundays', () {
    expect(LiturgicalCalendar.easterSunday(2024), DateTime(2024, 3, 31));
    expect(LiturgicalCalendar.easterSunday(2025), DateTime(2025, 4, 20));
    expect(LiturgicalCalendar.easterSunday(2026), DateTime(2026, 4, 5));
    expect(LiturgicalCalendar.easterSunday(2027), DateTime(2027, 3, 28));
  });

  test('Advent 2026 begins 29 November', () {
    expect(LiturgicalCalendar.adventSunday(2026), DateTime(2026, 11, 29));
  });

  test('Ash Wednesday 2026 is 18 February', () {
    expect(LiturgicalCalendar.ashWednesday(2026), DateTime(2026, 2, 18));
  });

  test('seasons lock the correct vestment', () {
    expect(
      LiturgicalCalendar.at(DateTime(2026, 9, 20)).vestment,
      Vestment.green,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 9, 20)).season,
      ChurchSeason.ordinary,
    );

    expect(
      LiturgicalCalendar.at(DateTime(2026, 12, 6)).vestment,
      Vestment.purple,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 12, 6)).season,
      ChurchSeason.advent,
    );

    expect(
      LiturgicalCalendar.at(DateTime(2026, 12, 25)).vestment,
      Vestment.white,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 12, 25)).season,
      ChurchSeason.christmas,
    );

    expect(
      LiturgicalCalendar.at(DateTime(2026, 2, 22)).vestment,
      Vestment.purple,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 2, 22)).season,
      ChurchSeason.lent,
    );

    expect(LiturgicalCalendar.at(DateTime(2026, 3, 29)).vestment, Vestment.red);
    expect(
      LiturgicalCalendar.at(DateTime(2026, 3, 29)).season,
      ChurchSeason.palmSunday,
    );

    expect(LiturgicalCalendar.at(DateTime(2026, 4, 3)).vestment, Vestment.red);
    expect(
      LiturgicalCalendar.at(DateTime(2026, 4, 3)).season,
      ChurchSeason.goodFriday,
    );

    expect(
      LiturgicalCalendar.at(DateTime(2026, 4, 5)).vestment,
      Vestment.white,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 4, 5)).season,
      ChurchSeason.easter,
    );

    expect(LiturgicalCalendar.at(DateTime(2026, 5, 24)).vestment, Vestment.red);
    expect(
      LiturgicalCalendar.at(DateTime(2026, 5, 24)).season,
      ChurchSeason.pentecost,
    );

    expect(
      LiturgicalCalendar.at(DateTime(2026, 10, 31)).vestment,
      Vestment.red,
    );
    expect(
      LiturgicalCalendar.at(DateTime(2026, 11, 1)).vestment,
      Vestment.white,
    );
  });
}

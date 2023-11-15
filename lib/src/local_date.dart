// Copyright (c) 2023 LLC "LitGroup"
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'dart:math' show max;

import 'package:local_date/local_date.dart';
import 'package:meta/meta.dart';

import 'format.dart';
import 'month.dart';
import 'year.dart';

//------------------------------------------------------------------------------
// Local date
//------------------------------------------------------------------------------

@immutable
final class LocalDate implements Comparable<LocalDate> {
  // Construction
  //----------------------------------------------------------------------------

  static LocalDate of(int year, [int month = 1, int day = 1]) =>
      tryOf(year, month, day) ??
      (throw ArgumentError('Invalid local date ($year-$month-$day).'));

  static LocalDate? tryOf(int year, [int month = 1, int day = 1]) {
    final yearValue = Year.tryFrom(year);
    if (yearValue == null) {
      return null;
    }

    final monthValue = Month.tryFrom(month);
    if (monthValue == null) {
      return null;
    }

    if (day < 1 || day > monthValue.daysInYear(yearValue)) {
      return null;
    }

    return LocalDate._internal(yearValue, monthValue, day);
  }

  /// Parses a date from the given value using the [parser] of the expected format.
  ///
  /// Throws [FormatException] on failure.
  static LocalDate parse<T>(T value, {required DateParser<T> parser}) {
    final DateComponents(:year, :month, :day) = parser.parseDate(value);
    final date = tryOf(year, month, day);

    if (date == null) {
      throw FormatException('Cannot parse date.', value);
    }

    return date;
  }

  static LocalDate fromDateTime(DateTime dateTime) =>
      of(dateTime.year, dateTime.month, dateTime.day);

  LocalDate._internal(this._year, this._month, this._day);

  final Year _year;
  final Month _month;
  final int _day;

  // Leap day determining
  //----------------------------------------------------------------------------

  bool get isLeapDay => _day > _month.days(leapYear: false);

  bool get isNotLeapDay => !isLeapDay;

  // Comparison
  //----------------------------------------------------------------------------

  /// Returns `true` if this date is after the [other].
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// Returns `true` if this date is before the [other].
  bool isBefore(LocalDate other) => compareTo(other) < 0;

  /// Returns `true` if this date is the same as [other].
  bool isOnSameDayAs(LocalDate other) =>
      _year.isSameAs(other._year) &&
      _month.isSameAs(other._month) &&
      _day == other._day;

  /// Returns `true` if this date is in the same month of the same year as [other].
  bool isInSameMonthAs(LocalDate other) =>
      _year.isSameAs(other._year) && _month.isSameAs(other._month);

  /// Returns `true` if this date is in the same year as the [other].
  bool isInSameYearAs(LocalDate other) => _year.isSameAs(other._year);

  @override
  int get hashCode => Object.hash(_year, _month, _day);

  @override
  bool operator ==(Object other) => other is LocalDate && isOnSameDayAs(other);

  @override
  int compareTo(LocalDate other) {
    final yearComparison = _year.compareTo(other._year);
    if (yearComparison != 0) {
      return yearComparison;
    }

    final monthComparison = _month.compareTo(other._month);
    if (monthComparison != 0) {
      return monthComparison;
    }

    return _day.compareTo(other._day);
  }

  // Formatting
  //----------------------------------------------------------------------------

  T formattedBy<T>(DateFormatter<T> formatter) =>
      formatter.formatDate(DateComponents(_year.toInt(), _month.toInt(), _day));

  // Conversion to a different type
  //----------------------------------------------------------------------------

  DateTime toDateTime({required bool utc}) {
    return utc
        ? DateTime.utc(_year.toInt(), _month.toInt(), _day)
        : DateTime(_year.toInt(), _month.toInt(), _day);
  }

  @override
  String toString() => formattedBy(ISO8601Format());
}

//------------------------------------------------------------------------------
// Date of birth
//------------------------------------------------------------------------------

@immutable
final class DateOfBirth extends LocalDate {
  static DateOfBirth of(int year, int month, int day) =>
      tryOf(year, month, day) ??
      (throw ArgumentError('Invalid date of birth ($year-$month-$day).'));

  static DateOfBirth? tryOf(int year, int month, int day) {
    final localDate = LocalDate.tryOf(year, month, day);
    if (localDate == null) {
      return null;
    }

    return DateOfBirth.from(localDate);
  }

  /// Parses a date from the given value using the [parser] of the expected format.
  ///
  /// Throws [FormatException] on failure.
  static DateOfBirth parse<T>(T value, {required DateParser<T> parser}) =>
      DateOfBirth.from(LocalDate.parse(value, parser: parser));

  DateOfBirth.from(LocalDate date)
      : super._internal(date._year, date._month, date._day);

  // Birthday determining
  //----------------------------------------------------------------------------

  /// Returns a date of birthday in the given [year].
  ///
  /// This method correctly handles a birthday on a leap day.
  /// E.g. we have a date of birth "2000-02-29" – where February 29s is a leap
  /// day – then:
  ///
  /// - birthday date in 2001 is February 28s, because 2001 is not a leap year;
  /// - birthday date in 2004 is February 29s, because 2004 is a leap year.
  ///
  /// Returns `null` if the given [year] is before the year of birth.
  LocalDate? birthdayInYear(Year year) {
    if (year.isBefore(_year)) {
      return null;
    }

    // Handle a lep date of birth:
    final int derivedDay = isLeapDay ? _month.daysInYear(year) : _day;

    return LocalDate.of(year.toInt(), _month.toInt(), derivedDay);
  }

  // Age calculation
  //----------------------------------------------------------------------------

  /// Returns the age calculated on the given [date].
  ///
  /// Age will be 0 if the given [date] is before the date of birth.
  int calculateAgeAsOnDate(LocalDate date) {
    // Calculate the nearest birthday date:
    final nearestBirthday = birthdayInYear(date._year);
    if (nearestBirthday == null) {
      // Target year is before the year of birth.
      return 0;
    }

    var age = nearestBirthday._year.toInt() - _year.toInt();
    if (nearestBirthday.isAfter(date)) {
      // The nearest birthday is after the target date,
      // we have to subtract one year from age.
      age = max(0, age - 1);
    }

    return age;
  }

  /// Returns the age calculated at the given [dateTime].
  ///
  /// Age will be 0 if the given date is before the date of birth.
  int calculateAgeAsAtDateTime(DateTime dateTime) =>
      calculateAgeAsOnDate(LocalDate.fromDateTime(dateTime));
}

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

import 'package:meta/meta.dart';

import 'month.dart';
import 'year.dart';

@immutable
final class LocalDate implements Comparable<LocalDate> {
  // Construction
  //----------------------------------------------------------------------------

  static LocalDate of(int year, [int month = 1, int day = 1]) =>
      tryOf(year, month, day) ??
      (throw ArgumentError(
          'Invalid local date components ($year, $month, $day).'));

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

  @Deprecated('Will be removed before release, use LocalDate.of() instead.')
  static LocalDate create(int year, [int month = 1, int day = 1]) =>
      of(year, month, day);

  @Deprecated('Will be removed before release, use LocalDate.tryOf() instead.')
  static LocalDate? tryCreate(int year, [int month = 1, int day = 1]) =>
      tryOf(year, month, day);

  static LocalDate fromDateTime(DateTime dateTime) =>
      of(dateTime.year, dateTime.month, dateTime.day);

  LocalDate._internal(this._year, this._month, this._day);

  final Year _year;
  final Month _month;
  final int _day;

  // Leap day determining
  //----------------------------------------------------------------------------

  bool get isLeapDay => _day > _month.days(leapYear: false);

  // Comparison
  //----------------------------------------------------------------------------

  @override
  int get hashCode => Object.hash(_year, _month, _day);

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other._year == _year &&
      other._month == _month &&
      other._day == _day;

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

  // Conversion to a different type
  //----------------------------------------------------------------------------

  DateTime toDateTime({required bool utc}) {
    return utc
        ? DateTime.utc(_year.toInt(), _month.toInt(), _day)
        : DateTime(_year.toInt(), _month.toInt(), _day);
  }

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write(_year.toString())
      ..write('-')
      ..write(_month.toInt().toString().padLeft(2, '0'))
      ..write('-')
      ..write(_day.toString().padLeft(2, '0'));

    return buffer.toString();
  }
}

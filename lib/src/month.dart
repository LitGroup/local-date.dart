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

import 'year.dart';

@immutable
final class Month implements Comparable<Month> {
  // Enumeration of values
  //----------------------------------------------------------------------------

  static const Month january = Month._internal(1, 'January');
  static const Month february = Month._internal(2, 'February');
  static const Month march = Month._internal(3, 'March');
  static const Month april = Month._internal(4, 'April');
  static const Month may = Month._internal(5, 'May');
  static const Month june = Month._internal(6, 'June');
  static const Month july = Month._internal(7, 'July');
  static const Month august = Month._internal(8, 'August');
  static const Month september = Month._internal(9, 'September');
  static const Month october = Month._internal(10, 'October');
  static const Month november = Month._internal(11, 'November');
  static const Month december = Month._internal(12, 'December');

  /// The list of month values.
  static const List<Month> values = [
    Month.january,
    Month.february,
    Month.march,
    Month.april,
    Month.may,
    Month.june,
    Month.july,
    Month.august,
    Month.september,
    Month.october,
    Month.november,
    Month.december,
  ];

  // Construction
  // ---------------------------------------------------------------------------

  /// Creates month from the number (from 1 to 12).
  ///
  /// Throws [ArgumentError] if the [number] if out of range.
  static Month from(int number) {
    return tryFrom(number) ??
        (throw ArgumentError('Invalid number of month ($number).'));
  }

  /// Creates month from the number (from 1 to 12);
  /// returns null if the number is invalid.
  static Month? tryFrom(int number) {
    if (number < 1 || number > 12) {
      return null;
    }

    return Month.values[number - 1];
  }

  const Month._internal(this._number, this._name);

  // Attributes
  //----------------------------------------------------------------------------

  /// The number of the month (from 1 to 12).
  final int _number;

  /// The name of the month (e.g. 'August').
  final String _name;

  /// Returns the number of days in the month.
  ///
  /// The [leapYear] parameter determines whether to return the length of the
  /// month in the leap or non-leap period.
  int days({required bool leapYear}) => switch (this) {
        Month.february => leapYear ? 29 : 28,
        Month.april || Month.june || Month.september || Month.november => 30,
        _ => 31
      };

  /// Returns the number of the month in the given year.
  int daysInYear(Year year) => days(leapYear: year.isLeap);

  // Comparison
  //----------------------------------------------------------------------------

  @override
  int get hashCode => _number;

  @override
  bool operator ==(Object other) => other is Month && other._number == _number;

  @override
  int compareTo(Month other) => _number.compareTo(other._number);

  // Conversion to a different type
  //----------------------------------------------------------------------------

  /// Returns the name of the month (e.g. "January").
  @override
  String toString() => _name;

  /// Returns the calendar number of the month.
  int toInt() => _number;
}

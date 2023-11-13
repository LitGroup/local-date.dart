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

/// A representation of the year in the Gregorian calendar in the range from 0 to 9999.
@immutable
final class Year implements Comparable<Year> {
  // Construction
  //----------------------------------------------------------------------------

  /// Creates self from `int`.
  ///
  /// Throws [ArgumentError] if the [value] is out of supported range.
  static Year from(int value) {
    final year = tryFrom(value);
    if (year == null) {
      throw ArgumentError.value(
          value, 'value', 'Year is supported in range 0..9999.');
    }

    return year;
  }

  /// Creates self from `int`; returns null if the [value] is out of supported range.
  static Year? tryFrom(int value) {
    if (value < 0 || value > 9999) {
      return null;
    }

    return Year._internal(value);
  }

  Year._internal(this._value);

  final int _value;

  // Leap year determining
  //----------------------------------------------------------------------------

  /// Returns true if the year is leap.
  bool get isLeap =>
      (_value % 4 == 0) && (_value % 100 != 0 || _value % 400 == 0);

  /// Returns true if the year is not leap.
  bool get isNotLeap => !isLeap;

  /// Returns number of days in the year.
  ///
  /// 365 for a regular year and 366 for a leap one.
  int get durationInDays => isLeap ? 366 : 365;

  // Comparison
  //----------------------------------------------------------------------------

  bool isAfter(Year other) => _value > other._value;

  bool isBefore(Year other) => _value < other._value;

  bool isSameAs(Year other) => _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) => other is Year && isSameAs(other);

  @override
  int compareTo(Year other) => _value.compareTo(other._value);

  // Conversion to a different type
  //----------------------------------------------------------------------------

  /// Returns string representation of the year.
  ///
  /// Resulting string always containing 4 digits, used left padding by '0'.
  ///
  /// ```dart
  /// assert(Year.from(23).toString() == '0023');
  /// assert(Year.from(2023).toString() == '2023');
  /// ```
  @override
  String toString() => _value.toString().padLeft(4, '0');

  /// Returns integer representation of the year.
  int toInt() => _value;
}

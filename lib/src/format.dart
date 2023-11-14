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

//------------------------------------------------------------------------------
// Date formatting
//------------------------------------------------------------------------------

/// The interface of date components formatter.
abstract interface class DateFormatter<T> {
  /// Formats the specified date components according to a specific representation.
  T formatDate(DateComponents components);
}

//------------------------------------------------------------------------------
// Date parsing
//------------------------------------------------------------------------------

/// The interface of date components parser.
abstract interface class DateParser<T> {
  /// Parses date components from the given [value].
  ///
  /// Throws [FormatException] for invalid input value.
  DateComponents parseDate(T value);
}

//------------------------------------------------------------------------------
// Date components
//------------------------------------------------------------------------------

/// Contains components of a local date together.
///
/// Keep in mind, that [DateComponents] class does not check the date value.
/// It is a DTO for exchanging between date value types and date
/// formatting/parsing implementations.
@immutable
final class DateComponents {
  DateComponents(this.year, this.month, this.day);

  /// The number of the year.
  final int year;

  /// The number of the month.
  final int month;

  /// The number of the day.
  final int day;

  @override
  bool operator ==(Object other) =>
      other is DateComponents &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

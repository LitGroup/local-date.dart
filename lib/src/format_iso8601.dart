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

import 'format.dart';

class ISO8601Format implements DateFormatter<String>, DateParser<String> {
  static final RegExp _pattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  static const ISO8601Format _instance = ISO8601Format._internal();

  factory ISO8601Format() => _instance;

  const ISO8601Format._internal();

  @override
  String formatDate(DateComponents components) {
    final DateComponents(:year, :month, :day) = components;
    final buffer = StringBuffer()
      ..write(year.toString().padLeft(4, '0'))
      ..write('-')
      ..write(month.toString().padLeft(2, '0'))
      ..write('-')
      ..write(day.toString().padLeft(2, '0'));

    return buffer.toString();
  }

  @override
  DateComponents parseDate(String value) {
    final match = ISO8601Format._pattern.firstMatch(value) ??
        (throw FormatException('Invalid ISO8601 date representation.', value));

    final [year, month, day] = match
        .groups([1, 2, 3])
        .map((part) => int.parse(part!, radix: 10))
        .toList(growable: false);

    return DateComponents(year, month, day);
  }
}

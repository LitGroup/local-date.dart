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

import 'package:test/test.dart';

import 'package:local_date/local_date.dart';

void main() {
  group('ISO8601Format', () {
    final format = ISO8601Format();

    test('formatting', () {
      expect(format.formatDate(DateComponents(1, 1, 1)), equals('0001-01-01'));
      expect(format.formatDate(DateComponents(2023, 11, 15)),
          equals('2023-11-15'));
    });

    group('parsing', () {
      test('succeeds', () {
        expect(format.parseDate('0001-02-03'), equals(DateComponents(1, 2, 3)));
        expect(format.parseDate('0009-02-03'), equals(DateComponents(9, 2, 3)));
        expect(format.parseDate('2023-11-15'),
            equals(DateComponents(2023, 11, 15)));
      });

      test('fails for invalid string', () {
        expect(() => format.parseDate(''), throwsFormatException);
        expect(() => format.parseDate('---'), throwsFormatException);
        expect(() => format.parseDate('2023'), throwsFormatException);
        expect(() => format.parseDate('2023-11'), throwsFormatException);
        expect(() => format.parseDate('2023-11-15-10'), throwsFormatException);
        expect(() => format.parseDate('2023--11-15'), throwsFormatException);
        expect(() => format.parseDate('2023-11--15'), throwsFormatException);

        expect(() => format.parseDate('23-11-15'), throwsFormatException);
        expect(() => format.parseDate('00023-11-15'), throwsFormatException);
        expect(() => format.parseDate('2023-1-15'), throwsFormatException);
        expect(() => format.parseDate('2023-111-15'), throwsFormatException);
        expect(() => format.parseDate('2023-111-5'), throwsFormatException);
        expect(() => format.parseDate('2023-111-555'), throwsFormatException);

        expect(() => format.parseDate('ABCD-11-15'), throwsFormatException);
        expect(() => format.parseDate('2023-EF-15'), throwsFormatException);
        expect(() => format.parseDate('2023-11-GH'), throwsFormatException);
        expect(() => format.parseDate('0x23-11-15'), throwsFormatException);
      });
    });
  });
}

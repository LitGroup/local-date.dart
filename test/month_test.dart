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
  group('Month', () {
    group('construction from number', () {
      test('succeeds', () {
        expect(Month.from(1), Month.january);
        expect(Month.from(2), Month.february);
        expect(Month.from(3), Month.march);
        expect(Month.from(4), Month.april);
        expect(Month.from(5), Month.may);
        expect(Month.from(6), Month.june);
        expect(Month.from(7), Month.july);
        expect(Month.from(8), Month.august);
        expect(Month.from(9), Month.september);
        expect(Month.from(10), Month.october);
        expect(Month.from(11), Month.november);
        expect(Month.from(12), Month.december);
      });

      test('throws error for invalid number', () {
        expect(() => Month.from(0), throwsArgumentError);
        expect(() => Month.from(13), throwsArgumentError);
      });
    });

    group('failable construction from number', () {
      test('succeeds', () {
        expect(Month.tryFrom(1), Month.january);
        expect(Month.tryFrom(2), Month.february);
        expect(Month.tryFrom(3), Month.march);
        expect(Month.tryFrom(4), Month.april);
        expect(Month.tryFrom(5), Month.may);
        expect(Month.tryFrom(6), Month.june);
        expect(Month.tryFrom(7), Month.july);
        expect(Month.tryFrom(8), Month.august);
        expect(Month.tryFrom(9), Month.september);
        expect(Month.tryFrom(10), Month.october);
        expect(Month.tryFrom(11), Month.november);
        expect(Month.tryFrom(12), Month.december);
      });

      test('results to null for invalid number', () {
        expect(Month.tryFrom(0), isNull);
        expect(Month.tryFrom(13), isNull);
      });
    });

    group('enumeration & attributes:', () {
      const monthAttributes = [
        (Month.january, number: 1, name: 'January'),
        (Month.february, number: 2, name: 'February'),
        (Month.march, number: 3, name: 'March'),
        (Month.april, number: 4, name: 'April'),
        (Month.may, number: 5, name: 'May'),
        (Month.june, number: 6, name: 'June'),
        (Month.july, number: 7, name: 'July'),
        (Month.august, number: 8, name: 'August'),
        (Month.september, number: 9, name: 'September'),
        (Month.october, number: 10, name: 'October'),
        (Month.november, number: 11, name: 'November'),
        (Month.december, number: 12, name: 'December'),
      ];

      // Test number and name for each of months:
      for (final (month, :number, :name) in monthAttributes) {
        test('$name', () {
          expect(month.number, equals(number));
          expect(month.name, equals(name));
        });
      }
    });

    test('list of values', () {
      expect(Month.values, [
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
      ]);
    });

    test('equality & hash code', () {
      expect(Month.august, equals(Month.august));
      expect(Month.august, equals(Month.from(8)));
      expect(Month.august, equals(Month.tryFrom(8)!));

      expect(Month.august.hashCode, equals(Month.from(8).hashCode),
          reason: 'Hash code of equal values must be equal too.');

      expect(Month.august, isNot(Month.july));
      expect(Month.august, isNot(Month.september));
    });

    test('comparison to another month', () {
      expect(Month.august.compareTo(Month.august), isZero);
      expect(Month.august.compareTo(Month.september), isNegative);
      expect(Month.august.compareTo(Month.july), isPositive);
    });

    test('conversion to string', () {
      expect(Month.january.toString(), equals(Month.january.name));
      expect(Month.march.toString(), equals(Month.march.name));
      expect(Month.december.toString(), equals(Month.december.name));
    });
  });
}

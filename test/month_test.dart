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
  // Construction
  //----------------------------------------------------------------------------

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

    // Enumerated values
    //--------------------------------------------------------------------------

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

    // Number of days determining
    //--------------------------------------------------------------------------

    group('number of days determining', () {
      const testExamples = <(Month, int daysInNonLeapYear, int daysInLeapYear)>[
        (Month.january, 31, 31),
        (Month.february, 28, 29),
        (Month.march, 31, 31),
        (Month.april, 30, 30),
        (Month.may, 31, 31),
        (Month.june, 30, 30),
        (Month.july, 31, 31),
        (Month.august, 31, 31),
        (Month.september, 30, 30),
        (Month.october, 31, 31),
        (Month.november, 30, 30),
        (Month.december, 31, 31),
      ];

      final nonLeapYear = Year.from(2001);
      final leapYear = Year.from(2000);

      for (final (month, nonLeapLength, leapLength) in testExamples) {
        test('in $month using leap/non-leap year sign', () {
          expect(month.days(leapYear: false), equals(nonLeapLength));
          expect(month.days(leapYear: true), equals(leapLength));
        });

        test('in $month for the specified year', () {
          expect(month.daysInYear(nonLeapYear), equals(nonLeapLength));
          expect(month.daysInYear(leapYear), equals(leapLength));
        });
      }
    });

    // Comparison
    //--------------------------------------------------------------------------

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

    // Conversion to a different type
    //--------------------------------------------------------------------------

    test('conversion to string', () {
      expect(Month.january.toString(), 'January');
      expect(Month.february.toString(), 'February');
      expect(Month.march.toString(), 'March');
      expect(Month.april.toString(), 'April');
      expect(Month.may.toString(), 'May');
      expect(Month.june.toString(), 'June');
      expect(Month.july.toString(), 'July');
      expect(Month.august.toString(), 'August');
      expect(Month.september.toString(), 'September');
      expect(Month.october.toString(), 'October');
      expect(Month.november.toString(), 'November');
      expect(Month.december.toString(), 'December');
    });

    test('conversion to int', () {
      expect(Month.january.toInt(), 1);
      expect(Month.february.toInt(), 2);
      expect(Month.march.toInt(), 3);
      expect(Month.april.toInt(), 4);
      expect(Month.may.toInt(), 5);
      expect(Month.june.toInt(), 6);
      expect(Month.july.toInt(), 7);
      expect(Month.august.toInt(), 8);
      expect(Month.september.toInt(), 9);
      expect(Month.october.toInt(), 10);
      expect(Month.november.toInt(), 11);
      expect(Month.december.toInt(), 12);
    });
  });
}

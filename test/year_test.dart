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
  group('Year', () {
    // Construction
    //--------------------------------------------------------------------------
    group('construction from int', () {
      test('succeeds', () {
        expect(() => Year.from(0), returnsNormally,
            reason: 'Min supported value is 0.');
        expect(() => Year.from(9999), returnsNormally,
            reason: 'Max supported value is 9999');
      });

      test('fails if value is out of the supported range', () {
        expect(() => Year.from(0 - 1), throwsArgumentError,
            reason: 'Min supported value is 0.');
        expect(() => Year.from(9999 + 1), throwsArgumentError,
            reason: 'Max supported value is 9999.');
      });
    });

    group('failable creation from int', () {
      test('succeeds', () {
        expect(Year.tryFrom(0), equals(Year.from(0)));
        expect(Year.tryFrom(9999), equals(Year.from(9999)));
      });

      test('results to null if value is out of the supported range', () {
        expect(Year.tryFrom(0 - 1), isNull);
        expect(Year.tryFrom(9999 + 1), isNull);
      });
    });

    // Comparison
    //--------------------------------------------------------------------------
    test('equality & hashing', () {
      final year = Year.from(2000);
      final sameYear = Year.from(2000);

      final yearBefore = Year.from(2000 - 1);
      final yearAfter = Year.from(2000 + 1);

      expect(year, equals(sameYear));
      expect(year.hashCode, equals(sameYear.hashCode),
          reason: 'Hash codes of equal years must be equal.');

      expect(year, isNot(equals(yearBefore)));
      expect(year, isNot(equals(yearAfter)));
    });

    // Conversion to a different type
    //--------------------------------------------------------------------------

    test('conversion to string', () {
      var year = Year.from(0);
      expect(year.toString(), equals('0000'));

      year = Year.from(23);
      expect(year.toString(), equals('0023'));

      year = Year.from(2023);
      expect(year.toString(), equals('2023'));
    });

    test('conversion to int', () {
      final year = Year.from(2023);
      expect(year.toInt(), equals(2023));
    });
  });
}

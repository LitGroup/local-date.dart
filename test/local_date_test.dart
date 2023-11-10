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
  group('LocalDate', () {
    // Construction tests
    //--------------------------------------------------------------------------

    test('failable creation from int values of year, month, day', () {
      expect(LocalDate.tryCreate(0), isNotNull);
      expect(LocalDate.tryCreate(0 - 1), isNull,
          reason: 'The minimum supported value of year is 0.');

      expect(LocalDate.tryCreate(9999), isNotNull);
      expect(LocalDate.tryCreate(9999 + 1), isNull,
          reason: 'The maximum supported value of year is 9999.');

      expect(LocalDate.tryCreate(1999, 1), isNotNull);
      expect(LocalDate.tryCreate(1999, 1 - 1), isNull,
          reason: 'The minimum possible month is 1.');

      expect(LocalDate.tryCreate(1999, 12), isNotNull);
      expect(LocalDate.tryCreate(1999, 12 + 1), isNull,
          reason: 'The maximum possible month is 12.');

      expect(LocalDate.tryCreate(1999, 1, 1), isNotNull);
      expect(LocalDate.tryCreate(1999, 1, 1 - 1), isNull,
          reason: 'The minimum possible day number is 1.');

      expect(LocalDate.tryCreate(1999, 1, 31), isNotNull);
      expect(LocalDate.tryCreate(1999, 1, 31 + 1), isNull,
          reason: 'There is not January 32 in the calendar.');

      expect(LocalDate.tryCreate(1999, 2, 28), isNotNull);
      expect(LocalDate.tryCreate(1999, 2, 29), isNull,
          reason: 'February has 28 days length in a non-leap year.');

      expect(LocalDate.tryCreate(2000, 2, 29), isNotNull,
          reason: 'February has 29 days length in a leap year.');
      expect(LocalDate.tryCreate(2000, 2, 30), isNull,
          reason: 'There is not February 30 in the calendar.');

      expect(LocalDate.tryCreate(2000, 6, 30), isNotNull);
      expect(LocalDate.tryCreate(2000, 6, 31), isNull,
          reason: 'June has 30 days length.');
    });

    test('creation from int values of year, month, day', () {
      expect(() => LocalDate.create(1999, 12, 31), returnsNormally);
      expect(() => LocalDate.create(1999, 2, 28), returnsNormally);
      expect(() => LocalDate.create(2000, 2, 29), returnsNormally);

      expect(() => LocalDate.create(0 - 1), throwsArgumentError,
          reason: 'The minimum supported value of year is 0.');
      expect(() => LocalDate.create(9999 + 1), throwsArgumentError,
          reason: 'The maximum supported value of year is 9999.');
      expect(() => LocalDate.create(1999, 1 - 1), throwsArgumentError,
          reason: 'The minimum possible month is 1.');
      expect(() => LocalDate.create(1999, 12 + 1), throwsArgumentError,
          reason: 'The maximum possible month is 12.');
      expect(() => LocalDate.create(1999, 1, 1 - 1), throwsArgumentError,
          reason: 'The minimum possible day number is 1.');
      expect(() => LocalDate.create(1999, 1, 31 + 1), throwsArgumentError,
          reason: 'There is not January 32 in the calendar.');
      expect(() => LocalDate.create(1999, 2, 29), throwsArgumentError,
          reason: 'February has 28 days length in a non-leap year.');
      expect(() => LocalDate.create(2000, 2, 30), throwsArgumentError,
          reason: 'There is not February 30 in the calendar.');
      expect(() => LocalDate.create(2000, 6, 31), throwsArgumentError,
          reason: 'June has 30 days length.');
    });

    test('creation from DateTime', () {
      var dateTime = DateTime(2023, 11, 10);
      var localDate = LocalDate.fromDateTime(dateTime);
      expect(localDate, equals(LocalDate.create(2023, 11, 10)));

      dateTime = DateTime.utc(2023, 11, 10);
      localDate = LocalDate.fromDateTime(dateTime);
      expect(localDate, equals(LocalDate.create(2023, 11, 10)));
    });

    // Comparison tests
    //--------------------------------------------------------------------------

    test('equality & hash code', () {
      final reference = LocalDate.create(2000, 10, 15);
      expect(reference == reference, isTrue);

      final sameAsReference = LocalDate.create(2000, 10, 15);
      expect(reference, equals(sameAsReference));
      expect(reference.hashCode, equals(sameAsReference.hashCode),
          reason: 'Equal dates must have the same hash code.');

      expect(reference, isNot(LocalDate.create(2000, 10, 15 + 1)));
      expect(reference, isNot(LocalDate.create(2000, 10, 15 - 1)));
      expect(reference, isNot(LocalDate.create(2000, 10 + 1, 15)));
      expect(reference, isNot(LocalDate.create(2000, 10 - 1, 15)));
      expect(reference, isNot(LocalDate.create(2000 + 1, 10, 15)));
      expect(reference, isNot(LocalDate.create(2000 - 1, 10, 15)));
    });

    test('comparison with another local date', () {
      final reference = LocalDate.create(2000, 10, 20);

      expect(reference.compareTo(LocalDate.create(2000, 10, 20)), isZero);

      expect(reference.compareTo(LocalDate.create(2001, 1, 1)), isNegative);
      expect(reference.compareTo(LocalDate.create(1999, 12, 31)), isPositive);

      expect(reference.compareTo(LocalDate.create(2000, 11, 1)), isNegative);
      expect(reference.compareTo(LocalDate.create(2000, 9, 30)), isPositive);

      expect(reference.compareTo(LocalDate.create(2000, 10, 21)), isNegative);
      expect(reference.compareTo(LocalDate.create(2000, 10, 19)), isPositive);
    });

    // Conversion to a different type
    //--------------------------------------------------------------------------

    test('conversion to string', () {
      var date = LocalDate.create(1, 2, 3);
      expect(date.toString(), equals('0001-02-03'));

      date = LocalDate.create(2023, 12, 31);
      expect(date.toString(), equals('2023-12-31'));
    });

    test('conversion to DateTime', () {
      final localDate = LocalDate.create(2023, 11, 10);

      var dateTime = localDate.toDateTime(utc: false);
      expect(dateTime, equals(DateTime(2023, 11, 10)));
      expect(dateTime.isUtc, isFalse);

      dateTime = localDate.toDateTime(utc: true);
      expect(dateTime, equals(DateTime.utc(2023, 11, 10)));
      expect(dateTime.isUtc, isTrue);
    });
  });
}

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

import 'fixtures/date_test_data_set.dart';
import 'fixtures/test_date_format.dart';

void main() {
  group('LocalDate', () {
    // Construction tests
    //--------------------------------------------------------------------------

    group('failable creation from int values', () {
      for (final (index, example) in validDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('succeeds #$index', () {
          expect(LocalDate.tryOf(year, month, day), isNotNull, reason: reason);
        });
      }

      for (final (index, example) in invalidDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('returns null for invalida date #$index', () {
          expect(LocalDate.tryOf(year, month, day), isNull, reason: reason);
        });
      }
    });

    group('creation from int values', () {
      for (final (index, example) in validDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('succeeds #$index', () {
          expect(() => LocalDate.of(year, month, day), returnsNormally,
              reason: reason);
        });
      }

      for (final (index, example) in invalidDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('throws error for invalid date #$index', () {
          expect(() => LocalDate.of(year, month, day), throwsArgumentError,
              reason: reason);
        });
      }
    });

    group('creation from DateTime', () {
      test('succeeds', () {
        var dateTime = DateTime(2023, 11, 10);
        var localDate = LocalDate.fromDateTime(dateTime);
        expect(localDate, equals(LocalDate.of(2023, 11, 10)));

        dateTime = DateTime.utc(2023, 11, 10);
        localDate = LocalDate.fromDateTime(dateTime);
        expect(localDate, equals(LocalDate.of(2023, 11, 10)));
      });

      test('fails if the date is outside of the supported range', () {
        var dateTime = DateTime(0 - 1, 1, 1);
        expect(() => LocalDate.fromDateTime(dateTime), throwsArgumentError);

        dateTime = DateTime.utc(9999 + 1, 1, 1);
        expect(() => LocalDate.fromDateTime(dateTime), throwsArgumentError);
      });
    });

    // Parsing
    //--------------------------------------------------------------------------

    group('parsing', () {
      test('succeeds', () {
        final parsedDate =
            LocalDate.parse((2000, 10, 20), parser: TestDateFormat());

        expect(parsedDate, equals(LocalDate.of(2000, 10, 20)));
      });

      test('throws an exception if parser throws', () {
        expect(
            () => LocalDate.parse('invalid date format',
                parser: AlwaysThrowingDateParser<String>()),
            throwsFormatException);
      });

      test('throws an exception if parser returns invalid date components', () {
        expect(() => LocalDate.parse((-1, 1, 1), parser: TestDateFormat()),
            throwsFormatException);
        expect(() => LocalDate.parse((1, 0, 1), parser: TestDateFormat()),
            throwsFormatException);
        expect(() => LocalDate.parse((1, 1, 0), parser: TestDateFormat()),
            throwsFormatException);
      });
    });

    // Leap day determining
    //--------------------------------------------------------------------------
    test('leap day determining', () {
      expect(LocalDate.of(2000, 2, 29).isLeapDay, isTrue);
      expect(LocalDate.of(2000, 2, 29).isNotLeapDay, isFalse);

      expect(LocalDate.of(2000, 2, 28).isLeapDay, isFalse);
      expect(LocalDate.of(2000, 2, 28).isNotLeapDay, isTrue);

      expect(LocalDate.of(2000, 1, 29).isLeapDay, isFalse);
      expect(LocalDate.of(2000, 1, 29).isNotLeapDay, isTrue);
    });

    // Comparison tests
    //--------------------------------------------------------------------------

    test('equality & hash code', () {
      final reference = LocalDate.of(2000, 10, 15);
      expect(reference == reference, isTrue);

      final sameAsReference = LocalDate.of(2000, 10, 15);
      expect(reference, equals(sameAsReference));
      expect(reference.hashCode, equals(sameAsReference.hashCode),
          reason: 'Equal dates must have the same hash code.');

      expect(reference, isNot(LocalDate.of(2000, 10, 15 + 1)));
      expect(reference, isNot(LocalDate.of(2000, 10, 15 - 1)));
      expect(reference, isNot(LocalDate.of(2000, 10 + 1, 15)));
      expect(reference, isNot(LocalDate.of(2000, 10 - 1, 15)));
      expect(reference, isNot(LocalDate.of(2000 + 1, 10, 15)));
      expect(reference, isNot(LocalDate.of(2000 - 1, 10, 15)));
    });

    test('comparison with another local date', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.compareTo(LocalDate.of(2000, 10, 20)), isZero);

      expect(reference.compareTo(LocalDate.of(2001, 1, 1)), isNegative);
      expect(reference.compareTo(LocalDate.of(1999, 12, 31)), isPositive);

      expect(reference.compareTo(LocalDate.of(2000, 11, 1)), isNegative);
      expect(reference.compareTo(LocalDate.of(2000, 9, 30)), isPositive);

      expect(reference.compareTo(LocalDate.of(2000, 10, 21)), isNegative);
      expect(reference.compareTo(LocalDate.of(2000, 10, 19)), isPositive);
    });

    test('is after another one', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.isAfter(LocalDate.of(2000, 10, 19)), isTrue);
      expect(reference.isAfter(LocalDate.of(2000, 10, 20)), isFalse);
      expect(reference.isAfter(LocalDate.of(2000, 10, 21)), isFalse);

      expect(reference.isAfter(LocalDate.of(2000, 9, 30)), isTrue);
      expect(reference.isAfter(LocalDate.of(2000, 11, 1)), isFalse);

      expect(reference.isAfter(LocalDate.of(1999, 12, 31)), isTrue);
      expect(reference.isAfter(LocalDate.of(2001, 1, 1)), isFalse);
    });

    test('is before another one', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.isBefore(LocalDate.of(2000, 10, 21)), isTrue);
      expect(reference.isBefore(LocalDate.of(2000, 10, 20)), isFalse);
      expect(reference.isBefore(LocalDate.of(2000, 10, 19)), isFalse);

      expect(reference.isBefore(LocalDate.of(2000, 11, 1)), isTrue);
      expect(reference.isBefore(LocalDate.of(2000, 9, 30)), isFalse);

      expect(reference.isBefore(LocalDate.of(2001, 1, 1)), isTrue);
      expect(reference.isBefore(LocalDate.of(1999, 12, 31)), isFalse);
    });

    test('is the same day as another', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.isOnSameDayAs(LocalDate.of(2000, 10, 20)), isTrue);

      expect(reference.isOnSameDayAs(LocalDate.of(2000, 10, 19)), isFalse);
      expect(reference.isOnSameDayAs(LocalDate.of(2000, 10, 21)), isFalse);

      expect(reference.isOnSameDayAs(LocalDate.of(2000, 9, 20)), isFalse);
      expect(reference.isOnSameDayAs(LocalDate.of(2000, 11, 20)), isFalse);

      expect(reference.isOnSameDayAs(LocalDate.of(1999, 10, 20)), isFalse);
      expect(reference.isOnSameDayAs(LocalDate.of(2001, 10, 20)), isFalse);
    });

    test('is in the same year and month as another', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.isInSameMonthAs(LocalDate.of(2000, 10, 20)), isTrue);
      expect(reference.isInSameMonthAs(LocalDate.of(2000, 10, 1)), isTrue);

      expect(reference.isInSameMonthAs(LocalDate.of(2000, 11, 20)), isFalse,
          reason: 'Different month.');
      expect(reference.isInSameMonthAs(LocalDate.of(2000, 9, 20)), isFalse,
          reason: 'Different month.');
      expect(reference.isInSameMonthAs(LocalDate.of(1999, 10, 20)), isFalse,
          reason: 'Different year.');
      expect(reference.isInSameMonthAs(LocalDate.of(2001, 10, 20)), isFalse,
          reason: 'Different year.');
    });

    test('is in the same year as another', () {
      final reference = LocalDate.of(2000, 10, 20);

      expect(reference.isInSameYearAs(LocalDate.of(2000, 10, 20)), isTrue);
      expect(reference.isInSameYearAs(LocalDate.of(2000, 1, 1)), isTrue);

      expect(reference.isInSameYearAs(LocalDate.of(1999, 10, 20)), isFalse);
      expect(reference.isInSameYearAs(LocalDate.of(2001, 10, 20)), isFalse);
    });

    // Formatting
    //--------------------------------------------------------------------------

    test('formatting', () {
      final date = LocalDate.of(2000, 10, 20);

      final formattedDate = date.formattedBy(TestDateFormat());
      expect(formattedDate, equals((2000, 10, 20)));
    });

    // Conversion to a different type
    //--------------------------------------------------------------------------

    test('conversion to string', () {
      var date = LocalDate.of(1, 2, 3);
      expect(date.toString(), equals('0001-02-03'));

      date = LocalDate.of(2023, 12, 31);
      expect(date.toString(), equals('2023-12-31'));
    });

    test('conversion to DateTime', () {
      final localDate = LocalDate.of(2023, 11, 10);

      var dateTime = localDate.toDateTime(utc: false);
      expect(dateTime, equals(DateTime(2023, 11, 10)));
      expect(dateTime.isUtc, isFalse);

      dateTime = localDate.toDateTime(utc: true);
      expect(dateTime, equals(DateTime.utc(2023, 11, 10)));
      expect(dateTime.isUtc, isTrue);
    });
  });
}

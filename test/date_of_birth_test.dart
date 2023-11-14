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
  group('DateOfBirth', () {
    // Creation tests
    //--------------------------------------------------------------------------

    group('creation from int date components', () {
      for (final (index, example) in validDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('succeeds #$index', () {
          expect(DateOfBirth.of(year, month, day),
              equals(LocalDate.of(year, month, day)),
              reason: reason);
        });
      }

      for (final (index, example) in invalidDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('throws error for invalid date #$index', () {
          expect(() => DateOfBirth.of(year, month, day), throwsArgumentError,
              reason: reason);
        });
      }
    });

    group('failable creation from int date components', () {
      for (final (index, example) in validDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('succeeds #$index', () {
          expect(DateOfBirth.tryOf(year, month, day),
              equals(LocalDate.of(year, month, day)),
              reason: reason);
        });
      }

      for (final (index, example) in invalidDateExamples.indexed) {
        final ((year, month, day), reason) = example;
        test('returns null for invalid date #$index', () {
          expect(DateOfBirth.tryOf(year, month, day), isNull, reason: reason);
        });
      }
    });

    // Parsing
    //--------------------------------------------------------------------------

    group('parsing', () {
      test('succeeds', () {
        final parsedDate =
            DateOfBirth.parse((2000, 10, 20), parser: TestDateFormat());

        expect(parsedDate, equals(DateOfBirth.of(2000, 10, 20)));
      });

      test('throws an exception if parser throws', () {
        expect(
            () => DateOfBirth.parse('invalid date format',
                parser: AlwaysThrowingDateParser<String>()),
            throwsFormatException);
      });

      test('throws an exception if parser returns invalid date components', () {
        expect(() => DateOfBirth.parse((-1, 1, 1), parser: TestDateFormat()),
            throwsFormatException);
        expect(() => DateOfBirth.parse((1, 0, 1), parser: TestDateFormat()),
            throwsFormatException);
        expect(() => DateOfBirth.parse((1, 1, 0), parser: TestDateFormat()),
            throwsFormatException);
      });
    });

    // Birthday determining
    //--------------------------------------------------------------------------

    test('birthday determining in the specified year', () {
      var dateOfBirth = DateOfBirth.of(1999, 1, 15);
      expect(dateOfBirth.birthdayInYear(Year.from(1999)), equals(dateOfBirth));
      expect(dateOfBirth.birthdayInYear(Year.from(2000)),
          equals(LocalDate.of(2000, 1, 15)));
      expect(dateOfBirth.birthdayInYear(Year.from(1998)), isNull,
          reason: 'Year before the year of birth.');

      dateOfBirth = DateOfBirth.of(2000, 2, 28);
      expect(dateOfBirth.birthdayInYear(Year.from(2001)),
          equals(LocalDate.of(2001, 2, 28)));

      // When date of birth is on leap day:
      dateOfBirth = DateOfBirth.of(2000, 2, 29);
      expect(dateOfBirth.birthdayInYear(Year.from(2000)), equals(dateOfBirth));
      expect(dateOfBirth.birthdayInYear(Year.from(2001)),
          equals(LocalDate.of(2001, 2, 28)));
      expect(dateOfBirth.birthdayInYear(Year.from(2002)),
          equals(LocalDate.of(2002, 2, 28)));
      expect(dateOfBirth.birthdayInYear(Year.from(2003)),
          equals(LocalDate.of(2003, 2, 28)));
      expect(dateOfBirth.birthdayInYear(Year.from(2004)),
          equals(LocalDate.of(2004, 2, 29)));
    });

    // Age calculation tests
    //--------------------------------------------------------------------------

    group('age calculation', () {
      test('on the specified local date', () {
        final birthDate = DateOfBirth.of(2000, 10, 20);

        // The age is 0 for dates before of equal to the date of birth:
        expect(birthDate.calculateAgeAsOnDate(birthDate), 0);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2000, 10, 19)), 0);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2000, 9, 30)), 0);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(1999, 12, 31)), 0);

        // The age is still 0 until the end of the one-year period:
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2001, 10, 19)), 0);

        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2001, 10, 20)), 1);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2010, 9, 20)), 9);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2010, 10, 19)), 9);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2010, 10, 20)), 10);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2010, 10, 21)), 10);
        expect(birthDate.calculateAgeAsOnDate(LocalDate.of(2010, 11, 11)), 10);

        // Test age calculation when the date of birth is leap:
        final leapBirthDate = DateOfBirth.of(2000, 2, 29);

        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2001, 2, 27)), 0);
        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2001, 2, 28)), 1);

        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2002, 2, 28)), 2);

        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2003, 2, 28)), 3);

        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2004, 2, 28)), 3);
        expect(
            leapBirthDate.calculateAgeAsOnDate(LocalDate.of(2004, 2, 29)), 4);
      });

      test('at the specified date & time', () {
        var dateOfBirth = DateOfBirth.of(2000, 10, 20);
        expect(dateOfBirth.calculateAgeAsAtDateTime(DateTime.utc(2010, 10, 20)),
            equals(10));
      });
    });
  });
}

This package provides a library for representing local dates that are
independent of the time zone.

A date of birth represented as a special case of local date with ability
to determine the age.

## Features

* Representation of local date (see `LocalDate` API):
  * Creation from `DateTime`;
  * Conversion to `DateTime`;
  * Generic API for implementation of different formatting;
  * Generic API for implementation of different format parsing;
  * Support of formatting/parsing of ISO8601 representation of date;
  * Comparison of local dates.
* Representation of a date of birth as a special case of local date (see `DateOfBirth` API):
  * Calculation of the age on the given date with handling of leap date of birth;
  * Determination of a birthday date in the specified year with handling of leap date of birth.

## Getting started

1. Install the package as a dependency:

    ```shell
    dart pub add local_date
    ```

2. Make the import:

    ```dart
    import 'package:local_date/local_date.dart';
    ```

## Usage

### Parsing / formatting

Parse ISO 8601 string representation:

```dart
final date = LocalDate.parse('2023-11-15', parser: ISO8610Format());
```

Format as ISO 8601 string:

```dart
final date = LocalDate.of(2023, 11, 15);

assert(date.formattedBy(ISO8601Format()) == '2023-11-15');
```

Feel free to implement `DateFormatter` and `DateParser` generic interfaces
for custom representations.

### Working with dates of birth

Interpretation of the date of birth is not so straightforward as most of
us used to think about.

One of the most widespread mistake is a wrong interpretation of leap dates
of birth. If a person has date of birth on February 29th, the birthday in
a non-leap year must be February 28th, not March 1st.

Fortunately, this library encapsulates correct logic inside `DateOfBirth`.

Let's see the example:

```dart
final leapDateOfBirth = DateOfBirth.of(2000, 2, 29);

// Age will be incremented on since February 28 in a non-leap lear:
assert(leapDateOfBirth.calculateAgeAsOnDate(LocalDate.of(2003, 2, 28)) == 3);

// Age will be incremented on since February 29 in a leap lear:
assert(leapDateOfBirth.calculateAgeAsOnDate(LocalDate.of(2004, 2, 28)) == 3);
assert(leapDateOfBirth.calculateAgeAsOnDate(LocalDate.of(2004, 2, 29)) == 3);
assert(leapDateOfBirth.calculateAgeAsOnDate(LocalDate.of(2004, 12, 31)) == 3);
```

## Additional information

### Limitations

This implementation works with the Gregorian calendar only and limits set
of years to the range from 0 to 9999. This range covers the most of
the enterprise related issues.

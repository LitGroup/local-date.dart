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

typedef DateExample = ((int year, int month, int day), String reason);

const List<DateExample> validDateExamples = [
  ((0, 1, 1), 'The minimum supported date is 0000-01-01.'),
  ((9999, 12, 31), 'The maximum supported date is 9999-12-31.'),
  ((2000, 1, 31), 'January is 31 days long.'),
  ((2000, 2, 29), 'February is 29 days long in a leap year.'),
  ((1999, 2, 28), 'February is 28 days long in anon-leap year.'),
  ((2000, 6, 30), 'June is 30 days long.'),
];

const List<DateExample> invalidDateExamples = [
  ((0 - 1, 1, 1), 'The minimum supported date is 0000-01-01.'),
  ((9999 + 1, 1, 1), 'The maximum supported date is 9999-12-31.'),
  ((2000, 1 - 1, 1), 'The number of month cannot be less than 1.'),
  ((2000, 12 + 1, 1), 'The number of month cannot be greater than 12.'),
  ((2000, 1, 1 - 1), 'The number of month cannot be greater than 12.'),
  ((2000, 1, 1 - 1), 'The number of day cannot be less than 1.'),
  ((2000, 1, 31 + 1), 'January is 31 days long.'),
  ((2000, 2, 29 + 1), 'February is 29 days long in a leap year.'),
  ((1999, 2, 28 + 1), 'February is 28 days long in anon-leap year.'),
  ((2000, 6, 30 + 1), 'June is 30 days long.'),
];

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

import 'package:local_date/local_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateComponents', () {
    test('equality & hash code', () {
      final components = DateComponents(2000, 10, 20);

      expect(components, equals(DateComponents(2000, 10, 20)));
      expect(components.hashCode, equals(DateComponents(2000, 10, 20).hashCode),
          reason: 'Equal values must have equal hash codes.');

      expect(components, isNot(DateComponents(2000, 10, 20 + 1)));
      expect(components, isNot(DateComponents(2000, 10 + 1, 20)));
      expect(components, isNot(DateComponents(2000 + 1, 10, 20)));
    });
  });
}

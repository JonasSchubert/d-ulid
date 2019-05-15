/**
 * MIT License
 *
 * Copyright (c) 2019 GuepardoApps (Jonas Schubert)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import "package:flutter_test/flutter_test.dart";
import "package:ulid/ulid.dart";

void main() {
  test("conversion methods should work as expected with provided time (only testing static time fields)", () {
    // Arrange
    final Ulid ulid = new Ulid(milliseconds: 1557942647);

    // Act & Assert
    expect(ulid.toCanonical().substring(0, 10), "0001edrmbq");
    expect(ulid.toMilliseconds(), 1557942647);
    expect(ulid.toString().substring(0, 14), "00005cdc-5177-");
    expect(ulid.toUuid().substring(0, 14), "00005cdc-5177-");
    expect(ulid.toUuid(compact: false).substring(0, 14), "00005cdc-5177-");
    expect(ulid.toUuid(compact: true).substring(0, 12), "00005cdc5177");
  });

  test("fromString providing hex16 string should work as expected", () {
    // Arrange
    final Ulid ulid = new Ulid.fromString("00005cdc-5177-0beb-c121-800c33c35260");

    // Act & Assert
    expect(ulid.toCanonical(), "0001edrmbq1fnw28c01gsw6mk0");
    expect(ulid.toMilliseconds(), 1557942647);
    expect(ulid.toString(), "00005cdc-5177-0beb-c121-800c33c35260");
    expect(ulid.toUuid(), "00005cdc-5177-0beb-c121-800c33c35260");
    expect(ulid.toUuid(compact: false), "00005cdc-5177-0beb-c121-800c33c35260");
    expect(ulid.toUuid(compact: true), "00005cdc51770bebc121800c33c35260");
  });

  test("fromString providing base32 string should work as expected", () {
    // Arrange
    final Ulid ulid = new Ulid.fromString("0001edrmbqp4mswhbwjqar4hm0");

    // Act & Assert
    expect(ulid.toCanonical(), "0001edrmbqp4mswhbwjqar4hm0");
    expect(ulid.toMilliseconds(), 1557942647);
    expect(ulid.toString(), "00005cdc-5177-b129-9e45-7c95d5824680");
    expect(ulid.toUuid(), "00005cdc-5177-b129-9e45-7c95d5824680");
    expect(ulid.toUuid(compact: false), "00005cdc-5177-b129-9e45-7c95d5824680");
    expect(ulid.toUuid(compact: true), "00005cdc5177b1299e457c95d5824680");
  });

  test("length should be as expected using DateTime.Now by not providing any data in the factory", () {
    // Arrange
    final Ulid ulid = new Ulid();

    // Act & Assert
    expect(ulid.toCanonical(), hasLength(26));
    expect(ulid.toString(), hasLength(36));
    expect(ulid.toUuid(), hasLength(36));
    expect(ulid.toUuid(compact: false), hasLength(36));
    expect(ulid.toUuid(compact: true), hasLength(32));
  });

  test("isValid should return true for valid string", () {
    // Arrange
    final String testValue0 = "00005cdc51770bebc121800c33c35260";
    final String testValue1 = "00005cdc-5177-0beb-c121-800c33c35260";
    final String testValue2 = "0001edrmbqp4mswhbwjqar4hm0";

    // Act & Assert
    expect(Ulid.isValid(testValue0), true);
    expect(Ulid.isValid(testValue1), true);
    expect(Ulid.isValid(testValue2), true);
  });

  test("isValid should return false for invalid string", () {
    // Arrange
    final String testValue0 = "";
    final String testValue1 = "00005cdc51770bebc121800c33c3526";
    final String testValue2 = "00005cdc-5177-0beb-c121-800c33c3526";
    final String testValue3 = "0001edrmbqp4mswhbwjqar4hm";

    // Act & Assert
    expect(Ulid.isValid(testValue0), false);
    expect(Ulid.isValid(testValue1), false);
    expect(Ulid.isValid(testValue2), false);
    expect(Ulid.isValid(testValue3), false);
  });
}

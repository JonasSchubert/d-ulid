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

library ulid;

import "dart:math";
import "dart:typed_data";

class Ulid {
  final Uint8List _value;

  /// Constructor for class ulid
  Ulid._(this._value) { assert(_value.length == _requiredValueLength); }

  /// Factory creating an ULID 
  /// - 1st using provided milliseconds 
  /// - 2nd using current datetime in epoch time if nothing provided
  factory Ulid({int milliseconds}) {
    final Uint8List data = new Uint8List(_requiredValueLength);

    int timestamp = milliseconds ?? new DateTime.now().millisecondsSinceEpoch;
    for (int index = _timestampEndIndex; index >= 0; index--) {
      data[index] = timestamp & 0xFF;
      timestamp = timestamp >> 8;
    }

    final Random random = new Random.secure();
    for (int index = _timestampEndIndex + 1; index < _requiredValueLength; index++) {
      data[index] = random.nextInt(256);
    }

    return new Ulid._(data);
  }

  /// Factory creating an ULID 
  /// - parsing from a string
  /// - 1st checking if it is a base 32 string
  /// - 2nd checking if it is a hex 16 string
  /// - otherwise throwing an ArgumentError "Invalid format"
  factory Ulid.fromString(String value) {
    switch (value.length) {
      case _base32StringLength:
        return new Ulid._parseBase32(value);

      default:
        {
          final String valueWithoutSlashes = value.replaceAll(_dash, _empty);
          if (valueWithoutSlashes.length == _hex16StringLength) {
            return new Ulid._parseHex16(valueWithoutSlashes);
          }
        }
    }

    throw new ArgumentError("Invalid format: $value");
  }

  /// Returns a bool indicating if the string is a valid ULID
  static bool isValid(String value) {
    try {
      new Ulid.fromString(value);
      return true;
    } catch(error){
      return false;
    }
  }

  /// Parsing ULID to a canonical string
  String toCanonical() {
    final Uint8List result = new Uint8List(_base32StringLength);

    _encode(0, _timestampEndIndex, 0, 9, result);
    _encode(_timestampEndIndex + 1, 10, 10, 17, result);
    _encode(11, 15, 18, 25, result);

    final StringBuffer stringBuffer = new StringBuffer();
    for (int index = 0; index < _base32StringLength; index++) {
      stringBuffer.write(_base32List[result[index]]);
    }

    return stringBuffer.toString();
  }

  /// Parsing ULID to the milliseconds
  int toMilliseconds() {
    int milliseconds = 0;

    for (int index = 0; index <= _timestampEndIndex; index++) {
      milliseconds = (milliseconds << 8) + _value[index];
    }

    return milliseconds;
  }

  /// Classic toString()-method returning the ULID as a canonical string
  @override
  String toString() => toUuid();

  /// Parsing ULID to a string in the UUID format
  String toUuid({bool compact = false}) {
    final StringBuffer stringBuffer = new StringBuffer();

    for (int index = 0; index < _requiredValueLength; index++) {
      if (!compact && (index == 4 || index == 6 || index == 8 || index == 10)) {
        stringBuffer.write(_dash);
      }

      stringBuffer.write(_hexList[_value[index] >> 4]);
      stringBuffer.write(_hexList[_value[index] & 0x0F]);
    }

    return stringBuffer.toString();
  }

  /// Decoding the value
  static void _decode(int inStartIndex, int inEndIndex, int outStartIndex, int outEndIndex, Uint8List buffer, Uint8List data) {
    int value = 0;

    for (int index = inStartIndex; index <= inEndIndex; index++) {
      value = (value << 5) + buffer[index];
    }

    for (int index = outEndIndex; index >= outStartIndex; index--) {
      data[index] = value & 0xFF;
      value = value >> 8;
    }
  }

  /// Encoding the value
  void _encode(int inStartIndex, int inEndIndex, int outStartIndex, int outEndIndex, Uint8List buffer) {
    int value = 0;

    for (int index = inStartIndex; index <= inEndIndex; index++) {
      value = (value << 8) + _value[index];
    }

    for (int index = outEndIndex; index >= outStartIndex; index--) {
      buffer[index] = value & 0x1F;
      value = value >> 5;
    }
  }

  /// Parsing a provided base 32 string to an ULID
  factory Ulid._parseBase32(String value) {
    final Uint8List buffer = new Uint8List(_base32StringLength);
    for (int index = 0; index < _base32StringLength; index++) {
      buffer[index] = _base32Decode[value.toLowerCase().codeUnitAt(index)];
    }

    final Uint8List data = new Uint8List(_requiredValueLength);
    _decode(0, 9, 0, _timestampEndIndex, buffer, data);
    _decode(10, 17, _timestampEndIndex + 1, 10, buffer, data);
    _decode(18, 25, 11, 15, buffer, data);

    return new Ulid._(data);
  }

  /// Parsing a provided hex 16 string to an ULID
  factory Ulid._parseHex16(String value) {
    final Uint8List data = new Uint8List(_requiredValueLength);

    for (int index = 0; index < _requiredValueLength; index++) {
      data[index] = int.parse(value.substring(index * 2, index * 2 + 2), radix: 16);
    }

    return new Ulid._(data);
  }
}

const int _requiredValueLength = 16;
const int _timestampEndIndex = 5;

const String _dash = "-";
const String  _empty = "";

const int _hex16StringLength = 32;
String _hex16Template = "0123456789abcdef";
List<String> _hexList = new List<String>.generate(_requiredValueLength, (int index) => _hex16Template[index]);

const int _base32StringLength = 26;
String _base32Template = "0123456789abcdefghjkmnpqrstvwxyz";
List<String> _base32List = new List<String>.generate(_hex16StringLength, (int index) => _base32Template[index]);
List<int> _lowercaseCodes = new List<int>.generate(_hex16StringLength, (int index) => _base32Template[index].codeUnits.first);
List<int> _base32Decode = new List<int>.generate(256, (int index) => _lowercaseCodes.indexOf(index));

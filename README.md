<h1 align="center">
	<br>
	<br>
	<img width="360" src="logo.png" alt="ulid">
	<br>
	<br>
	<br>
</h1>

# Dart Ulid

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/GuepardoApps/d-ulid/releases/tag/0.1.0)
[![Build](https://img.shields.io/badge/build-success-green.svg)](lib)
[![CodeCoverage](https://img.shields.io/badge/codeCoverage-100-green.svg)](test)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Paypal](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.me/GuepardoApps)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

ULID (Universally Unique Lexicographically Sortable Identifier) generator and parser for Dart.

Refer the [ULID spec](https://github.com/ulid/spec) for a more detailed ULID specification.

## Installation

TBD

## Usage

ULID generation examples:

```dart
import "package:ulid/ulid.dart";

final Ulid randomUlid = new Ulid();
final Ulid definedUlid = new Ulid(milliseconds: 1557942647);
final Ulid fromStringUlid = new Ulid.fromString("015c8e52-e8c9-8070-3709-877e5de58402");
```

ULID parsing examples:

```dart
import "package:ulid/ulid.dart";

val ulidString = ""

val isValid = Ulid.isValid(ulidString);
val milliseconds = new Ulid.fromString(ulidString)toMilliseconds();
```

## Prior Projects

- [agilord/ulid](https://github.com/agilord/ulid)

## License

d-ulid is distributed under the MIT license. [See LICENSE](LICENSE.md) for details.

```
MIT License

Copyright (c) 2019 GuepardoApps (Jonas Schubert)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
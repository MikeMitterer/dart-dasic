// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dasic.test;

import "dart:async";

import 'package:test/test.dart';
import 'package:dasic/dasic.dart';

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

part "src/Utils_test.dart";

// Run the tests: pub run test test/unit/test.dart
main() {
    final Logger _logger = new Logger("dasic.test.main");
    configLogging();

    testUtils();
}

void configLogging() {
    hierarchicalLoggingEnabled = true;

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler(messageFormat: "%n: (%t) %m"));
}

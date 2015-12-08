/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:test/test.dart';

import 'package:dasic/dasic.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

main() {
    //final Logger _logger = new Logger("test.Utils");
    configLogging();

    group('Utils', () {
        setUp(() { });
        
        test('> isLetterOrDigit', () {
            expect(Utils.isLetterOrDigit("a"),isTrue);
            expect(Utils.isLetterOrDigit("Z"),isTrue);
            expect(Utils.isLetterOrDigit("1"),isTrue);
            expect(Utils.isLetterOrDigit("9"),isTrue);

            expect(Utils.isLetterOrDigit("."),isFalse);
            expect(Utils.isLetterOrDigit("#"),isFalse);
            expect(Utils.isLetterOrDigit("-"),isFalse);

            bool foundError = false;
            try {
                Utils.isLetterOrDigit("");

            } on ArgumentError {
                foundError = true;
            }
            expect(foundError,isTrue);

        }); // end of 'isLetterOrDigit' test


        test('> isDigit', () {
            expect(Utils.isDigit("1"),isTrue);
            expect(Utils.isDigit("9"),isTrue);

            expect(Utils.isDigit("."),isFalse);
            expect(Utils.isDigit("a"),isFalse);

            bool foundError = false;
            try {
                Utils.isDigit(null);

            } on ArgumentError {
                foundError = true;
            }
            expect(foundError,isTrue);
        }); // end of 'isDigit' test

        test('> isLetter', () {
            expect(Utils.isLetter("a"),isTrue);
            expect(Utils.isLetter("Z"),isTrue);

            expect(Utils.isLetter("1"),isFalse);
            expect(Utils.isLetter("9"),isFalse);
            expect(Utils.isLetter("."),isFalse);
            expect(Utils.isLetter("#"),isFalse);
            expect(Utils.isLetter("-"),isFalse);
        }); // end of 'isLetter' test


    });
    // end 'Utils' group
}

void configLogging() {
    hierarchicalLoggingEnabled = true;

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler(messageFormat: "%n: (%t) %m"));
}
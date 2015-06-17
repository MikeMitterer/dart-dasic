/**
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

part of dasic.cmdline;

/// Commandline options
class Options {
    static const APPNAME                    = 'dasic';

    static const _ARG_HELP                  = 'help';
    static const _ARG_LOGLEVEL              = 'loglevel';
    static const _ARG_SETTINGS              = 'settings';

    final ArgParser _parser;

    Options() : _parser = Options._createParser();

    ArgResults parse(final List<String> args) {
        Validate.notNull(args);
        return _parser.parse(args);
    }

    void showUsage() {
        print("Usage: $APPNAME [options]");
        _parser.usage.split("\n").forEach((final String line) {
            print("    $line");
        });

        //        print("");
        //        print("Sample:");
        //        print("");
        //        print("    'Generates the static site in your 'web-folder':       '$APPNAME -g'");
        //        print("");
    }

    // -- private -------------------------------------------------------------

    static ArgParser _createParser() {
        final ArgParser parser = new ArgParser()

            ..addFlag(_ARG_SETTINGS,         abbr: 's', negatable: false, help: "Prints settings")

            ..addFlag(_ARG_HELP,             abbr: 'h', negatable: false, help: "Shows this message")

            ..addOption(_ARG_LOGLEVEL,       abbr: 'v', help: "Sets the appropriate loglevel", allowed: ['info', 'debug', 'warning'])

        ;

        return parser;
    }
}

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

/**
 * Port of JASIC to Dart
 * WebSite:
 *      https://github.com/munificent/jasic
 *      http://goo.gl/m1FOD6
 *
 * Expression parser:
 *      http://epaperpress.com/oper/prac2.html
 *      http://www.technical-recipes.com/2011/a-mathematical-expression-parser-in-java-and-cpp/
 */
class Application {
    final Logger _logger = new Logger("dasic.cmdline.Application");

    /// Commandline options
    final Options options;

    Application() : options = new Options();

    void run(List<String> args) {

        try {
            final ArgResults argResults = options.parse(args);
            final Config config = new Config(argResults);

            _configLogging(config.loglevel);

            if (argResults.wasParsed(Options._ARG_HELP) || (config.filestoscan.length == 0 && args.length == 0)) {
                options.showUsage();
                return;
            }

            if (argResults.wasParsed(Options._ARG_SETTINGS)) {
                config.printSettings();
                return;
            }

            bool foundOptionToWorkWith = false;
            if(config.filestoscan.length > 0) {
                foundOptionToWorkWith = true;

                config.filestoscan.forEach((final String filename) {
                    if(FileSystemEntity.isFileSync(filename)) {

                        final File file = new File(filename);
                        _interpretFile(file);

                    } else {
                        _logger.shout("$filename is not a valid file...");
                    }
                });
            }

            if (!foundOptionToWorkWith && config.filestoscan.length == 0) {
                options.showUsage();
            }
        }

        on FormatException
        catch (error) {
            _logger.shout(error);
            options.showUsage();
        }
    }

    // -- private -------------------------------------------------------------

    void _interpretFile(final File file) {
        Validate.notNull(file);
        Validate.isTrue(file.existsSync());

        _logger.fine("File: ${file.path}");

        final String content = file.readAsStringSync();
        final Interpreter interpreter = new Interpreter();
        interpreter.interpret(content);
    }

    void _configLogging(final String loglevel) {
        Validate.notBlank(loglevel);

        hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

        // now control the logging.
        // Turn off all logging first
        switch (loglevel) {
            case "fine":
            case "debug":
                Logger.root.level = Level.FINE;
                break;

            case "warning":
                Logger.root.level = Level.SEVERE;
                break;

            default:
                Logger.root.level = Level.INFO;
        }

        Logger.root.onRecord.listen(new LogPrintHandler(transformer: transformerMessageOnly));
    }
}

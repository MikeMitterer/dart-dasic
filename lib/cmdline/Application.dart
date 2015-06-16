part of dasic.cmdline;

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

        _logger.info("File: ${file.path}");

        final String content = file.readAsStringSync();
        final Lexer lexer = new Lexer();

        final List<Token> tokens = lexer.lex(content);
        tokens.forEach((final Token token) {
            switch(token.type) {
                case TokenType.LINE:
                    _logger.info("${token.type.toString().padRight(18)} -> <nl>");
                    break;

                default:
                    _logger.info("${token.type.toString().padRight(18)} -> Text: ${token.text}");
                    break;
            }
        });
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

        Logger.root.onRecord.listen(new LogPrintHandler(messageFormat: "%m"));
    }
}

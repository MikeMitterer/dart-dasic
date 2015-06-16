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

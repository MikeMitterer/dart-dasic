part of dasic;

class Utils {
    static bool isLetterOrDigit(final String char) {
        Validate.notNull(char);
        Validate.isTrue(char.isNotEmpty && char.length == 1);

        final RegExp regexp = new RegExp(r"^[0-9,a-z]$",caseSensitive: false);
        return regexp.hasMatch(char);
    }

    static bool isLetter(final String char) {
        Validate.notNull(char);
        Validate.isTrue(char.isNotEmpty && char.length == 1);

        final RegExp regexp = new RegExp(r"^[a-z]$",caseSensitive: false);
        return regexp.hasMatch(char);
    }

    static bool isDigit(final String char) {
        Validate.notNull(char);
        Validate.isTrue(char.isNotEmpty && char.length == 1);

        final RegExp regexp = new RegExp(r"^[0-9]$");
        return regexp.hasMatch(char);
    }
}
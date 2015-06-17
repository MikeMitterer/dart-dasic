part of dasic;

class Lexer {
    /**
     * This function takes a script as a string of characters and chunks it into
     * a sequence of tokens. Each token is a meaningful unit of program, like a
     * variable name, a number, a string, or an operator.
     */
    List<Token> scan(final String source) {
        final List<Token> tokens = new List<Token>();

        // Many tokens are a single character, like operators and ().
        final String charTokens = "\n=+-*/<>()";

        final List<TokenType> tokenTypes = [ TokenType.LINE, TokenType.EQUALS,
            TokenType.OPERATOR, TokenType.OPERATOR, TokenType.OPERATOR,
            TokenType.OPERATOR, TokenType.OPERATOR, TokenType.OPERATOR,
            TokenType.LEFT_PAREN, TokenType.RIGHT_PAREN
        ];

        String token = "";
        TokenizeState state = TokenizeState.DEFAULT;

        // Scan through the code one character at a time, building up the list of tokens.
        for (int i = 0; i < source.length; i++) {
            String c = new String.fromCharCode(source.codeUnitAt(i));
            switch (state) {
                case TokenizeState.DEFAULT:
                    if (charTokens.indexOf(c) != -1) {
                        tokens.add(new Token(c, tokenTypes[charTokens.indexOf(c)]));
                    }
                    else if (Utils.isLetter(c)) {
                        token += c;
                        state = TokenizeState.WORD;
                    }
                    else if (Utils.isDigit(c)) {
                        token += c;
                        state = TokenizeState.NUMBER;
                    }
                    else if (c == '"') {
                        state = TokenizeState.STRING;
                    }
                    else if (c == '\'') {
                        state = TokenizeState.COMMENT;
                    }
                    break;

                case TokenizeState.WORD:
                    if (Utils.isLetterOrDigit(c)) {
                        token += c;
                    }
                    else if (c == ':') {
                        tokens.add(new Token(token, TokenType.LABEL));
                        token = "";
                        state = TokenizeState.DEFAULT;
                    }
                    else {
                        tokens.add(new Token(token, TokenType.WORD));
                        token = "";
                        state = TokenizeState.DEFAULT;
                        i--;
                        // Reprocess this character in the default state.
                    }
                    break;

                case TokenizeState.NUMBER:
                    // HACK: Negative numbers and floating points aren't supported.
                    // To get a negative number, just do 0 - <your number>.
                    // To get a floating point, divide.
                    if (Utils.isDigit(c)) {
                        token += c;
                    }
                    else {
                        tokens.add(new Token(token, TokenType.NUMBER));
                        token = "";
                        state = TokenizeState.DEFAULT;
                        i--;
                        // Reprocess this character in the default state.
                    }
                    break;

                case TokenizeState.STRING:
                    if (c == '"') {
                        tokens.add(new Token(token, TokenType.STRING));
                        token = "";
                        state = TokenizeState.DEFAULT;
                    }
                    else {
                        token += c;
                    }
                    break;

                case TokenizeState.COMMENT:
                    if (c == '\n') {
                        state = TokenizeState.DEFAULT;
                    }
                    break;
            }
        }

        // HACK: Silently ignore any in-progress token when we run out of
        // characters. This means that, for example, if a script has a string
        // that's missing the closing ", it will just ditch it.
        return tokens;
    }

}
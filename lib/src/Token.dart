part of dasic;

/**
 * This defines the different kinds of tokens or meaningful chunks of code
 * that the parser knows how to consume. These let us distinguish, for
 * example, between a string "foo" and a variable named "foo".
 *
 * HACK: A typical tokenizer would actually have unique token types for
 * each keyword (print, goto, etc.) so that the parser doesn't have to look
 * at the names, but Jasic is a little more crude.
 */
enum TokenType {
    WORD, NUMBER, STRING, LABEL, LINE,
    EQUALS, OPERATOR, LEFT_PAREN, RIGHT_PAREN, EOF
}

/**
 * This is a single meaningful chunk of code. It is created by the tokenizer
 * and consumed by the parser.
 */
class Token {

    final String text;
    final TokenType type;

    Token(this.text, this.type);
}

/**
 * This defines the different states the tokenizer can be in while it's
 * scanning through the source code. Tokenizers are state machines, which
 * means the only data they need to store is where they are in the source
 * code and this one "state" or mode value.
 *
 * One of the main differences between tokenizing and parsing is this
 * regularity. Because the tokenizer stores only this one state value, it
 * can't handle nesting (which would require also storing a number to
 * identify how deeply nested you are). The parser is able to handle that.
 */
enum TokenizeState {
    DEFAULT, WORD, NUMBER, STRING, COMMENT
}
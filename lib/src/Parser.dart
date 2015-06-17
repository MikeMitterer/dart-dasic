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

part of dasic;

/**
 * This defines the Jasic parser. The parser takes in a sequence of tokens
 * and generates an abstract syntax tree. This is the nested data structure
 * that represents the series of statements, and the expressions (which can
 * nest arbitrarily deeply) that they evaluate. In technical terms, what we
 * have is a recursive descent parser, the simplest kind to hand-write.
 *
 * As a side-effect, this phase also stores off the line numbers for each
 * label in the program. It's a bit gross, but it works.
 */
class Parser {
    final Map<String, int> _labels = new Map<String,int>();
    final Map<String, Value> _variables = new Map<String, Value>();
    final List<Token> _tokens = new List<Token>();

    int position = 0;

    /**
     * The top-level function to start parsing. This will keep consuming
     * tokens and routing to the other parse functions for the different
     * grammar syntax until we run out of code to parse.
     *
     * @param  labels   A map of label names to statement indexes. The
     *                  parser will fill this in as it scans the code.
     * @return          The list of parsed statements.
     */
    List<Statement> parse(final List<Token> tokens) {
        final List<Statement> statements = new List<Statement>();

        this._tokens.clear();
        this._tokens.addAll(tokens);

        while (true) {
            // Ignore empty lines.
            while (matchToken(TokenType.LINE));

            if (matchToken(TokenType.LABEL)) {
                // Mark the index of the statement after the label.
                _labels[lastToken(1).text] = statements.length;
            }

            else if (matchTokens(TokenType.WORD, TokenType.EQUALS)) {
                String name = lastToken(2).text;
                Expression value = expression();
                statements.add(new AssignStatement(_variables, name, value));
            }

            else if (matchString("print")) {
                statements.add(new PrintStatement(expression()));
            }

            else if (matchString("input")) {
                statements.add(new InputStatement(_variables, consumeToken(TokenType.WORD).text));
            }

            else if (matchString("goto")) {
                final String label = consumeToken(TokenType.WORD).text;
                statements.add(new GotoStatement(_labels,label));
            }

            else if (matchString("if")) {
                Expression condition = expression();
                consumeString("then");
                String label = consumeToken(TokenType.WORD).text;
                statements.add(new IfThenStatement(_labels,condition, label));
            }

            else break;
            // Unexpected token (likely EOF), so end.
        }

        return statements;
    }

    // The following functions each represent one grammatical part of the
    // language. If this parsed English, these functions would be named like
    // noun() and verb().

    /**
     * Parses a single expression. Recursive descent parsers start with the
     * lowest-precedent term and moves towards higher precedence. For Jasic,
     * binary operators (+, -, etc.) are the lowest.
     *
     * @return The parsed expression.
     */
    Expression expression() {
        return operator();
    }

    /**
     * Parses a series of binary operator expressions into a single
     * expression. In Jasic, all operators have the same precedence and
     * associate left-to-right. That means it will interpret:
     *    1 + 2 * 3 - 4 / 5
     * like:
     *    ((((1 + 2) * 3) - 4) / 5)
     *
     * It works by building the expression tree one at a time. So, given
     * this code: 1 + 2 * 3, this will:
     *
     * 1. Parse (1) as an atomic expression.
     * 2. See the (+) and start a new operator expression.
     * 3. Parse (2) as an atomic expression.
     * 4. Build a (1 + 2) expression and replace (1) with it.
     * 5. See the (*) and start a new operator expression.
     * 6. Parse (3) as an atomic expression.
     * 7. Build a ((1 + 2) * 3) expression and replace (1 + 2) with it.
     * 8. Return the last expression built.
     *
     * @return The parsed expression.
     */
    Expression operator() {
        Expression expression = atomic();

        // Keep building operator expressions as long as we have operators.
        while (matchToken(TokenType.OPERATOR) || matchToken(TokenType.EQUALS)) {

            final String operator = lastToken(1).text.substring(0,1);
            Expression right = atomic();
            expression = new OperatorExpression(expression, operator, right);

        }

        return expression;
    }

    /**
     * Parses an "atomic" expression. This is the highest level of
     * precedence and contains single literal tokens like 123 and "foo", as
     * well as parenthesized expressions.
     *
     * @return The parsed expression.
     */
    Expression atomic() {
        if (matchToken(TokenType.WORD)) {
            // A word is a reference to a variable.
            return new VariableExpression(_variables, lastToken(1).text);
        }
        else if (matchToken(TokenType.NUMBER)) {
            return new NumberValue(double.parse(lastToken(1).text));
        }
        else if (matchToken(TokenType.STRING)) {
            return new StringValue(lastToken(1).text);
        }
        else if (matchToken(TokenType.LEFT_PAREN)) {
            // The contents of a parenthesized expression can be any
            // expression. This lets us "restart" the precedence cascade
            // so that you can have a lower precedence expression inside
            // the parentheses.
            Expression retExpression = expression();
            consumeToken(TokenType.RIGHT_PAREN);
            return retExpression;
        }
        throw new Exception("Couldn't parse :(");
    }

    // The following functions are the core low-level operations that the
    // grammar parser is built in terms of. They match and consume tokens in
    // the token stream.

    /**
     * Consumes the next two tokens if they are the given type (in order).
     * Consumes no tokens if either check fails.
     *
     * @param  type1 Expected type of the next token.
     * @param  type2 Expected type of the subsequent token.
     * @return       True if tokens were consumed.
     */
    bool matchTokens(TokenType type1, TokenType type2) {
        if (getUnconsumedToken(0).type != type1) return false;
        if (getUnconsumedToken(1).type != type2) return false;
        position += 2;
        return true;
    }

    /**
     * Consumes the next token if it's the given type.
     *
     * @param  type  Expected type of the next token.
     * @return       True if the token was consumed.
     */
    bool matchToken(final TokenType type) {
        if (getUnconsumedToken(0).type != type) return false;
        position++;
        return true;
    }

    /**
     * Consumes the next token if it's a word token with the given name.
     *
     * @param  name  Expected name of the next word token.
     * @return       True if the token was consumed.
     */
    bool matchString(final String name) {
        if (getUnconsumedToken(0).type != TokenType.WORD) return false;
        if (getUnconsumedToken(0).text != name) return false;
        position++;
        return true;
    }

    /**
     * Consumes the next token if it's the given type. If not, throws an
     * exception. This is for cases where the parser demands a token of a
     * certain type in a certain position, for example a matching ) after
     * an opening (.
     *
     * @param  type  Expected type of the next token.
     * @return       The consumed token.
     */
    Token consumeToken(TokenType type) {
        if (getUnconsumedToken(0).type != type) throw new Exception("Expected ${type}.");
        return _tokens[position++];
    }

    /**
     * Consumes the next token if it's a word with the given name. If not,
     * throws an exception.
     *
     * @param  name  Expected name of the next word token.
     * @return       The consumed token.
     */
    Token consumeString(String name) {
        if (!matchString(name)) throw new Exception("Expected ${name}.");
        return lastToken(1);
    }

    /**
     * Gets a previously consumed token, indexing backwards. lastToken(1) will
     * be the token just consumed, lastToken(2) the one before that, etc.
     *
     * @param  offset How far back in the token stream to look.
     * @return        The consumed token.
     */
    Token lastToken(int offset) {
        return _tokens[position - offset];
    }

    /**
     * Gets an unconsumed token, indexing forward. getUnconsumedToken(0) will be the next
     * token to be consumed, getUnconsumedToken(1) the one after that, etc.
     *
     * @param  offset How far forward in the token stream to look.
     * @return        The yet-to-be-consumed token.
     */
    Token getUnconsumedToken(int offset) {
        if (position + offset >= _tokens.length) {
            return new Token("", TokenType.EOF);
        }
        return _tokens[position + offset];
    }

}
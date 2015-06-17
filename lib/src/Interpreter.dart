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

class Interpreter {
    final Logger _logger = new Logger("dasic.Interpreter");

    /**
     * Constructs a new Interpreter instance. The instance stores the global state of
     * the interpreter such as the values of all of the variables and the
     * current statement.
     */
    Interpreter();

    /**
     * This is where the magic happens. This runs the code through the parsing
     * pipeline to generate the AST. Then it executes each statement. It keeps
     * track of the current line in a member variable that the statement objects
     * have access to. This lets "goto" and "if then" do flow control by simply
     * setting the index of the current statement.
     *
     * In an interpreter that didn't mix the interpretation logic in with the
     * AST node classes, this would be doing a lot more work.
     *
     * @param source A string containing the source code of a .jas script to
     *               interpret.
     */
    void interpret(final String source) {
        Validate.notBlank(source);

        // Tokenize.
        final Lexer lexer = new Lexer();
        final List<Token> tokens = lexer.scan(source);

        _showTokens(tokens);

        // Parse.
        final Parser parser = new Parser();
        final List<Statement> statements = parser.parse(tokens);

        // Interpret until we're done.
        int currentStatement = 0;
        while (currentStatement < statements.length) {

            final int nextStatement = statements[currentStatement].execute(currentStatement);
            currentStatement = nextStatement;
        }
    }

    // -- private -------------------------------------------------------------

    void _showTokens(final List<Token> tokens) {
        Validate.notNull(tokens);

        tokens.forEach((final Token token) {
            switch(token.type) {

                case TokenType.LINE:
                    _logger.fine("${token.type.toString().padRight(18)} -> <nl>");
                    break;

                default:
                    _logger.fine("${token.type.toString().padRight(18)} -> Text: ${token.text}");
                    break;
            }
        });
    }
}

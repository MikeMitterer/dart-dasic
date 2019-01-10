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

/*
* These classes define the syntax tree data structures. This is how code is
* represented internally in a way that's easy for the interpreter to
* understand.
*
* HACK: Unlike most real compilers or interpreters, the logic to execute
* the code is baked directly into these classes. Typically, it would be
* separated out so that the AST us just a static data structure.
*/

/**
 * Base interface for a Dasic statement. The different supported statement
 * types like "print" and "goto" implement this.
 */
abstract class Statement {

    /**
     * Statements implement this to actually perform whatever behavior the
     * statement causes. "print" statements will display text here, "goto"
     * statements will change the current statement, etc.
     *
     * Returns the next Statement-Index. In most cases this is currentStatement++
     * In case of IF or GOTO this is an INDEX to the according label
     */
    int execute(final int currentStatement) { run(); return (currentStatement + 1); }

    /// This is where the Statement executes its work, called from execute
    void run();
}

/**
 * A "print" statement evaluates an expression, converts the result to a
 * string, and displays it to the user.
 */
class PrintStatement extends Statement {
    final Expression _expression;

    PrintStatement(this._expression);

    @override
    void run() {
        print(_expression.evaluate().toString());
    }
}

/**
 * An "input" statement reads input from the user and stores it in a
 * variable.
 */
class InputStatement extends Statement {
    final Logger _logger = new Logger("dasic.InputStatement");

    final String _name;
    final Map<String, Value> _variables;

    InputStatement(this._variables,this._name);

    @override
    void run() {
        try {
            final String input = stdin.readLineSync();

            // Store it as a number if possible, otherwise use a string.
            try {
                double value = double.parse(input);
                _variables[_name] = new NumberValue(value);

            }
            on FormatException catch (_) {
                _variables[_name] = new StringValue(input);
            }
        }
        on FileSystemException catch (e1) {
            _logger.shout(e1);
        }
    }
}

/**
 * An assignment statement evaluates an expression and stores the result in
 * a variable.
 */
class AssignStatement extends Statement {
    final String _name;
    final Expression _value;
    final Map<String, Value> _variables;

    AssignStatement(this._variables, this._name, this._value);

    @override
    void run() {
        _variables[_name] = _value.evaluate();
    }
}

/**
 * A "goto" statement jumps execution to another place in the program.
 */
class GotoStatement implements Statement {
    final Map<String, int> _labels;
    final String _label;

    GotoStatement(this._labels, this._label);

    @override
    int execute(final int currentStatement) {
        int nextStatement = currentStatement + 1;

        if (_labels.containsKey(_label)) {
            nextStatement = _labels[_label];
        }
        run();
        return nextStatement;
    }

    @override
    void run() {}
}

/**
 * An if then statement jumps execution to another place in the program, but
 * only if an expression evaluates to something other than 0.
 */
class IfThenStatement implements Statement {
    final Map<String, int> _labels;
    final Expression _condition;
    final String _label;

    IfThenStatement(this._labels, this._condition, this._label);

    @override
    int execute(final int currentStatement) {
        int nextStatement = currentStatement + 1;

        if (_labels.containsKey(_label)) {

            final double value = _condition.evaluate().toNumber();
            if (value != 0.0) {
                nextStatement = _labels[_label];
            }
        }

        return nextStatement;
    }

    @override
    void run() {}
}


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
 * Base interface for an expression. An expression is like a statement
 * except that it also returns a value when executed. Expressions do not
 * appear at the top level in Jasic programs, but are used in many
 * statements. For example, the value printed by a "print" statement is an
 * expression. Unlike statements, expressions can nest.
 */
abstract class Expression {
    /**
     * Expression classes implement this to evaluate the expression and
     * return the value.
     *
     * @return The value of the calculated expression.
     */
    Value evaluate();
}

/**
 * A variable expression evaluates to the current value stored in that
 * variable.
 */
class VariableExpression implements Expression {
    final Map<String, Value> _variables;
    final String _name;

    VariableExpression(this._variables, this._name);

    Value evaluate() {
        if (_variables.containsKey(_name)) {
            return _variables[_name];
        }
        return new NumberValue(0.0);
    }


}

/**
 * An operator expression evaluates two expressions and then performs some
 * arithmetic operation on the results.
 */
class OperatorExpression implements Expression {

    final Expression _left;
    final String _operator;
    final Expression _right;

    OperatorExpression(this._left,this._operator, this._right);

    Value evaluate() {
        Value leftVal = _left.evaluate();
        Value rightVal = _right.evaluate();

        switch (_operator) {
            case '=':
            // Coerce to the left argument's type, then compare.
                if (leftVal is NumberValue) {
                    return new NumberValue((leftVal.toNumber() == rightVal.toNumber()) ? 1.0 : 0.0 );
                }
                else {
                    return new NumberValue(leftVal.toString() == rightVal.toString() ? 1.0 : 0.0);
                }
                break;

            case '+':
            // Addition if the left argument is a number, otherwise do
            // string concatenation.
                if (leftVal is NumberValue) {
                    return new NumberValue(leftVal.toNumber() + rightVal.toNumber());
                }
                else {
                    return new StringValue(leftVal.toString() + rightVal.toString());
                }
                break;

            case '-':
                return new NumberValue(leftVal.toNumber() - rightVal.toNumber());

            case '*':
                return new NumberValue(leftVal.toNumber() * rightVal.toNumber());

            case '/':
                return new NumberValue(leftVal.toNumber() / rightVal.toNumber());

            case '<':
            // Coerce to the left argument's type, then compare.
                if (leftVal is NumberValue) {
                    return new NumberValue((leftVal.toNumber() < rightVal.toNumber()) ? 1.0 : 0.0);
                }
                else {
                    return new NumberValue((leftVal.toString().compareTo(rightVal.toString()) < 0) ? 1.0 : 0.0);
                }
                break;

            case '>':
            // Coerce to the left argument's type, then compare.
                if (leftVal is NumberValue) {
                    return new NumberValue((leftVal.toNumber() > rightVal.toNumber()) ? 1.0 : 0.0);
                }
                else {
                    return new NumberValue((leftVal.toString().compareTo(rightVal.toString()) > 0) ? 1.0 : 0.0);
                }
                break;
        }
        throw new Exception("Unknown operator.");
    }
}
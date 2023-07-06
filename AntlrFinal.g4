grammar AntlrFinal;

// Parser rules

command: libraryCommand classDefinition+ EOF;

// 1) Library Commands--------------------------------------------------------------------------------------------------

libraryCommand: (importCommand)* (requireCommand)*;

// - import
importCommand: IMPORT ':' ':' FROM '(' importList ')';
importList: importItem (',' importItem)*;
importItem: library '.' IDENTIFIER;
library: IDENTIFIER;

// - require
requireCommand: REQUIRE '(' requireList ')';
requireList: requireItem (',' requireItem)*;
requireItem: library;

// 2) Array Definition--------------------------------------------------------------------------------------------------

arrayDefinition : (arrayDeclaration | arrayInitialization)+ ;

arrayDeclaration : all_visibility? CONST? dataType name NEW '[' ']' LTEQ dataType '[' NUMBER ']';
arrayInitialization : all_visibility? CONST? dataType name '[' ']' LTEQ '[' values ']' ;

values : value (',' value)*;
value : NUMBER | FloatNumber;
name : IDENTIFIER;

// 3) refrence Definition--------------------------------------------------------------------------------------------------

referralDefinition : (all_visibility? IDENTIFIER IDENTIFIER ASSIGN NEW IDENTIFIER '[' parameters ']')+;

parameters : IDENTIFIER (',' IDENTIFIER)*;

// 4) variable ---------------------------------------------------------------------------------------------------------


// - definition
variableDefinition:( all_visibility? CONST? dataType ((IDENTIFIER ('<=' expression)?) | ( IDENTIFIER (',' IDENTIFIER)*)))+;

dataType: STRING | INT | BOOL | FLOAT;
expression: StringLiteral | NUMBER | BooleanLiteral | QuoteStringLiteral;


// - usage
variableUsage: (IDENTIFIER '=' variable_expression)+;

variable_expression: NUMBER | IDENTIFIER;

// 5) Loops ------------------------------------------------------------------------------------------------------------

loop: (whileLoop | doWhileLoop | forLoop)+;

whileLoop: WHILE '[' conditions ']' DO all_statements? DONE;
doWhileLoop: DO all_statements? AS_LONG_AS '[' conditions ']';
forLoop: FOR '(' '(' parameterInitialization? ';' conditions ';' priority5? ')' ')' DO all_statements? DONE;

conditions: expression_loop;
parameterInitialization: dataType IDENTIFIER '=' NUMBER;

expression_loop: priority14 | priority15 | priority16 | 'true' | 'false';

comparisonOperator: '==' | '!=' | '<' | '>' | '<=' | '>=';

// 6) Conditions -------------------------------------------------------------------------------------------------------

condition: IF '[' condition_expression ']' ':' THEN all_statements (ELSE all_statements)? FI;

condition_expression: IDENTIFIER comparisonOperator NUMBER;
//condition_statements: condition_statement+;
//condition_statement: functionDeclaration | condition_assignment;

//condition_assignment: IDENTIFIER assignmentOperator NUMBER;
//assignmentOperator: '=' | '+=' | '-=' | '*=' | '/=' | '%=';

// 7) Function Declaration ---------------------------------------------------------------------------------------------

functionDeclaration: '@' IDENTIFIER '(' arguments? ')';

arguments: argument (',' argument)*;
argument: IDENTIFIER | NUMBER | QuoteStringLiteral;

// 8) Function Definition ---------------------------------------------------------------------------------------------

functionDefinition: functionHeader ':' all_statements END;

functionHeader: IDENTIFIER '<-' all_visibility? FUNCTION '(' parametersF? ')';

parametersF: parameter (',' parameter)*;
parameter: dataType IDENTIFIER;

all_statements: all_statement+;
all_statement
                     : (functionDeclaration
                     | loop
                     | condition
                     | referralDefinition
                     | arrayDefinition
                     | variableDefinition
                     | variableUsage
                     | functionDeclaration
                     | functionDefinition
                     | exceptionHandling
                     | switchCase
                     | expressions );

// 9) Exeptions --------------------------------------------------------------------------------------------------------

exceptionHandling: TRY ':' all_statements? (EXCEPT exceptionList ':' all_statements)?;

exceptionList: exceptionName (',' exceptionName)*;
exceptionName: IDENTIFIER;


// 10) Switch-Case -----------------------------------------------------------------------------------------------------

switchCase: CASE IDENTIFIER ':' caseStatements* elseStatements END;

caseStatements: 'when' QuoteStringLiteral all_statements;
elseStatements: 'else' all_statements;


// 11) Class Definition ------------------------------------------------------------------------------------------------

classDefinition: (all_visibility? CLASS IDENTIFIER (INHERITED FROM parentClassList)? classBody END_CLASS)+;

all_visibility: PUBLIC | PRIVATE;

parentClassList: IDENTIFIER (',' IDENTIFIER)*;

classBody: classMember*;
classMember: (variableDefinition*  (constructorDeclaration variableDefinition* functionDefinition*)+ variableDefinition* )+;
constructorDeclaration: Constructor functionDefinition;

// 12) Operators -------------------------------------------------------------------------------------------------------

expressions: '!' ? priority18 (('&' '&'  |  '|' '|') '!'? priority18)*;

priority18: priority17 (('*=' | '/=') priority17)*;
priority17: priority16 (('+=' | '-=') priority16)*;
priority16: priority15 (('>' | '<') priority15)*; // compare value
priority15: priority14 (('>=' | '<=') priority14)*; // compare value
priority14: priority13 (( '==' | '!=') priority13)*; //compare equality
priority13: priority12 (('or |') priority12)*;
priority12: priority11 (('||') priority11)*;
priority11: priority10 (( 'and &') priority10)*;
priority10: priority8 (('&&' ) priority8)*;
priority8: priority7 (('+' | '-') priority7)*; // sum of a terms
priority7: priority6 (('*' | '/' | '%' | '//') priority6)*;
priority6: priority5 (('<<' | '>>') priority5)*; // shift right or left
priority5: ('++' | '--')? priority4 ('++' | '--')?; //increase or decrease
priority4: ('-' | '+')? priority3; //positive or negetive
priority3: '~'? priority2; //bitwise not operation
priority2: (all_value '^')* all_value; //power operation1
priority1: '(' expressions? ')'; //inside of parentheses
priority0: '(' 'conditions' '?' expressions ':' expressions ')'; //ternary expression
all_value:   NUMBER | priority1  | FloatNumber | IDENTIFIER  | priority0;




// Lexer rules

STRING:[Ss][Tt][Rr][Ii][Nn][Gg];
BOOL:[Bb][Oo][Oo][Ll];
Constructor:[Cc][Oo][Nn][Ss][Tt][Rr][Uu][Cc][Tt][Oo][Rr];
INHERITED: [Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ee][Dd];
FROM: [Ff][Rr][Oo][Mm];
END_CLASS: [Ee][Nn][Dd][_][Cc][Ll][Aa][Ss][Ss];
INT: [Ii][Nn][Tt];
FLOAT: [Ff][Ll][Oo][Aa][Tt];
CLASS: [Cc][Ll][Aa][Ss][Ss];
CASE: [Cc][Aa][Ss][Ee];
END: [Ee][Nn][dD];
IF : [Ii][Ff];
THEN : [Tt][Hh][Ee][Nn];
ELSE : [Ee][Ll][Ss][Ee];
FI: [Ff][Ii];
FUNCTION: [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn];
TRY: [Tt][Rr][Yy];
EXCEPT: [Ee][Xx][Cc][Ee][Pp][Tt];
QuoteStringLiteral: '"' .*? '"';
NUMBER: [0-9]+;
CONST:[Cc][Oo][Nn][Ss][Tt];
WHILE:[Ww][Hh][Ii][Ll][Ee];
AS_LONG_AS:[Aa][Ss][_][Ll][Oo][Nn][Gg][_][Aa][Ss];
FOR:[Ff][Oo][Rr];
DO: [Dd][Oo];
DONE: [Dd][Oo][Nn][Ee];
PUBLIC : P U B L I C;
PRIVATE : P R I V A T E;
StringLiteral: '"' ~["\r\n]* '"';
BooleanLiteral: 'TRUE' | 'FALSE';
TRUE :[Tt][Rr][Uu][Ee];
FALSE: [Ff][Aa][Ll][Ss][Ee];
ASSIGN  : '<-';
NEW: [Nn][Ee][Ww];
IMPORT: [Ii][Mm][Pp][Oo][Rr][Tt];
REQUIRE: [Rr][Ee][Qq][Uu][Ii][Rr][Ee];
IDENTIFIER: [a-zA-Z_$][a-zA-Z0-9_$]*;

CapitalizedIdentifier: [A-Z][a-zA-Z0-9_]*;

FloatNumber: NUMBER '.' ('0' | NUMBER)+;
LTEQ    : '<=';
FLOAT_NUM: [0-9]+ '.' [0-9]+;


fragment A:[aA];
fragment B:[bB];
fragment C:[cC];
fragment E:('e'|'E');
fragment I:[iI];
fragment L:[lL];
fragment P:[pP];
fragment R:[rR];
fragment T:[tT];
fragment U:[uU];
fragment V:[vV];



WS: [ \t\r\n]+ -> skip;
Skip : (' '|'\t'|'\r'|'\n')+ -> skip;

SingleLineComment: '##' ~[\r\t\n]* -> skip;
MultiLineComment: '/*' .*? '*/' -> skip;
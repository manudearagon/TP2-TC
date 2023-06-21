grammar compiladores;

@header {
package compiladores;
}

fragment DIGITO : [0-9] ;

// Caracteres especiales
PA : '(';
PC : ')';
LA : '{';
LC : '}';
PyC: ';';
IGU: '=';
COM: ',';

// Comparadores
EQ: '==';
GT: '>';
GE: '>=';
LT: '<';
LE: '<=';
NEQ: '!=';

// Expresiones lógicas
AND: '&&';
OR: '||';

// Aritmética
SUMA: '+';
RESTA: '-';
MULT: '*'; 
DIV: '/'; 
MOD: '%'; 

// Variables
INT : 'int' ;
DOUBLE: 'double';
BOOL: 'boolean';

// Booleanos
TRUE: 'true';
FALSE: 'false';

// Palabras reservadas
IWHILE: 'while';
IIF: 'if';
IFOR: 'for';
IRETURN: 'return';

// Nombre de variables
VAR: [a-zA-Z]+ ;

// Skip
WS : [ \t\n\r] -> skip;

// Declaración de entero, doble y bool en números
ENTERO : DIGITO+ ;
DOBLE: DIGITO+ '.' DIGITO+;
BOOLEANO: ( TRUE | FALSE );

programa : instrucciones EOF ;

instrucciones : instruccion instrucciones
              |
              ;

instruccion : declaracion PyC
            | asignacion PyC
            | bucle_while 
            | condicional_if
            | bucle_for
            | declaracion_funcion
            | asignacion_funcion
            ;

declaracion: tipo_var VAR concatenacion 
            ;

concatenacion: COM VAR concatenacion 
              | COM asignacion
              |
              ;

asignacion: VAR IGU VAR
            | VAR IGU ENTERO
            | VAR IGU DOBLE
            | VAR IGU BOOLEANO
            ;

bloque: LA instrucciones LC;

op_logicos: AND
          | OR
          ;

op_booleanas: TRUE
            | FALSE
            ;

bucle_while: IWHILE PA cond PC bloque;

condicional_if: IIF PA cond PC bloque;

bucle_for: IFOR PA declaracion cond PyC post_pre_incremento PC bloque;

declaracion_funcion: tipo_var VAR PA declaracion_argumentos PC PyC bloque_funcion;

declaracion_argumentos: tipo_var concatenacion_argumentos_declaracion;

concatenacion_argumentos_declaracion: COM declaracion_argumentos
                                    | 
                                    ;

asignacion_funcion: tipo_var VAR PA asignacion_argumentos PC bloque_funcion;

asignacion_argumentos: tipo_var VAR concatenacion_argumentos_asignacion 
                     | tipo_var asignacion concatenacion_argumentos_asignacion 
                     ;

concatenacion_argumentos_asignacion: COM asignacion_argumentos
                                   |
                                   ;

bloque_funcion: LA instrucciones_funcion LC;

instrucciones_funcion: instruccion_funcion instrucciones_funcion
                     |
                     ;

instruccion_funcion : declaracion PyC
                    | asignacion PyC
                    | bucle_while 
                    | condicional_if
                    | bucle_for
                    | return_tipo PyC
                    ;

return_tipo: IRETURN VAR
           | IRETURN factor
           | IRETURN
           ;

tipo_var: INT
        | DOUBLE
        | BOOL
        ;

post_pre_incremento: VAR SUMA SUMA
                   | VAR RESTA RESTA
                   | SUMA SUMA VAR
                   | RESTA RESTA VAR
                   | VAR IGU VAR SUMA factor 
                   | VAR IGU VAR RESTA factor     
                   ;

cond: e comparadores e 
    | cond op_logicos cond
    | op_booleanas op_logicos op_booleanas
    | op_booleanas
    ;

comparadores : GT
             | GE
             | LT
             | LE
             | EQ
             | NEQ
             ;

e: term exp;

exp: SUMA e
    | RESTA e
    |
    ;

term: factor t;

t: MULT term
 | DIV term
 | MOD term
 |
 ;

factor: ENTERO
      | DOBLE
      | BOOLEANO
      | VAR
      | PA e PC
      ;

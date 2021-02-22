%{
#include <stdio.h>
#include <stdlib.h>

%}
%token ID NUM CHARACTER FLNUM T_lt T_gt T_lteq T_gteq T_neq T_eqeq T_pl T_min T_mul T_div T_and T_or T_incr T_decr T_not T_eq INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE PRINTF STRING SWITCH CASE DEFAULT

%%
S
      : START {printf("Input accepted.\n");exit(0);}
      ;

START
      : INCLUDE T_lt H T_gt MAIN
      ;

MAIN
      : VOID MAINTOK BODY
      | INT MAINTOK BODY
      ;

BODY
      : '{' C '}'
      ;

C
      : C statement ';'
      | C LOOPS
      | statement ';'
      | LOOPS
      ;

LOOPS
      : IF '(' COND ')' LOOPBODY
      | IF '(' COND ')' LOOPBODY ELSE LOOPBODY
      | STMT_SWITCH
      ;

STMT_SWITCH	
      : SWITCH '(' COND ')' '{' SWITCHBODY '}'
	;
SWITCHBODY	
      : CASES   
	| CASES DEFAULTSTMT
	;

CASES 
      : CASE NUM ':' C BREAKSTMT
	| 
	;

BREAKSTMT
      : BREAK ';' CASES
	| CASES 
	;

DEFAULTSTMT : DEFAULT ':' C DE  
				;

DE 	: BREAK ';'
	|
	;

LOOPBODY
  	  : '{' C '}'
  	  | ';'
  	  | statement ';'
  	  ;

statement
      : ASSIGN_EXPR
      | ARITH_EXPR
      | TERNARY_EXPR
      | PRINT
      ;

COND
      : LIT RELOP LIT
      | LIT
      | LIT RELOP LIT bin_boolop LIT RELOP LIT
      | un_boolop '(' LIT RELOP LIT ')'
      | un_boolop LIT RELOP LIT
      | LIT bin_boolop LIT
      | un_boolop '(' LIT ')'
      | un_boolop LIT
      ;

ASSIGN_EXPR
      : ID T_eq ARITH_EXPR
      | TYPE ID T_eq ARITH_EXPR
      | TYPE ID
      | TYPE ID'['']' T_eq STRING
      ;

ARITH_EXPR
      : LIT
      | LIT bin_arop ARITH_EXPR
      | LIT bin_boolop ARITH_EXPR
      | LIT un_arop
      | un_arop ARITH_EXPR
      | un_boolop ARITH_EXPR
      ;

TERNARY_EXPR
      : '(' COND ')' '?' statement ':' statement
      ;

PRINT
      : PRINTF '(' STRING ')'
      ;
LIT
      : ID
      | NUM
      | FLNUM
      | CHARACTER
      ;
TYPE
      : INT
      | CHAR
      | FLOAT
      ;
RELOP
      : T_lt
      | T_gt
      | T_lteq
      | T_gteq
      | T_neq
      | T_eqeq
      ;

bin_arop
      : T_pl
      | T_min
      | T_mul
      | T_div
      ;

bin_boolop
      : T_and
      | T_or
      ;

un_arop
      : T_incr
      | T_decr
      ;

un_boolop
      : T_not
      ;


%%

#include "lex.yy.c"

void yyerror(char* s){
  printf("Line %d %s \n",count,s);
  exit(0);
}

int main(int argc, char* args[])
{
  yyin=fopen(args[1],"r");
  //yyout=fopen("output.c","w");
  yyparse();
  return 0;
}
// STMT_SWITCH	
//       : SWITCH '(' COND ')' {switch_start();} '{' SWITCHBODY '}'
// 	;
// SWITCHBODY	
//       : CASES {switch_end();}    
// 	| CASES DEFAULTSTMT {switch_end();}
// 	;

// CASES 
//       : CASE NUM {switch_case();} ':' C BREAKSTMT
// 	| 
// 	;

// BREAKSTMT
//       : BREAK {switch_break();} ';' CASES
// 	|{switch_nobreak();} CASES 
// 	;

// DEFAULTSTMT : DEFAULT {switch_default();} ':' C DE  
// 				;

// DE 	: BREAK {switch_break();}';'
// 	|
// 	;
// line 15
//      | INCLUDE "\"" H "\"" MAIN
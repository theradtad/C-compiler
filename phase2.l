%{
    #include<string.h>
    #include<stdio.h>
    int count=1;

    static void comment(void);
%}
alpha [A-Za-z_]
digit [0-9]
%%
"/*"    { comment(); }
[ \t]   ;
[ \n] count+=1;
"switch"    return SWITCH;
"case"  return CASE;
"default"   return DEFAULT;
"if" return IF;
"else" return ELSE;
"printf" return PRINTF;
"break" return BREAK;
"continue" return CONTINUE;
"int" return INT;
"float" return FLOAT;
"char" return CHAR;
"void" return VOID;
"#include" return INCLUDE;
"main()" return MAINTOK;
{digit}+    return NUM;
{alpha}({alpha}|{digit})*    return ID;
{alpha}({alpha}|{digit})*"\.h"?   return H;
\".*\" return STRING;
"<"   return T_lt;
">"     return T_gt;
"="     return T_eq;
"<="    return T_lteq;
">="    return T_gteq;
"=="    return T_eqeq;
"!="    return T_neq;
"+"     return T_pl;
"-"     return T_min;
"*"     return T_mul;
"/"     return T_div;
"++"    return T_incr;
"--"    return T_decr;
"!"     return T_neq;
"||"    return T_or;
"&&"    return T_and;

.    return yytext[0];
%%
static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("Unfinished comment");
}

int yywrap(void){
    return 1;
}

%{
 /*change YYSTYPE default to string(char *)*/
#define YYSTYPE_IS_DECLARED 1
typedef char* YYSTYPE;
#include "y.tab.h"
 /*for use strcpy()*/
#include <string.h>
 /*for use malloc()*/
#include <stdlib.h>
char* transfer_yytext();
%}
delim [ \t\n]
ws {delim}+
digit [0-9]
number {digit}+
%%
{ws} { }
\+ {return '+';}
\- {return '-';}
\* {return '*';}
\/ {return '/';}
\= {return '=';}
\( {return '(';}
\) {return ')';}
{number} {yylval = transfer_yytext(); return NUMBER;}
 /*token type: NUMBER*/
%%
char* transfer_yytext(){
	 /*Maximum 10 digits*/
    char *y = malloc(11);
    strcpy(y,yytext);
    return y;
}
int yywrap(){}
 /*scanner reaches the end of file*/
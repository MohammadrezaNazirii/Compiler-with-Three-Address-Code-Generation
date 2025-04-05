%{
#define YYSTYPE_IS_DECLARED 1
typedef char* YYSTYPE;
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
char* output_expr(char* expr1,char operand, char* expr2);
int temporary = 1;
char* temporary_values[1000];
%}
%token NUMBER
%left '-' '+'
%left '*' '/'
%%
start : expr '=' {};
expr : expr '+' expr { $$ = output_expr($1, '+', $3); }
| expr '-' expr { $$ = output_expr($1, '-', $3); }
| expr '*' expr { $$ = output_expr($1, '*', $3); }
| expr '/' expr { $$ = output_expr($1, '/', $3); }
| '(' expr ')' { $$ = $2; }
| NUMBER
;
 /*ambiguous CFG handled in line 12, 13*/
%%

char* adder(char* a, char* b) {
	char * result = malloc(1000);
	strcpy(result, a);
	for(int i = 0; b[i]; i++){
		if(!strchr(a, b[i])){
			int tmp = strlen(result);
			result[tmp] = b[i];
			result[tmp+1] = 0;
		}
	}
	return result;
}

char* subtractor(char* a, char* b) {
	char * result = malloc(1000);
	result[0] = 0;
	for(int i = 0; a[i]; i++){
		if(!strchr(b, a[i])){
			int tmp = strlen(result);
			result[tmp] = a[i];
			result[tmp+1] = 0;
		}
	}
	return result;
}

int sum(int i) {
	int result = 0;
	while(i){
		result += i % 10;
		i /= 10;
	}
	if(result >= 10)
		return sum(result);
	return result;
}

char* multiplier(char* a, char* b) {
	char* result = malloc(1000);
	strcpy(result, a);
	int b_int;
	sscanf(b, "%d", &b_int);
	char b_sum[2];
	itoa(sum(b_int), b_sum, 10);
	if(!strchr(a, b_sum[0])){
		int temp = strlen(result);
		result[temp] = b_sum[0];
		result[temp+1] = 0;
	}
	return result;
}

char* division(char* a, char* b) {
	char* result = malloc(1000);
	result[0] = 0;
	int b_int;
	sscanf(b, "%d", &b_int);
	char b_sum[2];
	itoa(sum(b_int), b_sum, 10);
	for(int i = 0; a[i]; i++){
		if(a[i] != b_sum[0]){
			int tmp = strlen(result);
			result[tmp] = a[i];
			result[tmp+1] = 0;
		}
	}
	return result;
}

char* output_expr(char* expr1,char operand, char* expr2) {
    char* new_temporary = malloc(5);
    sprintf(new_temporary, "t%d", temporary++);
	char* value1 = malloc(1000);
	char* value2 = malloc(1000);
	char* result = malloc(1000);
	
	int temporary_number;
	if(expr1[0] == 't'){
		sscanf(expr1, "t%d", &temporary_number);
		value1 = temporary_values[temporary_number];
	}else
		strcpy(value1, expr1);
	if(expr2[0] == 't'){
		sscanf(expr2, "t%d", &temporary_number);
		value2 = temporary_values[temporary_number];
	}else
		strcpy(value2, expr2);
	
	switch(operand){
		case '+':
			result = adder(value1, value2);
			break;
		case '-':
			result = subtractor(value1, value2);
			break;
		case '*':
			result = multiplier(value1, value2);
			break;
		case '/':
			result = division(value1, value2);
			break;
		default:
			break;
	}
	
	printf("t%d = %s %c %s;\nt%d = %s;\n", temporary-1, expr1, operand, expr2, temporary-1, result);
	temporary_values[temporary-1] = malloc(1000);
	strcpy(temporary_values[temporary-1], result);
    return new_temporary;
}

int main() {
    if (yyparse() != 0)
         /*printf("Abnormal exit\n");*/
		fprintf(stderr, "Abnormal exit\n");
    return 0;
}
int yyerror(char *s) {
     /*printf("Error: %s\n", s);*/
	fprintf(stderr, "Error: %s\n", s);
}

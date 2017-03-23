#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern void yyerror(); 
extern int  yylex();
#define YYDEBUG 1
#include "y.tab.c"
#include "lex.yy.c"
#include "hashing.h"
extern FILE *yyin;

int main(int argc, char *argv[])
{
	init_symtable();
	//char str[100];
	FILE *fp;
	//int i;
	if(argc>1)
	{ 
		fp = fopen(argv[1],"r");
	}
	if(!fp)
	{
		printf("\n File not found\n");  
		exit(0);
	}
	yyin = fp;
	scope_st[0]=-1;
	int p=yyparse();
	//printf("Return Value of yyparse: %d\n",p);
	if (argc>2 && strcmp(argv[2],"-symtable")==0)
		print_table();
	return 0;
}

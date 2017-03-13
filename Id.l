%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "y.tab.h"

/*int line_num = 0;
int h_scope = -1;   //highest scope
int scope = -1;
int p_scope = -2;
int scope_st[30];
int s_n = 0;*/

int str=0;
int chr=0;

void dec();
int yywrap(void);
%}

ALPHA [A-Za-z]
DIGIT [0-9]
ALPHANUMERIC [A-Za-z0-9]
UNDERSCORE	"_"
EQUALS_OP "="
LT_OP "<"
GT_OP ">"
LTE_OP "<="
GTE_OP ">="
ETE_OP "=="
OPEN_P "("
CLOSE_P ")"
OPEN_F "{"
CLOSE_F "}"
KEYWORD "for"|"while"|"main"|"switch"|"if"|"else"|"if else"|"scanf"|"printf"|"int"|"char"|"float"|"short"|"long"|"double"|"struct"
OPEN_S "["
CLOSE_S "]"
NEW_LINE "\n"
D_QUOTES [\"]
S_QUOTES [\']
STRING [^"]*
CHAR .
SEM_COL ";"
COL ":"
ART_OP [-+*/]

%x String Char
%%
{NEW_LINE} {printf("match: %s",yytext);return NEW_LINE;/*line_num++;*/}
{SEM_COL}  {return SEM_COL;}
{COL}  {return COL;}
{ART_OP}  {yylval.idname=strdup(yytext);return  ART_OP;}
{DIGIT}* {yylval.idname=strdup(yytext);return DIGIT;}
{OPEN_F} {/*p_scope=scope;scope=++h_scope;scope_st[++s_n]=scope;*/return OPEN_F;}
{CLOSE_F} {/*scope=scope_st[--s_n];p_scope=scope_st[s_n-1];*/return CLOSE_F;}
{KEYWORD} {yylval.idname=strdup(yytext);return KEYWORD;}
{ALPHA}({ALPHANUMERIC}|{UNDERSCORE})* {printf("Found Identifier: %s\n",yytext);yylval.idname=strdup(yytext);return ID;}
{CLOSE_S} {return CLOSE_S;}
{OPEN_S} {return OPEN_S;}
{EQUALS_OP} {return EQUALS_OP;}
{LT_OP} {return LT_OP;}
{GT_OP} {return GT_OP;}
{LTE_OP} {return LTE_OP;}
{GTE_OP} {return GTE_OP;}
{ETE_OP} {return ETE_OP;}
{OPEN_P} {return OPEN_P;}
{CLOSE_P} {return CLOSE_P;}    //handle strings
<String>{STRING} {return STRING;}
<Char>{CHAR} {return CHAR;}
{D_QUOTES} {if(str==0){str=1;BEGIN String;}else {str=0;BEGIN 0;}return D_QUOTES;}
{S_QUOTES} {if(chr==0){chr=1;BEGIN Char;}else {chr=0;BEGIN 0;}return S_QUOTES;}
. {printf("Nothing matched: %s\n",yytext);}

%%

int yywrap(void)        /* called at end of input */
{
    printf("In Wrap\n");
    return 1;           /* terminate now */
}

/*void dec()
{
	printf("Before Declaring\n");
	yylval.line=line_num;
	printf("After Declaring\n");
	//yylval.scope=scope;
	//yylval.p_scope=p_scope;
}*/

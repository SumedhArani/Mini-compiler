%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "y.tab.h"
#include "hashing.c"

int line_num = 0;
int h_scope = -1;   //highest scope
int scope = -1;
int p_scope = -2;
int scope_st[30];
int s_n = 0;

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
{NEW_LINE} {/*return NEW_LINE;*/line_num++;}
{SEM_COL}  {hash_insert(yytext,"SEM_COL",line_num,scope,p_scope);return SEM_COL;}
{COL}  {hash_insert(yytext,"COL",line_num,scope,p_scope);return COL;}
{ART_OP}  {/*yylval.idname=strdup(yytext);*/hash_insert(yytext,"ART_OP",line_num,scope,p_scope);return  ART_OP;}
{DIGIT}* {/*yylval.idname=strdup(yytext);*/hash_insert(yytext,"DIGIT",line_num,scope,p_scope);return DIGIT;}
{OPEN_F} {p_scope=scope;scope=++h_scope;scope_st[++s_n]=scope;hash_insert(yytext,"OPEN_F",line_num,scope,p_scope);return OPEN_F;}
{CLOSE_F} {scope=scope_st[--s_n];p_scope=scope_st[s_n-1];hash_insert(yytext,"CLOSE_F",line_num,scope,p_scope);return CLOSE_F;}
{KEYWORD} {/*yylval.idname=strdup(yytext);*/hash_insert(yytext,"KEYWORD",line_num,scope,p_scope);return KEYWORD;}
{ALPHA}({ALPHANUMERIC}|{UNDERSCORE})* {/*printf("Found Identifier: %s\n",yytext);yylval.idname=strdup(yytext);*/hash_insert(yytext,"ID",line_num,scope,p_scope);return ID;}
{CLOSE_S} {hash_insert(yytext,"CLOSE_S",line_num,scope,p_scope);return CLOSE_S;}
{OPEN_S} {hash_insert(yytext,"OPEN_S",line_num,scope,p_scope);return OPEN_S;}
{EQUALS_OP} {hash_insert(yytext,"EQUALS_OP",line_num,scope,p_scope);return EQUALS_OP;}
{LT_OP} {hash_insert(yytext,"LT_OP",line_num,scope,p_scope);return LT_OP;}
{GT_OP} {hash_insert(yytext,"GT_OP",line_num,scope,p_scope);return GT_OP;}
{LTE_OP} {hash_insert(yytext,"LTE_OP",line_num,scope,p_scope);return LTE_OP;}
{GTE_OP} {hash_insert(yytext,"GTE_OP",line_num,scope,p_scope);return GTE_OP;}
{ETE_OP} {hash_insert(yytext,"ETE_OP",line_num,scope,p_scope);return ETE_OP;}
{OPEN_P} {hash_insert(yytext,"OPEN_P",line_num,scope,p_scope);return OPEN_P;}
{CLOSE_P} {hash_insert(yytext,"CLOSE_P",line_num,scope,p_scope);return CLOSE_P;}    //handle strings
<String>{STRING} {hash_insert(yytext,"STRING",line_num,scope,p_scope);return STRING;}
<Char>{CHAR} {hash_insert(yytext,"CHAR",line_num,scope,p_scope);return CHAR;}
{D_QUOTES} {if(str==0){str=1;BEGIN String;}else {str=0;BEGIN 0;}hash_insert(yytext,"D_QUOTES",line_num,scope,p_scope);return D_QUOTES;}
{S_QUOTES} {if(chr==0){chr=1;BEGIN Char;}else {chr=0;BEGIN 0;}hash_insert(yytext,"S_QUOTES",line_num,scope,p_scope);return S_QUOTES;}
. {/*printf("Nothing matched: %s\n",yytext);*/}

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

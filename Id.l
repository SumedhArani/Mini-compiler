%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "y.tab.h"
#include "hashing.h"

int line_num = 0;
int h_scope = -1;   //highest scope
int scope = -1;
int p_scope = -2;
int scope_st[30];
int s_n = 0;

int for_f = 0;
int scp_in = 0;

int str=0;
int chr=0;

void dec();
int yywrap(void);
%}

ALPHA [A-Za-z]
DIGIT [0-9]
ALPHANUMERIC [A-Za-z0-9]
UNDERSCORE	"_"
EQ_OP "="
LT_OP "<"
GT_OP ">"
LTE_OP "<="
GTE_OP ">="
ETE_OP "=="
NTE_OP "!="
OPEN_P "("
CLOSE_P ")"
OPEN_F "{"
CLOSE_F "}"
FOR_KW "for"
WHILE_KW "while"
SWITCH_KW "switch"
IF_KW "if"
ELSE_KW "else"
SCAN_KW "scanf"
PRINT_KW "printf"
STRUCT_KW "struct"
RETURN_KW "return"
TYPE "int"|"char"|"float"|"short"|"long"|"double"
OPEN_S "["
CLOSE_S "]"
UN_MINUS "--"
UN_PLUS "++"
PLUS "+"
MINUS "-"
MUL "*"
DIV "/"
NEW_LINE "\n"
D_QUOTES [\"]
S_QUOTES [\']
STRING [^"]*
F_NAME [^"><]*
CHAR .
SEM_COL ";"
COL ":"
COMMA ","
H_DIR [#][" "]*"include"[" "]*
AND "&"
OR "|"



%x String Char h_dir
%%
{H_DIR} {
			BEGIN h_dir;
			yylval = hash_insert(yytext,"H_INC",line_num,scope,p_scope);
			return H_INC;
		}

<h_dir>{LT_OP} 	{
					yylval = hash_insert(yytext,"LT_OP",line_num,scope,p_scope);
					return LT_OP;
				}

<h_dir>{D_QUOTES} 	{
						str=1;
						yylval = hash_insert(yytext,"D_QUOTES",line_num,scope,p_scope);
						return D_QUOTES;
					}

<h_dir>{F_NAME} 	{
						yylval = hash_insert(yytext,"HF_NAME",line_num,scope,p_scope);
						BEGIN 0;
						return HF_NAME;
					}

{NEW_LINE} 	{
				/*return NEW_LINE;*/
				line_num++;
			}

{AND} 	{
			yylval = hash_insert(yytext,"AND",line_num,scope,p_scope);
			return AND;
		}

{OR}  	{
			yylval = hash_insert(yytext,"OR",line_num,scope,p_scope);
			return OR;
		}

{NTE_OP}   	{
				yylval = hash_insert(yytext,"NTE_OP",line_num,scope,p_scope);
				return NTE_OP;
			}

{MUL} 	{
			yylval = hash_insert(yytext,"MUL",line_num,scope,p_scope);
			return MUL;
		}

{COMMA} {
			yylval = hash_insert(yytext,"COMMA",line_num,scope,p_scope);
			return COMMA;
		}

{TYPE}  {
			if(for_f == 1)
			{
				p_scope=scope;
				scope=++h_scope;
				scope_st[++s_n]=scope;
				scp_in = 1;
			}
			yylval = hash_insert(yytext,"TYPE_KW",line_num,scope,p_scope);
			return TYPE;
		}

{SEM_COL}  	{
				if(for_f != 0)
				{
					for_f++;
					if(for_f==4)
					{
						scope=scope_st[--s_n];
						p_scope=scope_st[s_n-1];
						for_f=0;
					}
				}
				yylval = hash_insert(yytext,"SEM_COL",line_num,scope,p_scope);
				return SEM_COL;
			}

{COL}  	{
			yylval = hash_insert(yytext,"COL",line_num,scope,p_scope);
			return COL;
		}

{UN_PLUS}  	{
				yylval = hash_insert(yytext,"UN_PLUS",line_num,scope,p_scope);
				return UN_PLUS;
			}

{UN_MINUS}  {
				yylval = hash_insert(yytext,"UN_MINUS",line_num,scope,p_scope);
				return UN_MINUS;
			}

{PLUS}  {
			/*yylval.idname=strdup(yytext);*/
			yylval = hash_insert(yytext,"PLUS",line_num,scope,p_scope);
			return PLUS;
		}

{MINUS} {
			/*yylval.idname=strdup(yytext);*/
			yylval = hash_insert(yytext,"MINUS",line_num,scope,p_scope);
			return MINUS;
		}

{DIV}  	{
			/*yylval.idname=strdup(yytext);*/
			yylval = hash_insert(yytext,"DIV",line_num,scope,p_scope);
			return DIV;
		}

{DIGIT}*	{
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"DIGIT",line_num,scope,p_scope);
				return DIGIT;
			}

{DIGIT}*[.]{DIGIT}*	{
						yylval = hash_insert(yytext,"D_DIGIT",line_num,scope,p_scope);
						return D_DIGIT;
					}

{OPEN_F} 	{
				if (scp_in == 0)
				{
					p_scope=scope;
					scope=++h_scope;
					scope_st[++s_n]=scope;
				}
				else
					scp_in = 0;
				for_f = 0;
				yylval = hash_insert(yytext,"OPEN_F",line_num,scope,p_scope);
				return OPEN_F;
			}

{CLOSE_F} 	{
				scope=scope_st[--s_n];
				p_scope=scope_st[s_n-1];
				yylval = hash_insert(yytext,"CLOSE_F",line_num,scope,p_scope);
				return CLOSE_F;
			}

{FOR_KW} 	{
				/*yylval.idname=strdup(yytext);*/
				for_f = 1;
				yylval = hash_insert(yytext,"FOR_KW",line_num,scope,p_scope);
				return FOR_KW;
			}

{WHILE_KW} 	{
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"WHILE_KW",line_num,scope,p_scope);
				return WHILE_KW;
			}

{SWITCH_KW} {
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"SWITCH_KW",line_num,scope,p_scope);
				return SWITCH_KW;
			}

{IF_KW} {
			/*yylval.idname=strdup(yytext);*/
			yylval = hash_insert(yytext,"IF_KW",line_num,scope,p_scope);
			return IF_KW;
		}

{ELSE_KW} 	{
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"ELSE_KW",line_num,scope,p_scope);
				return ELSE_KW;
			}

{SCAN_KW} 	{
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"SCAN_KW",line_num,scope,p_scope);
				return SCAN_KW;
			}

{PRINT_KW} 	{
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"PRINT_KW",line_num,scope,p_scope);
				return PRINT_KW;
			}

{STRUCT_KW} {
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"STRUCT_KW",line_num,scope,p_scope);
				return STRUCT_KW;
			}

{RETURN_KW} {
				/*yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"RETURN_KW",line_num,scope,p_scope);
				return RETURN_KW;
			}

{ALPHA}({ALPHANUMERIC}|{UNDERSCORE})* {
				/*printf("Found Identifier: %s\n",yytext);yylval.idname=strdup(yytext);*/
				yylval = hash_insert(yytext,"ID",line_num,scope,p_scope);
				return ID;
			}

{CLOSE_S} 	{
				yylval = hash_insert(yytext,"CLOSE_S",line_num,scope,p_scope);
				return CLOSE_S;
			}

{OPEN_S} 	{
				yylval = hash_insert(yytext,"OPEN_S",line_num,scope,p_scope);
				return OPEN_S;
			}

{EQ_OP} {
			yylval = hash_insert(yytext,"EQ_OP",line_num,scope,p_scope);
			return EQ_OP;
		}

{LT_OP} {
			yylval = hash_insert(yytext,"LT_OP",line_num,scope,p_scope);
			return LT_OP;
		}

{GT_OP} {
			yylval = hash_insert(yytext,"GT_OP",line_num,scope,p_scope);
			return GT_OP;
		}

{LTE_OP}	{
				yylval = hash_insert(yytext,"LTE_OP",line_num,scope,p_scope);
				return LTE_OP;
			}

{GTE_OP}	{
				yylval = hash_insert(yytext,"GTE_OP",line_num,scope,p_scope);
				return GTE_OP;
			}

{ETE_OP}	{
				yylval = hash_insert(yytext,"ETE_OP",line_num,scope,p_scope);
				return ETE_OP;
			}

{OPEN_P}	{
				yylval = hash_insert(yytext,"OPEN_P",line_num,scope,p_scope);
				return OPEN_P;
			}

{CLOSE_P} 	{
				yylval = hash_insert(yytext,"CLOSE_P",line_num,scope,p_scope);
				return CLOSE_P;
			}  

<String>{STRING}	{
						BEGIN 0;
						yylval = hash_insert(yytext,"STRING",line_num,scope,p_scope);
						return STRING;
					}

<Char>{CHAR} 	{
					BEGIN 0;yylval = hash_insert(yytext,"CHAR",line_num,scope,p_scope);
					return CHAR;
				}

{D_QUOTES} 	{
				if(str==0){
					str=1;
					BEGIN String;
				}
				else {
					str=0;
					BEGIN 0;
				}
				yylval = hash_insert(yytext,"D_QUOTES",line_num,scope,p_scope);
				return D_QUOTES;
			}

{S_QUOTES} 	{
				if(chr==0){
					chr=1;
					BEGIN Char;
				}
				else {
					chr=0;
					BEGIN 0;
				}
				yylval = hash_insert(yytext,"S_QUOTES",line_num,scope,p_scope);
				return S_QUOTES;
			}

. 	{
		/*printf("Nothing matched: %s\n",yytext);*/
	}


%%

int yywrap(void)        /* called at end of input */
{
    //printf("In Wrap\n");
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

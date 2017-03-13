%{
    #include <stdio.h>
    #include <unistd.h>
    #include <fcntl.h>
    //#include "lex.yy.c"
    #include "hashing.c"
    extern int  yylex();
    extern void yyerror(char *);

    int line_num = 0;
    int h_scope = -1;   //highest scope
    int scope = -1;
    int p_scope = -2;
    int scope_st[30];
    int s_n = 0;
%}

%union
{
	int iVal;
	char *idname;
    //int line;
    //int scope;
    //int p_scope;
}

%token NEW_LINE SEM_COL COL OPEN_F CLOSE_F DATA_TYPE CLOSE_S OPEN_S EQUALS_OP LT_OP GT_OP LTE_OP GTE_OP ETE_OP OPEN_P CLOSE_P  D_QUOTES S_QUOTES

%token <idname> ID STRING CHAR KEYWORD ART_OP DIGIT 
%%
program:
        program NEW_LINE        { line_num++; }
        | program SEM_COL       { hash_insert(";","SEM_COL",line_num,scope,p_scope); }
        | program COL       { hash_insert(":","COL",line_num,scope,p_scope); }
        | program ART_OP        { hash_insert(yylval.idname,"ART_OP",line_num,scope,p_scope); }
        | program DIGIT         { hash_insert(yylval.idname,"DIGIT",line_num,scope,p_scope); }
        | program OPEN_F      { p_scope=scope;scope=++h_scope;scope_st[++s_n]=scope;hash_insert("{","OPEN_F",line_num,scope,p_scope); }
        | program CLOSE_F     { scope=scope_st[--s_n];p_scope=scope_st[s_n-1];hash_insert("}","CLOSE_F",line_num,scope,p_scope); }
        | program KEYWORD     { hash_insert(yylval.idname,"KEYWORD",line_num,scope,p_scope); }
        | program ID      { printf("Recivied ID %s\n",yylval.idname);hash_insert(yylval.idname,"ID",line_num,scope,p_scope); }
        | program CLOSE_S     { hash_insert("[","CLOSE_S",line_num,scope,p_scope); }
        | program OPEN_S      { hash_insert("]","OPEN_S",line_num,scope,p_scope); }
        | program EQUALS_OP       { hash_insert("=","EQUALS_OP",line_num,scope,p_scope); }
        | program LT_OP      { hash_insert("<","LT_OP",line_num,scope,p_scope); }
        | program GT_OP      { hash_insert(">","GT_OP",line_num,scope,p_scope); }
        | program LTE_OP      { hash_insert("<=","LTE_OP",line_num,scope,p_scope); }
        | program GTE_OP      { hash_insert(">=","GTE_OP",line_num,scope,p_scope); } 
        | program ETE_OP      { hash_insert("==","ETE_OP",line_num,scope,p_scope); }
        | program OPEN_P      { hash_insert("(","OPEN_P",line_num,scope,p_scope); }
        | program CLOSE_P     { hash_insert(")","CLOSE_P",line_num,scope,p_scope); }
        | program STRING      { hash_insert(yylval.idname,"STRING",line_num,scope,p_scope); }
        | program CHAR        { hash_insert(yylval.idname,"CHAR",line_num,scope,p_scope); }
        | program D_QUOTES        { hash_insert("\"","D_QUOTES",line_num,scope,p_scope); }
        | program S_QUOTES        { hash_insert("'","S_QUOTES",line_num,scope,p_scope); }
        | 
        ;


%%
void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

/*int main(void)
{
    printf("Entered main\n");
    init_symtable();
    //yyin=open("test.c","r");
    //yyout=open("op.c",'w');
    yyparse();
    printf("After yyparse\n");
    print_table();
    return 0;
}*/

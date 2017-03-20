%{
    #include <stdio.h>
    #include <unistd.h>
    #include <fcntl.h>
    //#include "lex.yy.c"
    //#include "hashing.c"
    extern int  yylex();
    extern void yyerror(char *);

    /*int line_num = 0;
    int h_scope = -1;   //highest scope
    int scope = -1;
    int p_scope = -2;
    int scope_st[30];
    int s_n = 0;*/
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
        program NEW_LINE        {  }
        | program SEM_COL       {  }
        | program COL       {  }
        | program ART_OP        {  }
        | program DIGIT         {  }
        | program OPEN_F      {  }
        | program CLOSE_F     {  }
        | program KEYWORD     {  }
        | program ID      {  }
        | program CLOSE_S     {  }
        | program OPEN_S      {  }
        | program EQUALS_OP       {  }
        | program LT_OP      {  }
        | program GT_OP      {  }
        | program LTE_OP      {  }
        | program GTE_OP      { } 
        | program ETE_OP      {  }
        | program OPEN_P      {  }
        | program CLOSE_P     {  }
        | program STRING      {  }
        | program CHAR        {  }
        | program D_QUOTES        {  }
        | program S_QUOTES        {  }
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

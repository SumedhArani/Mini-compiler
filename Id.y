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

%token NEW_LINE SEM_COL COL OPEN_F CLOSE_F DATA_TYPE CLOSE_S OPEN_S EQ_OP LT_OP GT_OP LTE_OP GTE_OP ETE_OP OPEN_P CLOSE_P  D_QUOTES S_QUOTES HF_NAME H_INC TYPE COMMA FOR_KW WHILE_KW SWITCH_KW IF_KW ELSE_KW SCAN_KW PRINT_KW STRUCT_KW RETURN_KW AND OR MUL PLUS MINUS DIV NTE_OP

%token <idname> ID STRING CHAR DIGIT 
%%

Include : 
        H_INC LT_OP HF_NAME GT_OP Include
        | H_INC D_QUOTES HF_NAME D_QUOTES Include
        | Ext_declarator
        ;

Ext_declarator : 
        Var_def SEM_COL Ext_declarator
        | Var_def EQ_OP Value SEM_COL Ext_declarator
        | Function_def
        ;

Function_def : 
        Var_def OPEN_P Formal_parameters1 CLOSE_P Body Function_def
        | 
        ;

Var_def : 
        Type ID
        ;


Body : 
    OPEN_F Expr CLOSE_F
    ;

Expr : 
    For Expr
    | Define Expr
    | Initialise Expr
    | Scan SEM_COL Expr
    | Print SEM_COL Expr
    | Assignment SEM_COL Expr
    | RETURN_KW Value SEM_COL
    | 
    ;

Assignment : 
            ID EQ_OP Operations
            ;


Operations : 
        Value
        | Operations Arthmetic_op Operations
        | MINUS Operations
        | OPEN_P Operations CLOSE_P
        ;

Arthmetic_op : 
            PLUS
            | MINUS
            | MUL
            | DIV
            ;

For : 
    FOR_KW OPEN_P For_initialise Condition For_expr CLOSE_P Body
    ;


For_initialise : 
                Initialise
                | Assignment Actual_parameters_PS SEM_COL
                | 
                ;


Condition : 
        Value Relational_op Value SEM_COL
        ;

Relational_op : 
            LT_OP
            | GT_OP
            | LTE_OP
            | GTE_OP
            | ETE_OP
            | NTE_OP
            ;

For_expr : 
        Scan
        | Print
        | ID EQ_OP Operations
        | 
        ;


Define :
    TYPE ID SEM_COL
    ;

Initialise :
         TYPE ID Actual_parameters_PS EQ_OP Value  SEM_COL
         ;


Scan : 
    SCAN_KW OPEN_P D_QUOTES STRING D_QUOTES Actual_parameters_PS CLOSE_P
    ;


Print : 
    PRINT_KW OPEN_P D_QUOTES STRING D_QUOTES Actual_parameters_PS CLOSE_P
    ;


Actual_parameters_PS : 
                COMMA Addr Assignment Actual_parameters_PS
                | COMMA Addr ID
                | 
                ;

Addr : 
    AND
    | MUL
    | 
    ;

Formal_parameters1 : 
                TYPE ID Formal_parameters2
                ;

Formal_parameters2 : 
                COMMA TYPE ID Formal_parameters2
                | 
                ;

Type : 
    TYPE
    | 
    ;

Value : 
        DIGIT
        | STRING
        | CHAR
        | ID
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

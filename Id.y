%{
    #include <stdio.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <string.h>
    #define SYMTABSIZE 997
    extern int yylex();
    extern void yyerror(char *);
    void errorHandler(int, void (*func)(void));
    void typeCheck();
    void undefinedUsage();
    #include "hashing.h"
    extern struct node symtab[SYMTABSIZE];
    int init=0;
    //int for_f=0;
    char *type;
%}

%token NEW_LINE SEM_COL COL OPEN_F CLOSE_F DATA_TYPE
%token CLOSE_S OPEN_S EQ_OP LT_OP GT_OP LTE_OP GTE_OP
%token ETE_OP OPEN_P CLOSE_P  D_QUOTES S_QUOTES HF_NAME
%token H_INC TYPE COMMA FOR_KW WHILE_KW SWITCH_KW IF_KW
%token ELSE_KW SCAN_KW PRINT_KW STRUCT_KW RETURN_KW AND
%token OR MUL PLUS MINUS DIV NTE_OP UN_MINUS UN_PLUS
%token ID STRING CHAR DIGIT D_DIGIT
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
    Type ID {symtab[$2].attr.data_type=strdup(symtab[$1].name);
            /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
            if(strcmp(symtab[$2].attr.data_type, "NIL")==0)
                errorHandler($2, undefinedUsage);
        }
    ;

Body : 
    OPEN_F Expr CLOSE_F
    | For
    | Define
    | Initialise
    | Unary SEM_COL
    | Scan SEM_COL
    | Print SEM_COL
    | Assignment SEM_COL
    | RETURN_KW Value SEM_COL 
    | 
    ;

Expr : 
    For Expr
    | Define Expr
    | Initialise Expr
    | Unary SEM_COL Expr
    | Scan SEM_COL Expr
    | Print SEM_COL Expr
    | Assignment SEM_COL Expr
    | RETURN_KW Value SEM_COL 
    | 
    ;

Assignment : 
    ID EQ_OP Operations {
        if(init==1){
            symtab[$3].attr.data_type=strdup(type);
        }
        else {
                init = 0;
                /*check if its data_type attribute is not NIL; if NIL-->print error*/
                if(strcmp(symtab[$3].attr.data_type, "NIL")==0)
                    errorHandler($3, undefinedUsage);
        }
    }
    ;


Operations : 
    Value
    | Operations Arthmetic_op Operations
    | MINUS Operations
    | Unary Operations
    | OPEN_P Operations CLOSE_P
    ;

Unary : 
    UN_MINUS Operations
    | Operations UN_MINUS
    | UN_PLUS Operations
    | Operations UN_PLUS
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
    | SEM_COL
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
    | ID EQ_OP Operations {
            /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
            if(strcmp(symtab[$1].attr.data_type, "NIL")==0)
                errorHandler($1, undefinedUsage);
        }
    | 
    ;


Define :
    TYPE ID SEM_COL  {symtab[$2].attr.data_type=strdup(symtab[$1].name);}
    ;

Initialise :
    TYPE ID Actual_parameters_PS EQ_OP Value  SEM_COL {
            //printf("Still in Initialise\n");
            init = 1;
            type=strdup(symtab[$1].name);
            symtab[$2].attr.data_type=strdup(symtab[$1].name);
        }
    ;


Scan : 
    SCAN_KW OPEN_P D_QUOTES STRING D_QUOTES Actual_parameters_PS CLOSE_P
    ;


Print : 
    PRINT_KW OPEN_P D_QUOTES STRING D_QUOTES Actual_parameters_PS CLOSE_P
    ;


Actual_parameters_PS : 
    COMMA Addr Assignment Actual_parameters_PS
    | COMMA Addr ID Actual_parameters_PS {
                    if(init==1){
                        symtab[$3].attr.data_type=strdup(type);
                    }
                    else {
                        /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
                        if(strcmp(symtab[$3].attr.data_type, "NIL")==0)
                            errorHandler($3, undefinedUsage);
                    }
                }
    |  {init = 0;}
    ;

Addr : 
    AND
    | MUL
    | 
    ;

Formal_parameters1 : 
    TYPE ID Formal_parameters2 {symtab[$2].attr.data_type=strdup(symtab[$1].name);}
    ;

Formal_parameters2 : 
    COMMA TYPE ID Formal_parameters2 {symtab[$3].attr.data_type=strdup(symtab[$2].name);}
    | 
    ;

Type : 
    TYPE
    | 
    ;

Value : 
    DIGIT {//printf("In Value: DIGIT\n");
            }
    | D_DIGIT {
            //printf("In Value: D_DIGIT\n");
            }
    | STRING
    | CHAR
    | ID    {
                /*check if its data_type attribute is not NIL; if NIL-->print error*/
                if(strcmp(symtab[$1].attr.data_type, "NIL")==0)
                    errorHandler($1, undefinedUsage);
            }
    ;

%%
void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

void errorHandler(int index, void (*func)(void))
{
    func();
    fprintf(stderr, "\tVariable : %s on ", symtab[index].name);
    fprintf(stderr, "Line Number : %d\n", symtab[index].line_num[symtab[index].ln-1]);
    
}

void typeCheck()
{
    yyerror("Type mismatch");
}

void undefinedUsage()
{
    yyerror("Undefined Usage");
}



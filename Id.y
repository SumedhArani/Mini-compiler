%{
    #include <stdio.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <string.h>
    #define SYMTABSIZE 997
    #define Color_Red "\033[0:31m" // Color Start
    #define Color_end "\033[0m" // To flush out prev settings
    #define LOG_RED(X) fprintf(stderr, "%s %s %s",Color_Red,X,Color_end)
    #define Color_Blue "\033[22;34m" // Color Start
    #define LOG_BLUE(X) fprintf(stderr, "%s %s %s",Color_Blue,X,Color_end)
    extern int yylex();
    extern void yyerror(char *);
    void errorHandler(int, int, void (*func)(int , int));
    void typeCheck(int , int );
    void undefinedUsage(int , int);
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
    | Var_def EQ_OP Value SEM_COL Ext_declarator {
                if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
            }
    | Function_def
    ;

Function_def : 
    Var_def OPEN_P Formal_parameters1 CLOSE_P Body Function_def
    | 
    ;

Var_def : 
    Type ID {   symtab[$2].attr.data_type=strdup(symtab[$1].name);
            /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
            if(strcmp(symtab[$2].attr.data_type, "NIL")==0)
                errorHandler($2, -1, undefinedUsage);
            $$ = $2;
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
            if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
        }
        else {
                init = 0;
                /*check if its data_type attribute is not NIL; if NIL-->print error*/
                if(strcmp(symtab[$3].attr.data_type, "NIL")==0)
                    errorHandler($3, -1, undefinedUsage);
                if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
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
                errorHandler($1, -1, undefinedUsage);
            if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
            $$ = $1;
        }
    | 
    ;


Define :
    TYPE ID SEM_COL  {
            symtab[$2].attr.data_type=strdup(symtab[$1].name);
            $$ = $2;
        }
    ;

Initialise :
    TYPE ID Actual_parameters_PS EQ_OP Value  SEM_COL {
            //printf("Still in Initialise\n");
            $$ = $2;
            init = 1;
            type=strdup(symtab[$1].name);
            symtab[$2].attr.data_type=strdup(symtab[$1].name);
            if(strcmp(symtab[$2].attr.data_type, symtab[$5].attr.data_type)!=0)
                    errorHandler($2, $5, typeCheck);
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
                    $$ = $1;
                    if(init==1){
                        symtab[$3].attr.data_type=strdup(type);
                    }
                    else {
                        /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
                        if(strcmp(symtab[$3].attr.data_type, "NIL")==0)
                            errorHandler($3, -1, undefinedUsage);
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
    TYPE ID Formal_parameters2 {
            $$ = $2;
            symtab[$2].attr.data_type=strdup(symtab[$1].name);
            symtab[$2].attr.p_scope=symtab[$2].attr.scope;
            symtab[$2].attr.scope=p_scope_table[29]+1;
        }
    ;

Formal_parameters2 : 
    COMMA TYPE ID Formal_parameters2 {
            $$ = $3;
            symtab[$3].attr.data_type=strdup(symtab[$2].name);
            symtab[$3].attr.p_scope=symtab[$3].attr.scope;
            symtab[$3].attr.scope=p_scope_table[29]+1;
        }
    | 
    ;

Type : 
    TYPE {$$ = $1;}
    | 
    ;

Value : 
    DIGIT   {
                $$ = $1;
            }
    | D_DIGIT {
                //printf("In Value: D_DIGIT\n");
                $$ = $1;
            }
    | STRING 
    | CHAR  { $$ = $1;}
    | ID    {   $$ = $1;
                /*check if its data_type attribute is not NIL; if NIL-->print error*/
                if(strcmp(symtab[$1].attr.data_type, "NIL")==0)
                    errorHandler($1, -1, undefinedUsage);
            }
    ;

%%
void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}

void errorHandler(int index1, int index2, void (*func)(int, int))
{
    func(index1, index2);
    int lineNumber = symtab[index1].line_num[symtab[index1].ln-1];
    static const char filename[] = "ip.c";
    FILE *file = fopen(filename, "r");
    int count = 0;
    if ( file != NULL )
    {   
        char line[256]; /* or other suitable maximum line size */
        while (fgets(line, sizeof line, file) != NULL) /* read a line */
        {   
            if (count == lineNumber)
            {   
                //use line or in a function return it
                //in case of a return first close the file with "fclose(file);"
                fprintf(stderr, " \033[0:36m@%s%d: >>\033[0m %s\n", filename, lineNumber, line);
                fclose(file);
                break;
            }   
            else
            {   
                count++;
            }   
        }   
        fclose(file);
    }
}

void typeCheck(int index1, int index2)
{
    LOG_BLUE("Error: Type Mismatch\n");
    char* name1 = symtab[index1].name;
    char* type1 = symtab[index1].attr.data_type;
    char* name2 = symtab[index2].name;
    char* type2 = symtab[index2].attr.data_type;
    fprintf(stderr, "  \033[0:31m%s\033[0m is of type \033[0:31m%s\033[0m", name1, type1);
    fprintf(stderr, " wheareas \033[0:31m%s\033[0m is of type \033[0:31m%s\033[0m\n", name2, type2);
}

void undefinedUsage(int index1, int index2)
{
    LOG_BLUE("Error: Undefined Usage\n");
    char* name1 = symtab[index1].name;
    fprintf(stderr, "  No previous definition found for \033[0:31m%s\033[0m\n", name1);
}
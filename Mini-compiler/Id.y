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
    void formatMismatch(int ,int);
    void no_formatMismatch(int ,int);
    #include "hashing.h"
    extern struct node symtab[SYMTABSIZE];
    int init = 0;
    int prs = 0;
    int str_pos = 0;
    int eq = 0;
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
    Type ID {   
        strcpy(symtab[$2].attr.data_type, symtab[$1].name);
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
            strcpy(symtab[$1].attr.data_type, type);
            if(strcmp(symtab[$1].attr.data_type, "NIL")==0)
                    errorHandler($1, -1, undefinedUsage);
            if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
        }
        else {
                init = 0;
                /*check if its data_type attribute is not NIL; if NIL-->print error*/
                if(strcmp(symtab[$1].attr.data_type, "NIL")==0)
                    errorHandler($1, -1, undefinedUsage);
                if(strcmp(symtab[$1].attr.data_type, symtab[$3].attr.data_type)!=0)
                    errorHandler($1, $3, typeCheck);
                if (prs != 0)
                        {
                            if(strcmp(symtab[str_pos].attr.for_spe[(prs)-1],"NIL") != 0)
                            {
                                if(strcmp(symtab[$1].attr.data_type, symtab[str_pos].attr.for_spe[(prs++)-1]) != 0)
                                {
                                    errorHandler($1, -1, formatMismatch);
                                    //printf("Argument Type Mismatch : In Id: %s ----In for_spe: %s\n",symtab[$1].name,symtab[str_pos].attr.for_spe[(prs)-2]);
                                }
                            }
                            else
                            {
                                errorHandler(1, -1, no_formatMismatch);
                            }
                        }
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
    UN_MINUS Operations SEM_COL
    | Operations UN_MINUS SEM_COL
    | UN_PLUS Operations SEM_COL
    | Operations UN_PLUS SEM_COL
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
            strcpy(symtab[$2].attr.data_type, symtab[$1].name);
            $$ = $2;
        }
    ;

Initialise :
    TYPE ID {
            init = 1;
            char* temp = (char*)malloc(100*sizeof(char));
            strcpy(temp, symtab[$1].name);
            type = temp;} Actual_parameters_PS End_Init {
            
            $$ = $2;
            init = 0;
            //printf("Init to 1\n");
            //printf("%s\n",symtab[$4].name);
            strcpy(symtab[$2].attr.data_type, symtab[$1].name);
            if (eq==1)
            {
                if(strcmp(symtab[$2].attr.data_type, symtab[$5].attr.data_type)!=0)
                {
                    //printf("From Here\n");
                    //printf("%s\n",symtab[$5].name);
                    errorHandler($2, $5, typeCheck);
                }
                eq = 0;
            }
            
        }
    ;

End_Init :
        SEM_COL
        | EQ_OP Value SEM_COL {eq = 1;$$ = $2;}
        ;

Scan : 
    SCAN_KW OPEN_P D_QUOTES STRING D_QUOTES Actual_parameters_PS CLOSE_P
    ;


Print : 
    PRINT_KW OPEN_P D_QUOTES {prs = 1;} STRING D_QUOTES {str_pos = $5;} Actual_parameters_PS CLOSE_P {if(strcmp(symtab[str_pos].attr.for_spe[(prs)-1],"NIL") != 0){errorHandler($5, 0, no_formatMismatch);}prs = 0;}
    | PRINT_KW OPEN_P CLOSE_P
    ;


Actual_parameters_PS : 
    COMMA Addr Assignment Actual_parameters_PS
    | COMMA Addr ID {
                    //$$ = $1;
                   // printf("not P\n");
                    //printf("now in par,type: %s\n",type);
                    if(init==1){
                        //printf("now in par wr init =1,type: %s\n",type);
                        strcpy(symtab[$3].attr.data_type, type);
                    }
                    else {
                        /*check if its(ID) data_type attribute is not NIL; if NIL-->print error*/
                        if(strcmp(symtab[$3].attr.data_type, "NIL")==0)
                            errorHandler($3, -1, undefinedUsage);
                        if (prs != 0)
                        {
                            if(strcmp(symtab[str_pos].attr.for_spe[(prs)-1],"NIL") != 0)
                            {
                                if(strcmp(symtab[$3].attr.data_type, symtab[str_pos].attr.for_spe[(prs++)-1]) != 0)
                                {
                                    errorHandler($3, -1, formatMismatch);
                                    //printf("Argument Type Mismatch : In Id: %s ----In for_spe: %s\n",symtab[$3].name,symtab[str_pos].attr.for_spe[(prs)-2]);
                                }
                            }
                            else
                            {
                                errorHandler($3, 1, no_formatMismatch);
                            }
                        }
                    }
                } Actual_parameters_PS 
    |  {//printf("Exiting Act par\n");
        }
    ;

Addr : 
    AND
    | MUL
    | 
    ;

Formal_parameters1 : 
    TYPE ID Formal_parameters2 {
            $$ = $2;
            strcpy(symtab[$2].attr.data_type, symtab[$1].name);
            symtab[$2].attr.p_scope=symtab[$2].attr.scope;
            symtab[$2].attr.scope=p_scope_table[29]+1;
        }
    ;

Formal_parameters2 : 
    COMMA TYPE ID Formal_parameters2 {
            $$ = $3;
            strcpy(symtab[$3].attr.data_type, symtab[$2].name);
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
                //printf("In Value\n");
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
                fprintf(stderr, " \033[0:36m@%s:%d >>\033[0m %s\n", filename, lineNumber, line);
                fclose(file);
                return ;
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
    LOG_BLUE("ERROR: Type Mismatch\n");
    char* name1 = symtab[index1].name;
    char* type1 = symtab[index1].attr.data_type;
    char* name2 = symtab[index2].name;
    char* type2 = symtab[index2].attr.data_type;
    fprintf(stderr, "  \033[0:31m%s\033[0m is of type \033[0:31m%s\033[0m", name1, type1);
    fprintf(stderr, " wheareas \033[0:31m%s\033[0m is of type \033[0:31m%s\033[0m\n", name2, type2);
}

void undefinedUsage(int index1, int index2)
{
    LOG_BLUE("ERROR: Undefined Usage\n");
    char* name1 = symtab[index1].name;
    fprintf(stderr, "  No previous definition found for \033[0:31m%s\033[0m\n", name1);
}

void formatMismatch(int index1,int index2)
{
    LOG_BLUE("WARNING: Format Specifier Mismatch\n");

    char* f_type = symtab[str_pos].attr.for_spe[prs-2];
    char* id_type = symtab[index1].attr.data_type;
    char* fs = (char*)malloc(10*sizeof(char));
    int res = strcmp(f_type,"a");
    //printf("%d\n",res);
    switch (res)
    {
        case 18:
            strcpy(fs,"%s");
            break;
        case 2:
            strcpy(fs,"%c");
            break;
        case 8:
            strcpy(fs,"%d");
            break;
        case 5:
            strcpy(fs,"%f");
            break;
    }
    //printf("%s\n",fs);

/*
int-8
char-2
string-18
float-5
*/
/*int res = strcmp(f_type,"a"); the value of res is checked in switch cases*/

    fprintf(stderr, " Format \033[0:31m%s\033[0m expects a matching \033[0:31m%s\033[0m", fs, f_type);
    fprintf(stderr, " but argument \033[0:31m%d\033[0m is of type \033[0:31m%s\033[0m\n", prs-1, id_type);    
}

void no_formatMismatch(int index1,int index2)
{
    LOG_BLUE("WARNING: Number of arguments Mismatch\n");
    if (index2 == 1)
    {
        fprintf(stderr, "  Too many arguments for printf\n");
    }
    else
    {
        fprintf(stderr, "  Not Enough arguments for printf\n");
    }
}


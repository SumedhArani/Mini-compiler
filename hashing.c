#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#define SYMTABSIZE 997

struct attribute{
char *data_type;
int scope;
int p_scope;
};

struct node{
	char *name;
	char *type;
	struct attribute attr;
	int line_num[30];
	int ln;
};

struct node symtab[SYMTABSIZE];

int hash(char *str,int i);
int hash_insert(char *str,char *typ,int line_n,int scp,int p_scp) ;
int hash_search(char *str,int scp);
void init_symtable();
void print_table();

int hash(char *str,int i)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *(str++)))
    {
        hash = ((hash << 4) + hash) + c; /* hash * 33 + c */
    }

    return ((int)((hash+i)%SYMTABSIZE));
}
int hash_insert(char *str,char *typ,int line_n,int scp,int p_scp) 
{
	printf("inserting %s\n",str);
	int k=hash_search(str,scp);
	if(k==-1) {
		int i=0;
		int j;
		while(i<SYMTABSIZE) {
			j=hash(str,i);
			if(strcmp(symtab[j].name,"NIL")==0) {
				strcpy(symtab[j].name,str);
				symtab[j].type=(char*)malloc(10*sizeof(char));
				strcpy(symtab[j].type,typ);
				symtab[j].line_num[symtab[j].ln++]=line_n;
				symtab[j].attr.scope=scp;
				symtab[j].attr.p_scope=p_scp;
				return j;
			}
			i++;
		}
	}
	else 
	{
		symtab[k].line_num[symtab[k].ln++]=line_n;
	}
	return (-1);
}
int hash_search(char *str,int scp)
{
	int i=0;
	int j=hash(str,i);
	while((i<SYMTABSIZE) && (strcmp(symtab[j].name,"NIL")!=0)) {
		if(strcmp(symtab[j].name,str)==0 && symtab[j].attr.scope==scp) {
			return j;
		}
		i++;
		j=hash(str,i);
	}
	return (-1);
}
void init_symtable()
{
	int k;
	for(k=0;k<SYMTABSIZE;k++) {
		symtab[k].name=(char *)malloc (100 + 1);
		strcpy(symtab[k].name,"NIL");
		symtab[k].ln=0;
	}
	printf("Symbol table initialised\n");
	return ;
}
void print_table()
{
	int i;
	printf("SYMBOL TABLE\n");
	printf("----------------------------------------------------\n");
	printf("|INDEX\t|NAME\t|TYPE\t\t| SCOPE NUMBER\t| LINE NUMBERS |\n");
	printf("----------------------------------------------------\n");
	for(i=0;i<SYMTABSIZE;i++) {
		if(strcmp(symtab[i].name,"NIL")!=0)
		{
			printf("|%d\t|%s\t%s\t\t|%d\t|",i,symtab[i].name,symtab[i].type,symtab[i].attr.scope);
			int j=0;
			//printf("LINE NUMBERS:");
			for(;j<symtab[i].ln-1;j++)
			{
				printf("%d, ",symtab[i].line_num[j]);
			}
			printf("%d\n",symtab[i].line_num[j]);
		}
	}
	printf("----------------------------------------------------\n");
return;
}
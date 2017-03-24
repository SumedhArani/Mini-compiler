#ifndef HASHING
#define HASHING

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

int p_scope_table[30];
struct node symtab[SYMTABSIZE];

int hash(char *str,int i);
int hash_insert(char *str,char *typ,int line_n,int scp,int p_scp) ;
int hash_search(char *str,int scp);
void init_symtable();
void print_table();

#endif
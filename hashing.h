struct attribute;
struct node;

int hash(char *str,int i);
int hash_insert(char *str,char *typ,int line_n,int scp,int p_scp) ;
int hash_search(char *str,int scp);
void init_symtable();
void print_table();
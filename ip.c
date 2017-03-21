#include<stdio.h>
#include<stdlib.h>

int main(int argc, char argv)
{

	
	 yyin = fp;
	 scope_st=-1;
	int p=yyparse;
	printf("Hello%d\n",p);
	for( a = 10,b=9; a < 20; a = a + 1 ){
      printf("For%d\n", a);
   }

}

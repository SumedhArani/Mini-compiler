Id.out : y.tab.c lex.yy.c hashing.o table.o main.o 
	gcc -std=c11 hashing.o table.o main.o -o Id.out
y.tab.c : Id.y
	yacc -d Id.y
lex.yy.c : Id.l
	lex Id.l
hashing.o : hashing.c hashing.h
	gcc -c -std=c11 hashing.c
table.o : table.h table.c
	gcc -c -std=c11 table.c
main.o : main.c hashing.h Id.y Id.l
	gcc -c -std=c11 main.c

clean:
	rm *.o*
	rm y.tab.*
	rm lex.yy.c
	rm *.*~
	
test: Id.out
	./Id.out ip.c

symtable: Id.out
	./Id.out ip.c -symtable
Id.out : y.tab.c lex.yy.c hashing.o main.o 
	gcc -std=c11 hashing.o main.o -o Id.out
y.tab.c : Id.y
	yacc -d Id.y
lex.yy.c : Id.l
	lex Id.l
hashing.o : hashing.c hashing.h
	gcc -c -std=c11 hashing.c
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
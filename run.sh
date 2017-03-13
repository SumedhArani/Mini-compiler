$(lex Id.l)
$(yacc -d Id.y)
$(gcc main.c)
./a.out $1
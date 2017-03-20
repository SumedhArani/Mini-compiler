$(lex Id.l)
$(yacc -d Id.y)
$(gcc main.c)
./a.out $

#!/bin/bash
IN=$1
arrIN=(${IN//./ })

lex ${arrIN[0]}".l"
yacc -d ${arrIN[0]}".y"
gcc main.c -o ${arrIN[0]}".out"
./${arrIN[0]}".out" $2
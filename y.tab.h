/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NEW_LINE = 258,
     SEM_COL = 259,
     COL = 260,
     OPEN_F = 261,
     CLOSE_F = 262,
     DATA_TYPE = 263,
     CLOSE_S = 264,
     OPEN_S = 265,
     EQ_OP = 266,
     LT_OP = 267,
     GT_OP = 268,
     LTE_OP = 269,
     GTE_OP = 270,
     ETE_OP = 271,
     OPEN_P = 272,
     CLOSE_P = 273,
     D_QUOTES = 274,
     S_QUOTES = 275,
     HF_NAME = 276,
     H_INC = 277,
     TYPE = 278,
     COMMA = 279,
     FOR_KW = 280,
     WHILE_KW = 281,
     SWITCH_KW = 282,
     IF_KW = 283,
     ELSE_KW = 284,
     SCAN_KW = 285,
     PRINT_KW = 286,
     STRUCT_KW = 287,
     RETURN_KW = 288,
     AND = 289,
     OR = 290,
     MUL = 291,
     PLUS = 292,
     MINUS = 293,
     DIV = 294,
     NTE_OP = 295,
     UN_MINUS = 296,
     UN_PLUS = 297,
     ID = 298,
     STRING = 299,
     CHAR = 300,
     DIGIT = 301,
     D_DIGIT = 302
   };
#endif
/* Tokens.  */
#define NEW_LINE 258
#define SEM_COL 259
#define COL 260
#define OPEN_F 261
#define CLOSE_F 262
#define DATA_TYPE 263
#define CLOSE_S 264
#define OPEN_S 265
#define EQ_OP 266
#define LT_OP 267
#define GT_OP 268
#define LTE_OP 269
#define GTE_OP 270
#define ETE_OP 271
#define OPEN_P 272
#define CLOSE_P 273
#define D_QUOTES 274
#define S_QUOTES 275
#define HF_NAME 276
#define H_INC 277
#define TYPE 278
#define COMMA 279
#define FOR_KW 280
#define WHILE_KW 281
#define SWITCH_KW 282
#define IF_KW 283
#define ELSE_KW 284
#define SCAN_KW 285
#define PRINT_KW 286
#define STRUCT_KW 287
#define RETURN_KW 288
#define AND 289
#define OR 290
#define MUL 291
#define PLUS 292
#define MINUS 293
#define DIV 294
#define NTE_OP 295
#define UN_MINUS 296
#define UN_PLUS 297
#define ID 298
#define STRING 299
#define CHAR 300
#define DIGIT 301
#define D_DIGIT 302




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;


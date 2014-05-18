/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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
     IDENT = 258,
     NAME = 259,
     PATH = 260,
     STRING = 261,
     NUMBER = 262,
     SELECT = 263,
     FROM = 264,
     WHERE = 265,
     CONNECT = 266,
     DISCONNECT = 267,
     TO = 268,
     LIST = 269,
     TABLES = 270,
     AND = 271,
     DESCRIBE = 272,
     TABLE = 273,
     LTEQ = 274,
     GTEQ = 275,
     LIKE = 276
   };
#endif
/* Tokens.  */
#define IDENT 258
#define NAME 259
#define PATH 260
#define STRING 261
#define NUMBER 262
#define SELECT 263
#define FROM 264
#define WHERE 265
#define CONNECT 266
#define DISCONNECT 267
#define TO 268
#define LIST 269
#define TABLES 270
#define AND 271
#define DESCRIBE 272
#define TABLE 273
#define LTEQ 274
#define GTEQ 275
#define LIKE 276




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2068 of yacc.c  */
#line 36 "parser.y"

	char *name;
	double dval;
	int ival;



/* Line 2068 of yacc.c  */
#line 100 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



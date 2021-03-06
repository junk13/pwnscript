%{
#include "node.h"
#include <stdio.h>
#include <string.h>

node_t *prog;
extern int yylex();

void yyerror(const char *s) {
    printf("ERROR: %s\n", s);
}

%}

%union {
    node_t *node;
    char *string;
    int token;
}

%token <string> IDENT DOUBLE INT TSTRING
%token <token> LPAR RPAR LBRC RBRC LSQU RSQU DOT COM TFN EOL SQUOTE DQUOTE

%start program

%%

program: stmts                      {prog = $<node>1;}
       ;

stmt: fn | fncall | ident | num | string
    ;

stmts: stmt EOL                     {$<node>$ = node_fn(NULL, $<node>1);}
     | stmts stmt EOL               {node_add($<node>1->block, $<node>2);}
     ;

stmt_list: stmt                     {$<node>$ = node_fn(NULL, $<node>1);}
         | stmt_list COM stmt       {node_add($<node>1->block, $<node>3);}
         | // empty                 {$<node>$ = node_fn(NULL, NULL);}
         ;

ident: IDENT                        {$<node>$ = node_atom(ID, $1);}
     ;

string: TSTRING                     {$<node>$ = node_atom(STRING, strndup($1 + 1, strlen($1) - 2));}

num: INT                            {$<node>$ = node_atom(NUM, $1);}
   | DOUBLE                         {$<node>$ = node_atom(NUM, $1);}
   ;

fn: TFN LPAR stmt_list RPAR
  LBRC stmts RBRC                         {$<node>$ = node_fn($<node>3, $<node>6);}
  ;

fncall: ident LPAR stmt_list RPAR   {$<node>$ = node_call($<node>1, $<node>3);}
      ;

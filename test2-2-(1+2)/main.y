%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#define YYSTYPE double
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD SUB MUL DIV NUMBER LPAREN RPAREN
%left ADD SUB
%left MUL DIV
%right UMINUS


%%

lines :  lines expr ':' {printf("%g\n",$2);}
      |  lines ':'
      |
      ;

expr  :   expr ADD expr {$$=$1+$3;}
      |  expr SUB expr {$$=$1-$3;}
      |  expr MUL expr {$$=$1*$3;}
      |  expr DIV expr {$$=$1/$3;}
      |  LPAREN expr RPAREN  {$$=$2;}
      |  SUB expr %prec UMINUS {$$=-$2;}
      |  NUMBER 
      ;
%%

int yylex()
{
   int t;
   while(1)
   {
     t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(isdigit(t)){
            yylval=0;
            while(isdigit(t)){
              yylval=yylval*10+t-'0';
              t=getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return SUB;
        }else if(t=='*'){
            return MUL;
        }else if(t=='/'){
            return DIV;
        }else if(t=='('){
            return LPAREN;
        }else if(t==')'){
            return RPAREN;
        }
        else{
            return t;
        }  
   }
}
   

int main(void)
{
   yyin = stdin;
  do{
      yyparse();
    }while(!feof(yyin));
  return 0;
}
void yyerror(const char* s)
{
   fprintf(stderr,"Parse error:%s\n",s);
   exit(1);
}


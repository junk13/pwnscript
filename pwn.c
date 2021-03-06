#include <stdio.h>
#include "node.h"

extern node_t *prog;
extern int yyparse();

void node_dump(node_t *node, int level) {
    if(!node) return;
    do {
#define SPACELEVEL for(i = 0; i < level * 3; i++) putchar(' ');
        int i = 0;
        switch(node->t) {
            case FNCALL:
                SPACELEVEL;
                puts("FNCALL {");
                SPACELEVEL;
                puts("   CALLERS {");
                node_dump(node->callers, level + 2);
                SPACELEVEL;
                puts("   }");
                SPACELEVEL;
                puts("   CALLEES {");
                node_dump(node->callees, level + 2);
                SPACELEVEL;
                puts("   }");
                SPACELEVEL;
                puts("}");
                break;
            case FN:
                SPACELEVEL;
                puts("FN {");
                SPACELEVEL;
                puts("   ARGS {");
                node_dump(node->args, level + 2);
                SPACELEVEL;
                puts("   }");
                SPACELEVEL;
                puts("   BLOCK {");
                node_dump(node->block, level + 2);
                SPACELEVEL;
                puts("   }");
                SPACELEVEL;
                puts("}");
                break;
            case NUM:
                SPACELEVEL;
                printf("NUM { %s }\n", node->s);
                break;
            case ID:
                SPACELEVEL;
                printf("ID { %s }\n", node->s);
                break;
            case STRING:
                SPACELEVEL;
                printf("STRING { %s }\n", node->s);
                break;
        }
    } while (node = node->next);
}

int main() {
    if(yyparse() == 0) {
        node_dump(prog, 0);
    }
    node_free(prog);
    return 0;
}

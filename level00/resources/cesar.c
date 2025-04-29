#include <stdio.h>
#include <stdlib.h>

int main(int ac, char **av) 
{
    if (ac != 2) {
        printf("Enter a text to decrypt");
        exit(1);
    }
    
    char c;
    for (int rot = 0; rot <= 25; rot++) {
        int i = 0;
        printf("rot %d -> ", rot );
        while ((c = av[1][i++])) {
            if (c >= 'a' && c <= 'z')
                c = ((c - 'a' + rot) % 26) + 'a';
            else if (c >= 'A' && c <= 'Z')
                c = ((c - 'A' + rot) % 26) + 'A';
            putchar(c);
        }
        putchar('\n');
    }
   return 0;
}
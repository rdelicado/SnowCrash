// Formula for decrypting the message
// o[i] = e[i] − i

#include <unistd.h>
#include <string.h>

int main(int argc, char **argv)
{
    int i, len;
    char *e;

    if (argc != 2) return 1;
    e = argv[1];
    len = strlen(e);
    for (i = 0; i < len; i++)
    {
        char o = e[i] - i;
        write(1, &o, 1);
    }
    write(1, "\n", 1);
    return 0;
}
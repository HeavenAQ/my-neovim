#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    if (system("ls -l") == -1) {
        perror("system");
        exit(EXIT_FAILURE);
    }
}

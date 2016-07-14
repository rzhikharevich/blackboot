#include "input.h"
#include "integer.h"
#include "heap.h"
#include "platform.h"
#include "output.h"


char *gets(void) {
    char *str = malloc(1);
    usize size = 0;

    while ((str[size] = plat->keyboard_getch()) != '\n') {
        putc(str[size]);
        if (str[size] != '\b')
            str = realloc(str, ++size + 1);
        else if (size)
            size--;
    }

    str[size] = '\0';
    putc('\n');

    return str;
}

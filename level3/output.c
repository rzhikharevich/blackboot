#include "output.h"
#include "platform.h"
#include "video.h"


static int x = 0;
static int y = 0;


void putc(int ch) {
    switch (ch) {
    case '\n':
        x = 0;
        y++;
        break;
    case '\b':
        if (x)
            video_putc(--x * 8, y * 16, ' ', 0);
        break;
    case '\r':
        x = 0;
        break;
    default:
        video_putc(x++ * 8, y * 16, ch, 0);
        break;
    }
}

void puts(const char *str) {
    print(str);
    x = 0;
    y++;
}

void print(const char *str) {
    while (*str)
        putc(*str++);
}

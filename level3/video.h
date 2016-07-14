#ifndef _VIDEO_H_
#define _VIDEO_H_


#include "integer.h"
#include "attr.h"


enum {
    VIDEO_FORMAT_8BIT,
    VIDEO_FORMAT_CUSTOM
};

typedef struct {
    u16  w;
    u16  h;
    u8   fmt;
    uptr fb;
    u8   bpp;
    u8   red_sz;
    u8   red_pos;
    u8   green_sz;
    u8   green_pos;
    u8   blue_sz;
    u8   blue_pos;
} PACKED video_info_t;

#define VIDEO_RGB(r, g, b) ((r) << 16 | (g) << 8 | (b))
#define VIDEO_RGB_C(c, o)  (((c) >> (o)) & 15)
#define VIDEO_RGB_R(c)     VIDEO_RGB_C(c, 16)
#define VIDEO_RGB_G(c)     VIDEO_RGB_C(c, 8)
#define VIDEO_RGB_B(c)     VIDEO_RGB_C(c, 0)

typedef void (*video_put_pixel_t)(int x, int y, int color);
extern video_put_pixel_t video_put_pixel;

void video_putc(int x, int y, int ch, int color);
void video_puts(int x, int y, const char *str, int color);
void video_init(void);


#endif

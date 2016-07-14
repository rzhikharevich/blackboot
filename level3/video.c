#include "video.h"
#include "integer.h"
#include "platform.h"


video_put_pixel_t video_put_pixel;

static void video_ignore(void) {}

static void video_put_pixel_8bit(int x, int y, int color) {
    *(u8 *)(plat->video_info->fb + plat->video_info->w * y + x) = (u8)color;
}

static void video_put_pixel_custom(int x, int y, int color) {
    // TODO: do this properly
    *(u16 *)(plat->video_info->fb + y * plat->video_info->w * plat->video_info->bpp / 8 + x * plat->video_info->bpp / 8) = color;
}

void video_putc(int x, int y, int ch, int color) {
    x += 8;
    for (int y1 = 0; y1 < 16; y1++)
        for (int x1 = 0; x1 < 8; x1++)
            if (plat->font[ch * 16 + y1] & (1 << x1))
                video_put_pixel(x - x1, y + y1, 0xFFFF);
            else
                video_put_pixel(x - x1, y + y1, 0);
}

void video_puts(int x, int y, const char *str, int color) {
    while (*str) {
        video_putc(x, y, *str++, color);
        x += 8;
    }
}

void video_init(void) {
    switch (plat->video_info->fmt) {
        case VIDEO_FORMAT_8BIT:
            video_put_pixel = video_put_pixel_8bit;
            break;
        case VIDEO_FORMAT_CUSTOM:
            video_put_pixel = video_put_pixel_custom;
            break;
        default:
            video_put_pixel = (video_put_pixel_t)video_ignore;
            break;
    }
}

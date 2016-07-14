#ifndef _PLATFORM_TABLE_H_
#define _PLATFORM_TABLE_H_


#include "integer.h"
#include "attr.h"
#include "video.h"


#ifdef __i386__
#define PLATFORM_API __attribute__((fastcall))
#else
#define PLATFORM_API
#endif

#define PLATFORM_PACKET PACKED


typedef struct {
    u8  id;
    u32 blkn;
    u64 slba;
} PLATFORM_PACKET storage_addr_t;

typedef struct {
    PLATFORM_API int (*storage_read)(void *dst, storage_addr_t *src);
    u8 storage_boot_n;

    PLATFORM_API void (*power_reset)(void);
    PLATFORM_API void (*power_shutdown)(void);

    PLATFORM_API int (*keyboard_getch)(void);

    video_info_t *video_info;
    char         *font;
} PACKED platform_table_t;

extern platform_table_t *plat;


#endif

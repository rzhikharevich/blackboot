#include "heap.h"
#include "platform.h"
#include "input.h"
#include "output.h"
#include "mbr.h"


platform_table_t *plat;


void finish(const char *reason) {
    puts(reason);
    puts("Press any key to reboot.");
    plat->keyboard_getch();
    plat->power_reset();
}

PLATFORM_API void level3(platform_table_t *plat_, void *heap_base) {
    plat = plat_;

    video_init();

    heap_init(heap_base);

    mbr_t *mbr = malloc(512);
    storage_addr_t test = {.id = 0x80, .blkn = 1, .slba = 0};
    if (plat->storage_read(mbr, &test))
        finish("Failed to read the first sector of the boot storage.");

    if (mbr->magic == 0xAA55) {
        puts("mbr->magic is valid.");
    }

    puts("Finish.");

    __asm__ __volatile__ (
        "cli\n"
        "hlt\n"
    );
}

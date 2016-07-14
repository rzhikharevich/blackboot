#include "heap.h"
#include "string.h"


static heap_block_header_t *last;
static void *heap_base;

#define PAGE_SIZE          4096
#define PAGE_ALIGN_ADDR(a) ((a) + PAGE_SIZE - (a) % PAGE_SIZE)

void *malloc(usize size) {
    heap_block_header_t *header = 0;

    if (last) {
        heap_block_header_t *srch;
        for (;;) {
            srch = last->prev;
            if (!srch)
                break;

            if ((uptr)srch->data + srch->size + sizeof(heap_block_header_t) + size <= (uptr)srch->next) {
                header = (heap_block_header_t *)((uptr)srch->data + srch->size);
                header->prev = srch;
                header->next = srch->next;
                srch->next->prev = header;
                srch->next = header;
                break;
            }
        }

        if (!header) {
            header = (heap_block_header_t *)((uptr)last->data + last->size);
            header->prev = last;
            header->next = 0;
            last = header;
        }
    } else {
        header = heap_base;
        header->prev = 0;
        header->next = 0;
        last = header;
    }

    header->size  = size;
    header->align = 1;

    return header->data;
}

void *valloc(usize size) {
    heap_block_header_t *header = 0;

    if (last) {
        heap_block_header_t *srch;
        for (;;) {
            srch = last->prev;
            if (!srch)
                break;

            if (PAGE_ALIGN_ADDR((uptr)srch->data + srch->size) + sizeof(heap_block_header_t) + size <= (uptr)srch->next) {
                header = (heap_block_header_t *)((uptr)srch->data + srch->size);
                header->prev = srch;
                header->next = srch->next;
                srch->next->prev = header;
                srch->next = header;
                break;
            }
        }

        if (!header) {
            header = (heap_block_header_t *)PAGE_ALIGN_ADDR((uptr)last->data + last->size);
            header->prev = last;
            header->next = 0;
            last = header;
        }
    } else {
        header = (heap_block_header_t *)PAGE_ALIGN_ADDR((uptr)heap_base);
        header->prev = 0;
        header->next = 0;
        last = header;
    }

    header->size  = size;
    header->align = 1;

    return header->data;
}

void *realloc(void *obj, usize size) {
    if (!obj)
        return malloc(size);

    heap_block_header_t *header = (heap_block_header_t *)obj - 1;

    if (header->next && (uptr)header->data + size > (uptr)header->next) {
        if (header->prev)
            header->prev->next = header->next;
        if (header->next)
            header->next->prev = header->prev;

        return memcpy(header->align? valloc(size) : malloc(size), header->data, header->size);
    }

    header->size = size;

    return header->data;
}

void *reallocf(void *obj, usize size) {
    void *new_obj = realloc(obj, size);
    if (!new_obj)
        free(obj);

    return new_obj;
}

void free(void *obj) {
    if (!obj)
        return;

    heap_block_header_t *header = (heap_block_header_t *)obj - 1;

    if (!header->next)
        last = header->prev;
    else
        header->next->prev = header->prev;

    if (header->prev)
        header->prev->next = header->next;
}

void heap_init(void *base) {
    last = 0;
    heap_base = base;
}

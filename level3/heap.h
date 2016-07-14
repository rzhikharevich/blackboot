#ifndef _HEAP_H_
#define _HEAP_H_


#include "integer.h"


typedef struct _heap_block_header {
    struct _heap_block_header *prev;
    struct _heap_block_header *next;
    usize size;
    int   align;
    char  data[];
} heap_block_header_t;

void *malloc(usize size);
void *valloc(usize size);
void *realloc(void *obj, usize size);
void free(void *obj);
void heap_init(void *base);


#endif

#include "string.h"


void *memcpy(void *dst, void *src, usize size) {
    for (usize i = 0; i < size; i++)
        ((char *)dst)[i] = ((char *)src)[i];

    return dst;
}

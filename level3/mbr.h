#ifndef _MBR_H_
#define _MBR_H_


#include "attr.h"
#include "integer.h"


typedef struct {
    u8 bootable;

    u8 st_head;
    u8 st_sect;
    u8 st_cyl;

    u8 system_id;

    u8 end_head;
    u8 end_sect;
    u8 end_cyl;

    u32 lba;
    u32 sect_n;
} PACKED mbr_ent_t;

#define MBR_ENT_BOOTABLE 0x80

typedef struct {
    char code[436];
    char id[10];
    mbr_ent_t ent[4];
    u16  magic;
} PACKED mbr_t;

#define MBR_MAGIC 0xAA55


#endif

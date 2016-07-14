#ifndef _GPT_H_
#define _GPT_H_


#include "attr.h"
#include "integer.h"


#define GPT_SIGNATURE 0x5452415020494645
#define GPT_REV       0x10000


#define GPT_ATTR_SYS         1
#define GPT_ATTR_EFI_IGNORE  2
#define GPT_ATTR_LEGACY_BOOT 4


typedef struct {
	u64 signature;
	u32 rev;
	u32 hdr_size;
	u32 hdr_crc32;
	u32 reserved;
	u64 hdr_lba;
	u64 hdr_copy_lba;
	u64 part_st_lba;
	u64 part_end_lba;
	u8 disk_guid[16];
	u64 pt_lba;
	u32 pt_ent_n;
	u32 pt_ent_sz;
	u32 pt_crc32;
} PACKED gpt_t;


typedef struct {
	u8 type[16];
	u8 guid[16];
	u64 st_lba;
	u64 end_lba;
	u64 flags;
	char16 name[];
} PACKED gpt_ent_t;


#endif

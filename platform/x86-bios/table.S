    section .data

platform_table:
.storage_read   dd storage_read
.storage_boot_n db 0x80
.power_reset    dd power_reset
.power_shutdown dd power_shutdown
.keyboard_getch dd keyboard_getch
.video_info     dd video_info
.font           dd 0x6000

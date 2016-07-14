struc VBEInfo
.signature resb 4
.version   resw 1
.oemstring resd 1
.capab     resb 4
.vmodes    resd 1
; ...
endstruc

struc VBEModeInfo
.attr      resw 1
.a_attr    resb 1
.b_attr    resb 1
.granul    resw 1
.win_size  resw 1
.a_seg     resw 1
.b_seg     resw 1
.win_func  resd 1
.scanln_sz resw 1
; VBE 1.2+
.x_res     resw 1
.y_res     resw 1
.ch_width  resb 1
.ch_height resb 1
.plane_n   resb 1
.pix_bits  resb 1
.bank_n    resb 1
.mem_model resb 1
.bank_sz   resb 1 ; in KB
.img_n     resb 1
.rsrv0     resb 1
.red_sz    resb 1
.red_pos   resb 1
.green_sz  resb 1
.green_pos resb 1
.blue_sz   resb 1
.blue_pos  resb 1
.rsrv_sz   resb 1
.rsrv_pos  resb 1
.dcm_info  resb 1
; VBE 2.0+
.fb        resd 1
endstruc

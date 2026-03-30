;
; This file contains the intrinsics used for serial communication
;

section .text

global write_port_uchar
global read_port_uchar

write_port_uchar:
    mov  al, dl     ; stash value in AL before DX is clobbered
    mov  dx, cx     ; port number → DX (out instruction requires DX)
    out  dx, al     ; write AL to I/O port DX
    ret

read_port_uchar:
    mov  dx, cx     ; port number → DX (in instruction requires DX)
    in   al, dx     ; read byte from I/O port DX into AL
    ret


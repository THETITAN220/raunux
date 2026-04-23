ORG 0x7C00
BITS 16

section .data
    boot_drive db 0

section .text
start:
    # Cleaning all the segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    # Setup stack
    mov sp, 0x7C00

    # Save boot drive
    mov [boot_drive], dl

    # Load the sector
    mov ah, 0x02
    mov al, 1

    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]

    mov bx, 0x0000
    mov es, 0x1000

    int 0x13
    jc disk_error

    # Jump to loaded code
    jmp 0x1000:0x0000

disk_error:
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    jmp $

times 510 - ($-$$) db 0
dw 0xAA55

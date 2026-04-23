[ORG 0x7C00]
[BITS 16]

section .text
global _start

_start:
    mov bl, dl

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [BOOT_DRIVE], bl

    mov si, msg_load
    call print_string

    mov ah, 0x00
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc disk_error

    mov ah, 0x42
    mov dl, [BOOT_DRIVE]
    mov si, disk_address_packet
    int 0x13
    jc disk_error

    jmp 0x7E00

disk_error:
    mov bh, ah

    mov si, msg_error
    call print_string

    mov al, bh
    shr al, 4
    call print_hex_nibble

    mov al, bh
    and al, 0x0F
    call print_hex_nibble

    jmp halt

print_hex_nibble:
    cmp al, 9
    jle .is_digit
    add al, 0x37
    jmp .print
.is_digit:
    add al, '0'
.print:
    mov ah, 0x0E
    int 0x10
    ret

halt:
    cli
    hlt
    jmp halt

print_string:
    mov ah, 0x0E
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

BOOT_DRIVE db 0
msg_load   db "Loading stage 2 (LBA)...", 0x0D, 0x0A, 0
msg_error  db "Disk error: 0x", 0

align 4
disk_address_packet:
    db 0x10
    db 0
    dw 1
    dw 0x7E00
    dw 0x0000
    dq 1

times 510 - ($ - $$) db 0
dw 0xAA55

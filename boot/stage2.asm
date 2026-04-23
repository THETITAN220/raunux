[ORG 0x7E00]
[BITS 16]

section .text

stage2_start:
    mov si, msg_success
    call print_string

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

msg_success db "Stage 2 successfully loaded in sector 2.", 0x0D, 0x0A, 0

times 512 - ($ - $$) db 0

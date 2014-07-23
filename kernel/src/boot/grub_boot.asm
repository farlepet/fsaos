ENTRYPOINT equ 0x00100000

[org ENTRYPOINT]

ALIGN 4                             ; It must be on a 4-byte boundry
mboot:
    dd 0x1BADB002                   ; Magic number
    dd 0x00010003                   ; Flags
    dd -(0x00010003 + 0x1BADB002)   ; Checksum
    dd mboot                        ; Header address
    dd ENTRYPOINT                   ; Load address
    dd 0x00000000                   ; Load end, not necessary
    dd 0x00000000                   ; BSS end, not necessary
    dd kernel                       ; Execution entrypoint

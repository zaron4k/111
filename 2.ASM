format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

    msg_sum db "Test sum of primes: %d", 10, 0
    prompt_exit db "Press any key to exit...", 10, 0

section '.code' code readable executable

start:
    mov eax, 101
    add eax, 103
    add eax, 107         ; eax = 311

    push eax
    push msg_sum
    call [printf]
    add esp, 8

    push prompt_exit
    call [printf]
    add esp, 4

    call [getch]

    xor eax, eax
    ret

section '.idata' import data readable

    library msvcrt, 'msvcrt.dll'
    import msvcrt, printf, 'printf', getch, '_getch'
